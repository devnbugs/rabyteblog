
class CommentModel {
  final int id;
  final String author;
  final String? avatar;
  final String content;
  final DateTime date;
  final int parent;

  CommentModel({required this.id, required this.author, this.avatar, required this.content, required this.date, required this.parent});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      author: json['author_name'],
      avatar: json['author_avatar_urls']["48"] ?? "https://icon-library.com/images/avatar-icon/avatar-icon-27.jpg",
      content: json["content"]["rendered"],
      date: DateTime.parse("${json['date_gmt']}Z").toLocal(),
      parent: json['parent']
    );
  }



  
}
