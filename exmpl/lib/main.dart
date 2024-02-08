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
      cards: [
        StoriesPage(
          name: 'man mustaches',
          id: '4532',
          borderDecoration: BorderDecoration(
            color: Colors.orange.withOpacity(0.5),
            strokeWidth: 7,
          ),
          cardDecoration: const CardDecorationWidget(
            imageSrc: 'images/s.png',
            shape: Shape.rectangle,
            size: Size(65, 85),
            color: Color(0xffb74093),
          ),
          content: [
            'images/6.jpeg',
            'images/7.jpeg',
            'images/8.jpeg',
            'images/9.jpeg',
          ],
        ),
        StoriesPage(
          name: 'man2',
          id: '4533',
          cardDecoration: const CardDecorationWidget(
            imageSrc: 'images/2.png',
            shape: Shape.rectangle,
            size: Size(65, 85),
            color: Color(0xffb74093),
          ),
          content: [
            'images/7.jpeg',
          ],
        ),

        StoriesPage(
          name: 'croc',
          id: '4534',
          cardDecoration: const CardDecorationWidget(
            imageSrc: 'images/croc.png',
            shape: Shape.rectangle,
            size: Size(65, 85),
            color: Color(0xffb74093),
          ),
          content: [
            'images/12.jpeg',
          ],
        ),
        StoriesPage(
          name: 'statue',
          id: '4535',
          cardDecoration: const CardDecorationWidget(
            imageSrc: 'images/stoneFace.jpeg',
            shape: Shape.rectangle,
            size: Size(65, 85),
            color: Color(0xffb74093),
          ),
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
          id: '4536',
          cardDecoration: const CardDecorationWidget(
            imageSrc: 'images/_.jpeg',
            shape: Shape.rectangle,
            size: Size(65, 85),
            color: Color(0xffb74093),
          ),
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
