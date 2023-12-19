class DownloadItem {
  final String id;
  final String filePath;

  DownloadItem({required this.id, required this.filePath});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
    };
  }

  factory DownloadItem.fromJson(Map<String, dynamic> json) => DownloadItem(id: json['id'], filePath: json['filePath']);
}
