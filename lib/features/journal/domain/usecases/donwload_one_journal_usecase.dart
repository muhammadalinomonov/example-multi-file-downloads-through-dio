import 'package:example_app/core/usecases/usecase.dart';
import 'package:example_app/features/journal/domain/entities/journal_content_entity.dart';
import 'package:example_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:example_app/utils/either.dart';
import 'package:example_app/utils/failures.dart';

class DownloadOneJournalUseCase implements UseCase<bool, DownloadJournalParams> {
  final JournalRepository journalRepository;

  DownloadOneJournalUseCase(this.journalRepository);
  @override
  Future<Either<Failure, bool>> call(DownloadJournalParams params) {
    return journalRepository.downloadOneJournal(fileUrl: params.fileUrl, title: params.title, callback: params.calback);
  }
}

class DownloadJournalParams {
  final String fileUrl;
  final String title;
  final Function(double) calback;

  DownloadJournalParams(this.fileUrl, this.title, this.calback);
}
