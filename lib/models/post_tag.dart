class PostTag {
  final int id;
  final String name;
  final int? postCount;


  PostTag({
    required this.id,
    required this.name,
    this.postCount
  });

  factory PostTag.fromJson (Map<String, dynamic> json){
    return PostTag(
      id: json['id'],
      name: json['name'],
      postCount: json['count'] ?? 0
    );
  }
  
}