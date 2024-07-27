import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:news_app/models/article.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/screens/news_detail.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({
    super.key,
    this.favoriteNews,
    this.category,
  });

  final List<Article>? favoriteNews;

  final Category? category;

  Future<List<Article>> _getCurrentNews() async {
    final dio = Dio();
    final categoryString = category!.name;
    final response = await dio.get(
        'https://newsapi.org/v2/top-headlines?country=in&category=$categoryString&apiKey=3097687994004e5a8cdc149f1059488e');
    News news = News.fromJson(response.data);
    return news.articles;
  }

  void _onNewsTapped(BuildContext context, Article article) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => NewsDetailScreen(),
        settings: RouteSettings(arguments: article)));
  }

  @override
  Widget build(BuildContext context) {
    if (category != null) {
      return Scaffold(
        body: FutureBuilder(
          future: _getCurrentNews(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching news. Please try again later.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (ctx, index) => const Divider(),
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    _onNewsTapped(context, snapshot.data![index]);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data![index].imageUrl),
                      radius: 30,
                    ),
                    title: Text(snapshot.data![index].title),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    if (favoriteNews != null) {
      if (favoriteNews!.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              'No news bookmarked yet. Please bookmark and visit later.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      }
      return Scaffold(
        body: ListView.separated(
          itemCount: favoriteNews!.length,
          separatorBuilder: (ctx, index) => const Divider(),
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onTap: () {
                _onNewsTapped(context, favoriteNews![index]);
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(favoriteNews![index].imageUrl),
                  radius: 30,
                ),
                title: Text(favoriteNews![index].title),
              ),
            );
          },
        ),
      );
    }
    return const Center(
      child: Text('Error'),
    );
  }
}
