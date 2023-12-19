import 'package:example_app/core/exceptions/exceptions.dart';
import 'package:example_app/features/journal/data/data_source/journal_datasource.dart';
import 'package:example_app/features/journal/data/data_source/sqlite_service.dart';
import 'package:example_app/features/journal/domain/entities/download_entity.dart';
import 'package:example_app/features/journal/domain/entities/journal_content_entity.dart';
import 'package:example_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:example_app/utils/either.dart';
import 'package:example_app/utils/failures.dart';
import 'package:formz/formz.dart';

class JournalRepositoryImpl extends JournalRepository {
  final JournalDataSource journalDataSource;
  final SqliteService sqliteService;

  JournalRepositoryImpl({required this.journalDataSource, required this.sqliteService});

  @override
  Future<Either<Failure, List<FormzSubmissionStatus>>> downloadAllJournal({
    required List<JournalEntity> journals,
    required List<Function(double, JournalEntity)> callbacks,
  }) async {
    try {
      final response = await journalDataSource.downloadAllJournal(journals, callbacks);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    } on Exception catch (e) {
      return Left(ParsingFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> downloadOneJournal(
      {required String fileUrl, required String title, required Function(double) callback}) async {
    try {
      final response = await journalDataSource.downloadOneJournal(fileUrl: fileUrl, title: title, callback: callback);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    } on Exception catch (e) {
      return Left(ParsingFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntity>>> getAllJournals() async {
    try {
      final response = await journalDataSource.getAllJournals();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } on DioException {
      return Left(DioFailure());
    } on Exception catch (e) {
      return Left(ParsingFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DownloadItem>>> getDownloadedItems() async {
    try {
      return Right(await sqliteService.getItems());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
