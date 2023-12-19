import 'package:dio/dio.dart';
import 'package:example_app/core/data/storage.dart';
import 'package:example_app/core/exceptions/exceptions.dart';
import 'package:example_app/features/journal/data/data_source/sqlite_service.dart';
import 'package:example_app/features/journal/data/models/journal_model.dart';
import 'package:example_app/features/journal/domain/entities/journal_content_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:path_provider/path_provider.dart';

abstract class JournalDataSource {
  Future<List<JournalModel>> getAllJournals();
  Future<bool> downloadOneJournal({required String fileUrl, required String title, required Function(double) callback});
  Future<List<FormzSubmissionStatus>> downloadAllJournal(
      List<JournalEntity> journals, List<Function(double, JournalEntity)> callbacks);
}

class JournalDataSourceImpl extends JournalDataSource {
  final Dio dio;
  final SqliteService sqliteService;

  JournalDataSourceImpl({required this.dio, required this.sqliteService});

  @override
  Future<List<FormzSubmissionStatus>> downloadAllJournal(
      List<JournalEntity> journals, List<Function(double, JournalEntity)> callbacks) async {
    List<Future> downloads = [];
    for (var element in journals) {
      var dir = await getApplicationSupportDirectory();
      final fileName = (element.fileUrl).split('/').last;
      final extension = fileName.split(".");

      final result = dio.download(
        element.fileUrl,
        onReceiveProgress: (count, total) {
          final percentage = count * 100 / total;
          callbacks[journals.indexOf(element)].call(percentage, element);
        },
        '${dir.path}/${extension.first}.${extension.last}',
      );
      downloads.add(result);
    }
    final response = await Future.wait(downloads);

    debugPrint("TTTTT ${response}");
    final List<FormzSubmissionStatus> statuses = [];
    for (int i = 0; i < response.length; i++) {
      try {
        if ((response[i] as Response<ResponseBody>).statusCode! >= 200 &&
            (response[i] as Response<ResponseBody>).statusCode! <= 300) {
          var dir = await getApplicationSupportDirectory();
          final fileName = journals[i].fileUrl.split('/').last;
          final extension = fileName.split(".");
          await sqliteService.createItem(fileName, '${dir.path}/${extension.first}.${extension.last}');
          statuses.add(FormzSubmissionStatus.success);
        } else {
          statuses.add(FormzSubmissionStatus.failure);
        }
      } catch (e) {
        debugPrint("TTTTT catch $e");
        statuses.add(FormzSubmissionStatus.failure);
      }
    }

    return statuses;
  }

  @override
  Future<bool> downloadOneJournal(
      {required String fileUrl, required String title, required Function(double) callback}) async {
    try {
      var dir = await getApplicationSupportDirectory();
      if (fileUrl.startsWith('http:')) {
        fileUrl.replaceFirst('http:', 'https:');
      }
      final fileName = (fileUrl).split('/').last;
      final extension = fileName.split(".");

      final result = await dio.download(
        onReceiveProgress: (count, total) {
          callback.call(count * 100 / total);
        },
        fileUrl,
        '${dir.path}/${extension.first}.${extension.last}',
      );
      if (result.statusCode! >= 200 && result.statusCode! <= 300) {
        await sqliteService.createItem(fileName, '${dir.path}/${extension.first}.${extension.last}');

        return Future.value(true);
      }
    } catch (e) {
      return Future.value(true);
    }
    return false;
  }

  @override
  Future<List<JournalModel>> getAllJournals() async {
    try {
      final response = await dio.get('https://run.mocky.io/v3/b85c88cb-4cb9-4ee3-ab4d-5302790a4f55');

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        return (response.data as List<dynamic>)
            .map((e) => JournalModel(id: e['id'], title: e['title'], fileUrl: e['file_url']))
            .toList();
        return (response.data as List<dynamic>).map((e) => JournalModel.fromJson(e)).toList();
      } else {
        throw ServerException(statusCode: response.statusCode!, errorMessage: "");
      }
    } on DioException {
      rethrow;
    } on Exception catch (e) {
      debugPrint('TTTTT $e');
      throw ParsingException(errorMessage: e.toString());
    }
  }
}
