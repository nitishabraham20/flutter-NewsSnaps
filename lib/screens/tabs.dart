import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/models/article.dart';
import 'package:news_app/models/favorites_box.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/providers/favorites_provider.dart';
//import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/news_updated.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  var _tabIndex = 0;

  var _selectedCategory = Category.general;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(favoritesProvider);

    final List<Article> favoriteNews = [];
    for (var i = 0; i < favoritesBox.length; i++) {
      favoriteNews.add(favoritesBox.getAt(i));
    }

    Widget activeScreen = NewsScreen(
      category: _selectedCategory,
    );

    if (_tabIndex == 1) {
      activeScreen = NewsScreen(
        favoriteNews: favoriteNews,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_tabIndex == 0 ? 'News' : 'Bookmarks'),
        actions: [
          if (_tabIndex == 0)
            PopupMenuButton(
              icon: const Icon(Icons.filter_alt),
              initialValue: _selectedCategory,
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: Category.general,
                  child: const Text('All'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = Category.general;
                    });
                    // ref
                    //     .read(newsProvider.notifier)
                    //     .fetchNews(_selectedCategory);
                  },
                ),
                PopupMenuItem(
                  value: Category.sports,
                  child: const Text('Sports'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = Category.sports;
                    });
                    // ref
                    //     .read(newsProvider.notifier)
                    //     .fetchNews(_selectedCategory);
                  },
                ),
                PopupMenuItem(
                  value: Category.technology,
                  child: const Text('Tech'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = Category.technology;
                    });
                    // ref
                    //     .read(newsProvider.notifier)
                    //     .fetchNews(_selectedCategory);
                  },
                ),
                PopupMenuItem(
                  value: Category.entertainment,
                  child: const Text('Entertainment'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = Category.entertainment;
                    });
                    // ref
                    //     .read(newsProvider.notifier)
                    //     .fetchNews(_selectedCategory);
                  },
                ),
                PopupMenuItem(
                  value: Category.business,
                  child: const Text('Business'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = Category.business;
                    });
                    // ref
                    //     .read(newsProvider.notifier)
                    //     .fetchNews(_selectedCategory);
                  },
                ),
                PopupMenuItem(
                  value: Category.science,
                  child: const Text('Science'),
                  onTap: () {
                    setState(() {
                      _selectedCategory = Category.science;
                    });
                    // ref
                    //     .read(newsProvider.notifier)
                    //     .fetchNews(_selectedCategory);
                  },
                ),
              ],
            )
        ],
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _tabIndex = value;
          });
        },
        currentIndex: _tabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_rounded),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }
}
