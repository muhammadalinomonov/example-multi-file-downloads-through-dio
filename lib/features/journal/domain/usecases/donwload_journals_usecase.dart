import 'package:example_app/core/usecases/usecase.dart';
import 'package:example_app/features/journal/domain/entities/journal_content_entity.dart';
import 'package:example_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:example_app/utils/either.dart';
import 'package:example_app/utils/failures.dart';
import 'package:formz/formz.dart';

class DownloadAllJournalsUseCase implements UseCase<List<FormzSubmissionStatus>, DownloadAllJournalsParams> {
  final JournalRepository journalRepository;

  DownloadAllJournalsUseCase(this.journalRepository);
  @override
  Future<Either<Failure, List<FormzSubmissionStatus>>> call(DownloadAllJournalsParams params) {
    return journalRepository.downloadAllJournal(journals: params.journals, callbacks: params.callbacks);
  }
}

class DownloadAllJournalsParams {
  final List<JournalEntity> journals;
  final List<Function(double, JournalEntity)> callbacks;

  DownloadAllJournalsParams(this.journals, this.callbacks);
}
