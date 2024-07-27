import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/models/article.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/services/api_service.dart';

class NewsNotifier extends StateNotifier<List<Article>> {
  NewsNotifier() : super([]);

  var isLoading = false;

  Future<void> fetchNews(Category category) async {
    try {
      isLoading = true;
      final news = await ApiService.getNews(category);
      state = [...news];
      isLoading = false;
    } catch (e) {
      print('Error in fetching news, $e');
    }
  }
}

final newsProvider =
    StateNotifierProvider<NewsNotifier, List<Article>>((ref) => NewsNotifier());
