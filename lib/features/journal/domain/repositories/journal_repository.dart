import 'package:example_app/features/journal/domain/entities/download_entity.dart';
import 'package:example_app/features/journal/domain/entities/journal_content_entity.dart';
import 'package:example_app/utils/either.dart';
import 'package:example_app/utils/failures.dart';
import 'package:formz/formz.dart';

abstract class JournalRepository {
  Future<Either<Failure, List<JournalEntity>>> getAllJournals();
  Future<Either<Failure, bool>> downloadOneJournal(
      {required String fileUrl, required String title, required Function(double) callback});
  Future<Either<Failure, List<FormzSubmissionStatus>>> downloadAllJournal(
      {required List<JournalEntity> journals, required List<Function(double, JournalEntity)> callbacks});
  Future<Either<Failure, List<DownloadItem>>> getDownloadedItems();
}
