import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fstories_widget/storyCard.dart';
import 'package:fstories_widget/utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: CupertinoThemeData(),
      home:
          CupertinoPageScaffold(backgroundColor: Colors.white70, child: Home()),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoriesCardList(
      shape: Shape.circle,
      size: Size(75, 85),
      borderDecoration: BorderDecoration(
        shape: Shape.circle,
        color: Colors.orange.withOpacity(0.4),
        strokeWidth: 5,
      ),
      cards: [
        StoriesPage(
          name: 'man mustaches',
          imageSrc: 'images/s.png',
          content: [
            'images/6.jpeg',
            'images/7.jpeg',
            'images/8.jpeg',
            'images/9.jpeg',
          ],
        ),
        StoriesPage(
          name: 'man2',
          imageSrc: 'images/16.jpeg',
          content: [
            'images/7.jpeg',
          ],
        ),
        StoriesPage(
          name: 'croc',
          imageSrc: 'images/_.jpeg',
          content: [
            'images/12.jpeg',
          ],
        ),
        StoriesPage(
          name: 'statue',
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
        StoriesPage(
          name: 'no_had',
          imageSrc: 'images/stoneFace.jpeg',
          content: [
            'images/13.jpeg',
            'images/10.jpeg',
            'images/14.jpeg',
          ],
        ),
      ],
    );
  }
}
