import 'package:example_app/core/usecases/usecase.dart';
import 'package:example_app/features/journal/domain/entities/journal_content_entity.dart';
import 'package:example_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:example_app/utils/either.dart';
import 'package:example_app/utils/failures.dart';

class GetAllJournalUseCase implements UseCase<List<JournalEntity>, NoParams> {
  final JournalRepository journalRepository;

  GetAllJournalUseCase(this.journalRepository);
  @override
  Future<Either<Failure, List<JournalEntity>>> call(NoParams params) {
    return journalRepository.getAllJournals();
  }
}
