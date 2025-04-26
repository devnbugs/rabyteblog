class Author {
  final String name;
  final String avatarUrl;
  final String avatarUrlHD;
  final int id;
  final String description;
  final String authorUrl;
  Author({
    required this.name,
    required this.avatarUrl,
    required this.id,
    required this.description,
    required this.authorUrl,
    required this.avatarUrlHD,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id']?.toInt() ?? 0,
      name: json['name'] ?? '',
      avatarUrl: json['avatar_urls']['24'] ?? '',
      avatarUrlHD: json['avatar_urls']['96'] ?? '',
      description: json['description'],
      authorUrl: json['url'],
    );
  }
}
