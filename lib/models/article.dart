import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'article.g.dart';

@HiveType(typeId: 1)
class Article {
  Article({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.date,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String content;

  @HiveField(5)
  final String url;

  @HiveField(6)
  final String imageUrl;

  @HiveField(7)
  final String date;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: const Uuid().v4(),
        author: json['author'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        content: json['content'] ?? '',
        url: json['url'] ?? '',
        imageUrl: json['urlToImage'] ?? '',
        date: json['publishedAt'] ?? '',
      );
}
