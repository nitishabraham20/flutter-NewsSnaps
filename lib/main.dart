import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:news_app/models/article.dart';
import 'package:news_app/models/favorites_box.dart';
import 'package:news_app/screens/news_detail.dart';
import 'package:news_app/screens/tabs.dart';

final theme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 147, 229, 250),
    brightness: Brightness.dark,
    surface: const Color.fromARGB(255, 42, 51, 59),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
);

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  favoritesBox = await Hive.openBox<Article>('favoritesBox');

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'News App',
        theme: theme,
        home: AnimatedSplashScreen(
          duration: 2000,
          splash: Icons.newspaper,
          nextScreen: const TabsScreen(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: const Color.fromARGB(255, 50, 58, 60),
        ),
        routes: {
          NewsDetailScreen.routeName: (context) => const NewsDetailScreen()
        },
      ),
    ),
  );
}
