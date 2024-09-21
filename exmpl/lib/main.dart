import 'package:flutter/material.dart';
import 'package:fstories_widget/_logging.dart';
import 'package:fstories_widget/models/enums.dart';
import 'package:fstories_widget/models/stories_card.dart';
import 'package:fstories_widget/views/story_cards_view.dart';
import 'package:logging/logging.dart';

void main() {
  initLoggers(Level.FINE, {
    fStoriesLog,
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voronezh Animations',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: Column(
        textDirection: TextDirection.ltr, // Указываем направление текста
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 75,
            child: StoryCardsView(
              size: Size(75, 75),
              shape: Shape.circle,
              cards: [
                StoriesCard(
                  imageSrc: 'images/s.png',
                  content: [
                    'images/s.png',
                    'images/18.jpeg',
                  ],
                ),
                StoriesCard(
                  imageSrc: 'images/16.jpeg',
                  content: [
                    'images/16.jpeg',
                    'images/7.jpeg',
                  ],
                ),
                StoriesCard(
                  imageSrc: 'images/_.jpeg',
                  content: [
                    'images/_.jpeg',
                    'images/5.jpeg',
                  ],
                ),
                StoriesCard(
                  imageSrc: 'images/croc.png',
                  content: [
                    'images/croc.png',
                    'images/16.jpeg',
                  ],
                ),
                StoriesCard(
                  imageSrc: 'images/stoneFace.jpeg',
                  content: [
                    'images/stoneFace.jpeg',
                    'images/11.jpeg',
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('basics'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('my_training_page'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('animations out of the box'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('complex'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('tips'),
          ),
        ],
      ),
    );
  }
}
