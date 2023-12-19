import 'package:equatable/equatable.dart';
import 'package:example_app/core/data/service_locator.dart';
import 'package:example_app/core/usecases/usecase.dart';
import 'package:example_app/features/journal/domain/entities/journal_content_entity.dart';
import 'package:example_app/features/journal/domain/usecases/donwload_journals_usecase.dart';
import 'package:example_app/features/journal/domain/usecases/donwload_one_journal_usecase.dart';
import 'package:example_app/features/journal/domain/usecases/get_all_journals_usecase.dart';
import 'package:example_app/features/journal/domain/usecases/get_downloaded_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'journal_event.dart';

part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc() : super(const JournalState()) {
    final GetAllJournalUseCase getAllJournalUseCase = GetAllJournalUseCase(serviceLocator.call());
    final DownloadAllJournalsUseCase downloadAllJournalsUseCase = DownloadAllJournalsUseCase(serviceLocator.call());
    final DownloadOneJournalUseCase downloadOneJournalUseCase = DownloadOneJournalUseCase(serviceLocator.call());
    final GetDownloadedJournalUseCase getDownloadedJournalUseCase = GetDownloadedJournalUseCase(serviceLocator.call());

    on<LoadAllJournals>((event, emit) async {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      final downloads = await getDownloadedJournalUseCase.call(NoParams());
      final result = await getAllJournalUseCase.call(NoParams());

      if (result.isRight) {
        if (downloads.isRight) {
          final newList = result.right.map((e) {
            final fileName = (e.fileUrl).split('/').last;
            if (downloads.right.map((e) => e.id).toList().contains(fileName)) {
              return e.copyWith(status: FormzSubmissionStatus.success);
            } else {
              return e;
            }
          }).toList();
          emit(state.copyWith(status: FormzSubmissionStatus.success, journals: newList));
        } else {
          emit(state.copyWith(status: FormzSubmissionStatus.success, journals: result.right));
        }
      } else {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    });

    on<DownloadOneJournal>((event, emit) async {
      final newList = state.journals.map((e) {
        if (e.id == event.journalEntity.id) {
          return e.copyWith(status: FormzSubmissionStatus.inProgress);
        }
        return e;
      }).toList();

      emit(state.copyWith(journals: newList));

      final result = await downloadOneJournalUseCase.call(
        DownloadJournalParams(
          event.journalEntity.fileUrl,
          event.journalEntity.title,
          (p0) {
            final newList = state.journals.map((e) {
              if (e.id == event.journalEntity.id) {
                return e.copyWith(status: FormzSubmissionStatus.inProgress, downloadedPercentage: p0.toInt());
              }
              return e;
            }).toList();
            emit(state.copyWith(journals: newList));
          },
        ),
      );
      if (result.isRight) {
        final newList = state.journals.map((e) {
          if (e.id == event.journalEntity.id) {
            return e.copyWith(status: FormzSubmissionStatus.success);
          }
          return e;
        }).toList();

        emit(state.copyWith(journals: newList));
      } else {
        final newList = state.journals.map((e) {
          if (e.id == event.journalEntity.id) {
            return e.copyWith(status: FormzSubmissionStatus.failure);
          }
          return e;
        }).toList();

        emit(state.copyWith(journals: newList));
      }
    });

    on<DownloadAllJournals>((event, emit) async {
      final downloads = state.journals.where((element) => !element.status.isSuccess).toList();
      final newList = state.journals.map((e) {
        if (!e.status.isSuccess) {
          return e.copyWith(status: FormzSubmissionStatus.inProgress);
        }
        return e;
      }).toList();
      emit(state.copyWith(journals: newList));
      final result = await downloadAllJournalsUseCase.call(DownloadAllJournalsParams(
          downloads,
          List.generate(downloads.length, (index) {
            return (percentage, journalEntity) {
              final nList = state.journals.map((e) {
                if (e.id == journalEntity.id) {
                  if (percentage == 100) {
                    return e.copyWith(downloadedPercentage: percentage.toInt(), status: FormzSubmissionStatus.success);
                  }
                  return e.copyWith(downloadedPercentage: percentage.toInt());
                }
                return e;
              }).toList();
              emit(state.copyWith(journals: nList));
            };
          })));
      if (result.isRight) {
        final newList = state.journals.map((e) {
          final index = downloads.map((e) => e.fileUrl).toList().indexOf(e.fileUrl);
          if (downloads.map((e) => e.fileUrl).contains(e.fileUrl)) {
            debugPrint("TTTTT ${result.right[index]}");
            return e.copyWith(status: result.right[index]);
          }
          return e;
        }).toList();
        emit(state.copyWith(journals: newList));
      } else {
        final newList = state.journals.map((e) {
          if (downloads.contains(e)) {
            return e.copyWith(status: FormzSubmissionStatus.failure);
          }
          return e;
        }).toList();
        emit(state.copyWith(journals: newList));
      }
    });
  }
}
