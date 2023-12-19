import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class JournalEntity extends Equatable {
  final String id;
  final String title;
  final FormzSubmissionStatus status;
  final String fileUrl;
  final int downloadedPercentage;

  const JournalEntity({
    this.id = '',
    this.title = '',
    this.fileUrl = '',
    this.downloadedPercentage = 0,
    this.status = FormzSubmissionStatus.initial,
  });

  JournalEntity copyWith({String? id, String? title, String? fileUrl, FormzSubmissionStatus? status, int? downloadedPercentage}) {
    return JournalEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      fileUrl: fileUrl ?? this.fileUrl,
      status: status ?? this.status,
      downloadedPercentage: downloadedPercentage ?? this.downloadedPercentage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        fileUrl,
        status,
        downloadedPercentage,
      ];
}
