part of 'journal_bloc.dart';

@immutable
class JournalState extends Equatable {
  final List<JournalEntity> journals;
  final FormzSubmissionStatus status;

  const JournalState({this.journals = const [], this.status = FormzSubmissionStatus.initial});

  JournalState copyWith({List<JournalEntity>? journals, FormzSubmissionStatus? status}) {
    return JournalState(
      journals: journals ?? this.journals,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        journals,
        status,
      ];
}
