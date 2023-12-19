import 'package:example_app/features/journal/domain/entities/journal_content_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class JournalModel extends JournalEntity {
  const JournalModel({
    super.id,
    super.title,
    super.fileUrl,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) => _$JournalModelFromJson(json);

  Map<String, dynamic> toJson() => _$JournalModelToJson(this);
}
