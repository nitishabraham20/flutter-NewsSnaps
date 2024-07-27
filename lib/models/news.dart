import 'package:news_app/models/article.dart';

enum Category { general, sports, technology, entertainment, business, science }

class News {
  News({required this.articles});

  final List<Article> articles;

  factory News.fromJson(Map<String, dynamic> json) {
    var jsonList = json['articles'] as List;
    List<Article> articles =
        jsonList.map((article) => Article.fromJson(article)).toList();
    return News(articles: articles);
  }
}
