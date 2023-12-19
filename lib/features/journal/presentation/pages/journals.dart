import 'package:example_app/features/journal/presentation/blocs/journal_bloc.dart';
import 'package:example_app/features/journal/presentation/widgets/journal_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class JournalsScreen extends StatefulWidget {
  const JournalsScreen({super.key});

  @override
  State<JournalsScreen> createState() => _JournalsScreenState();
}

class _JournalsScreenState extends State<JournalsScreen> {
  late JournalBloc journalBloc;

  @override
  void initState() {
    journalBloc = JournalBloc()..add(LoadAllJournals());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: journalBloc,
      child: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      journalBloc.add(DownloadAllJournals());
                    },
                    child: Text("Hammasini yuklash"),
                  ),
                )
              ],
            ),
            body: (state.status.isSuccess && state.journals.isNotEmpty)
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return JournalItem(
                          journalEntity: state.journals[index],
                          downloadTap: () {
                            journalBloc.add(DownloadOneJournal(journalEntity: state.journals[index]));
                          });
                    },
                    itemCount: state.journals.length,
                  )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          );
        },
      ),
    );
  }
}
