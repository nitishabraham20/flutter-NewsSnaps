import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/models/article.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/providers/favorites_provider.dart';
import 'package:news_app/screens/news_detail.dart';
import 'package:news_app/services/api_service.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({
    super.key,
    this.favoriteNews,
    this.category,
  });

  final List<Article>? favoriteNews;

  final Category? category;

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  late Future<List<Article>> currentNews;

  var isLongPressed = false;

  List<int> pressedIndex = [];

  var isPulledToRefresh = false;

  Future<void> _handleRefresh() async {
    isPulledToRefresh = true;

    if (widget.category != null) {
      try {
        final latestNews = await ApiService.getNews(widget.category!);
        setState(() {
          currentNews = Future.value(latestNews);
        });
      } catch (e) {
        print('Error in fetching news, $e');
      }
    }
  }

  void _onNewsTapped(BuildContext context, Article article) {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (ctx) => const NewsDetailScreen(),
    //     settings: RouteSettings(arguments: article)));
    Navigator.pushNamed(context, NewsDetailScreen.routeName,
        arguments: article);
  }

  void _selectAllNews() {
    List<int> selectedNews = [];
    for (var i = 0; i < widget.favoriteNews!.length; i++) {
      selectedNews.add(i);
    }
    setState(() {
      pressedIndex = selectedNews;
    });
  }

  void _removeFavoriteNews() {
    for (var index in pressedIndex) {
      ref
          .read(favoritesProvider.notifier)
          .removeFavoriteNews(widget.favoriteNews![index]);
    }
    pressedIndex = [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category != null) {
      if (!isPulledToRefresh) {
        currentNews = ApiService.getNews(widget.category!);
      }
      return Scaffold(
        body: FutureBuilder(
          future: currentNews,
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
            isPulledToRefresh = false;
            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      _onNewsTapped(context, snapshot.data![index]);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        children: [
                          Image.network(
                            snapshot.data![index].imageUrl,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data![index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }

    if (widget.favoriteNews != null) {
      if (widget.favoriteNews!.isEmpty) {
        isLongPressed = false;
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
        floatingActionButton: isLongPressed
            ? ElevatedButton(
                onPressed: _removeFavoriteNews,
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                child: const Text(
                  'REMOVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: isLongPressed
            ? AppBar(
                actions: [
                  TextButton(
                    onPressed: _selectAllNews,
                    child: const Text(
                      'Select all',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLongPressed = false;
                        pressedIndex = [];
                      });
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              )
            : null,
        body: ListView.separated(
          itemCount: widget.favoriteNews!.length,
          separatorBuilder: (ctx, index) => const Divider(),
          itemBuilder: (ctx, index) {
            return GestureDetector(
              onTap: () {
                if (isLongPressed) {
                  if (pressedIndex.contains(index)) {
                    setState(() {
                      pressedIndex.remove(index);
                    });
                  } else {
                    setState(() {
                      pressedIndex.add(index);
                    });
                  }
                } else {
                  _onNewsTapped(context, widget.favoriteNews![index]);
                }
              },
              onLongPress: () {
                setState(() {
                  isLongPressed = true;
                  pressedIndex.add(index);
                });
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.favoriteNews![index].imageUrl),
                  radius: 30,
                ),
                title: Text(widget.favoriteNews![index].title),
                trailing: isLongPressed
                    ? Icon(pressedIndex.contains(index)
                        ? Icons.check_circle
                        : Icons.check_circle_outline)
                    : null,
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
