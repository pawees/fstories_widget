import 'package:flutter/material.dart';
import 'package:fstories_widget/models/enums.dart';
import 'package:fstories_widget/models/stories_card.dart';
import 'package:fstories_widget/views/story_cards_view.dart';
import 'dart:ui' show FlutterView;

void main() {
  runWidget(
    MultiViewApp(
      viewBuilder: (BuildContext context) => MyApp(),
    ),
  );
}


class MultiViewApp extends StatefulWidget {
  const MultiViewApp({super.key, required this.viewBuilder});

  final WidgetBuilder viewBuilder;

  @override
  State<MultiViewApp> createState() => _MultiViewAppState();
}

class _MultiViewAppState extends State<MultiViewApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateViews();
  }

  @override
  void didUpdateWidget(MultiViewApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Need to re-evaluate the viewBuilder callback for all views.
    _views.clear();
    _updateViews();
  }

  @override
  void didChangeMetrics() {
    _updateViews();
  }

  Map<Object, Widget> _views = <Object, Widget>{};

  void _updateViews() {
    final Map<Object, Widget> newViews = <Object, Widget>{};
    for (final FlutterView view in WidgetsBinding.instance.platformDispatcher.views) {
      final Widget viewWidget = _views[view.viewId] ?? _createViewWidget(view);
      newViews[view.viewId] = viewWidget;
    }
    setState(() {
      _views = newViews;
    });
  }

  Widget _createViewWidget(FlutterView view) {
    return View(
      view: view,
      child: Builder(
        builder: widget.viewBuilder,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(views: _views.values.toList(growable: false));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'example',
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
              size: const Size(75, 75),
              shape: Shape.circle,
              cards: const [
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
