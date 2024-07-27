import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/models/article.dart';
import 'package:news_app/models/favorites_box.dart';

class FavoriteNewsNotifier extends StateNotifier<List<Article>> {
  FavoriteNewsNotifier() : super([]);

  void toggleFavoriteNews(Article article) {
    final isFavorite = state.contains(article);
    if (isFavorite) {
      state = state.where((a) => a.id != article.id).toList();
      favoritesBox.delete(article.id);
    } else {
      state = [...state, article];
      favoritesBox.put(article.id, article);
    }
  }

  void removeFavoriteNews(Article article) {
    state = state.where((a) => a.id != article.id).toList();
    favoritesBox.delete(article.id);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoriteNewsNotifier, List<Article>>(
        (ref) => FavoriteNewsNotifier());
