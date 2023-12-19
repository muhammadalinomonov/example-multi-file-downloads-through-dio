import 'package:example_app/features/journal/domain/entities/journal_content_entity.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class JournalItem extends StatefulWidget {
  const JournalItem({super.key, required this.journalEntity, required this.downloadTap});

  final JournalEntity journalEntity;
  final VoidCallback downloadTap;

  @override
  State<JournalItem> createState() => _JournalItemState();
}

class _JournalItemState extends State<JournalItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.journalEntity.title),
          Text('${widget.journalEntity.downloadedPercentage}'),
          if (widget.journalEntity.status.isInProgress)
            const CircularProgressIndicator.adaptive()
          else if (widget.journalEntity.status.isFailure)
            const Icon(Icons.warning)
          else if (widget.journalEntity.status.isInitial)
            GestureDetector(
              onTap: () {
                widget.downloadTap.call();
              },
              child: const Icon(Icons.download),
            )
          else
            Icon(Icons.done_all)
        ],
      ),
    );
  }
}
