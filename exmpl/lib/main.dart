import 'package:flutter/material.dart';
import 'package:fstories_widget/models/enums.dart';
import 'package:fstories_widget/models/stories_card.dart';
import 'package:fstories_widget/views/story_cards_view.dart';





void main() {
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
                  'images/6.jpeg',
                  'images/7.jpeg',
                  'images/8.jpeg',
                  'images/9.jpeg',
                ],
              ),
              StoriesCard(
                imageSrc: 'images/16.jpeg',
                content: [
                  'images/7.jpeg',
                ],
              ),
              StoriesCard(
                imageSrc: 'images/_.jpeg',
                content: [
                  'images/12.jpeg',
                ],
              ),
              StoriesCard(
                imageSrc: 'images/croc.png',
                content: [
                  'images/18.jpeg',
                  'images/17.jpeg',
                  'images/14.jpeg',
                  'images/21.jpeg',
                  'images/19.jpeg',
                  'images/8.jpeg',
                ],
              ),
              StoriesCard(
                imageSrc: 'images/stoneFace.jpeg',
                content: [
                  'images/13.jpeg',
                  'images/10.jpeg',
                  'images/14.jpeg',
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



