import 'package:dio/dio.dart';

import 'package:news_app/models/article.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/constants.dart';

class ApiService {
  static Future<List<Article>> getNews(Category category) async {
    final dio = Dio();
    final response = await dio.get(newsUrlString, queryParameters: {
      'country': country,
      'category': category.name,
      'apiKey': apiKey
    });
    if (response.statusCode == 200) {
      News news = News.fromJson(response.data);
      return news.articles
          .where((article) => article.imageUrl.isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}
