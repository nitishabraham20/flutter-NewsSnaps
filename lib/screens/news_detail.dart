import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/models/favorites_box.dart';
import 'package:news_app/providers/favorites_provider.dart';
import 'package:news_app/models/article.dart';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({
    super.key,
  });

  //final Article article;

  // String get date {
  //   String dateString = article.date;
  //   DateTime dateTime = DateTime.parse(dateString);
  //   final formatter = DateFormat.yMMMEd();
  //   return formatter.format(dateTime);
  // }

  static const routeName = '/detail';

  String getDate(Article article) {
    String dateString = article.date;
    DateTime dateTime = DateTime.parse(dateString);
    final formatter = DateFormat.yMMMEd();
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(favoritesProvider);
    final article = ModalRoute.of(context)!.settings.arguments as Article;

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavoriteNews(article);
            },
            icon: Icon(
              favoritesBox.values.contains(article)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                '${article.author} | ${getDate(article)}',
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
              const SizedBox(
                height: 12,
              ),
              if (article.imageUrl.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Image.network(
                    article.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              Text(
                article.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                article.content,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18),
              ),
              const SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () => launchUrl(Uri.parse(article.url)),
                child: Text(
                  'Read more',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
