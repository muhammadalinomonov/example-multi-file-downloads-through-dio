part of 'journal_bloc.dart';

@immutable
abstract class JournalEvent {}

class LoadAllJournals extends JournalEvent {}

class DownloadOneJournal extends JournalEvent {
  final JournalEntity journalEntity;

  DownloadOneJournal({required this.journalEntity});
}

class DownloadAllJournals extends JournalEvent {}
