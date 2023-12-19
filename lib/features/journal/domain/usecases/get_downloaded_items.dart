import 'package:example_app/core/usecases/usecase.dart';
import 'package:example_app/features/journal/domain/entities/download_entity.dart';
import 'package:example_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:example_app/utils/either.dart';
import 'package:example_app/utils/failures.dart';

class GetDownloadedJournalUseCase implements UseCase<List<DownloadItem>, NoParams> {
  final JournalRepository journalRepository;

  GetDownloadedJournalUseCase(this.journalRepository);
  @override
  Future<Either<Failure, List<DownloadItem>>> call(NoParams params) {
    return journalRepository.getDownloadedItems();
  }
}
