import 'package:flutter/material.dart';
import 'package:fstories_widget/stories.dart';
import 'package:fstories_widget/safe.dart';
import 'package:fstories_widget/utils.dart';

class MoveWatchedController extends ValueNotifier<MoveWatchedState> {
  MoveWatchedController._() : super(MoveWatchedState.unwatched);
}

final MoveWatchedController moveWatchedController = MoveWatchedController._();

final gkey = GlobalKey<_StoriesCardListState>();

class StoriesCardList extends StatefulWidget {
  StoriesCardList({this.cards, Key? key}) : super(key: gkey);

  final List<StoriesPage?>? cards;

  @override
  State<StoriesCardList> createState() => _StoriesCardListState();
}

class _StoriesCardListState extends State<StoriesCardList>
    with SetStateAfterFrame {
  late VoidCallback listener;

  List<List<String>> content = [];
  List<int> storiesLength = [];
  List watchStatus = [];
  List newCards = [];
  List firstInitCards = [];

  int pageLength = 0;
  int currentPage = 0;
  int startIndexPage = 0;
  int currentStory = 0;

  void _moveWatchedToEnd() {
    StoriesPage? element;

    if (startIndexPage != 0) {
      var find = firstInitCards[currentPage];
      newCards.removeWhere((i) => i.hashCode == find.hashCode);
      element = find;
    } else {
      element = newCards.removeAt(0);
    }

    newCards.add(element);


  }

  void _watchedBorder() {

    var find = firstInitCards[currentPage];
    for(var i in newCards) {
      if(i.hashCode == find.hashCode){
        i.state = MoveWatchedState.watched;
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    firstInitCards =[...widget.cards ?? []];

    newCards = widget.cards ?? [];

    pageLength = newCards.length - 1;

    // ignore: unused_local_variable
    for (final card in newCards) {
      watchStatus.add(MoveWatchedState.unwatched);
    }

    for (final card in newCards) {
      gkey.currentState?.storiesLength.add(card.content.length);
    }

    for (final card in newCards) {
      gkey.currentState?.content.add(card.content);
    }

    listener = () {
      switch (moveWatchedController.value) {
        case MoveWatchedState.watched:
          _watchedBorder();
          _moveWatchedToEnd();
          safeSetState(() {});

          break;
        case MoveWatchedState.unwatched:
          return;
      }
    };
    moveWatchedController.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: widget.cards == null
            ? const SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  newCards.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: OnStoryCardWidget(
                      cardBorderDecor: newCards[index].borderDecoration,
                      card: newCards[index].cardDecoration,
                      page: index,
                      storyLength: newCards[index].content.length,
                      content: newCards[index].content,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class OnStoryCardWidget extends StatelessWidget {
  final BorderDecoration cardBorderDecor;
  final Widget card;

  final int storyLength;
  final int page;
  final List<String> content;

  const OnStoryCardWidget({
    required this.storyLength,
    required this.page,
    required this.content,
    required this.cardBorderDecor,
    required this.card,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        gkey.currentState?.startIndexPage = page;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return StoriesView(
                storyLength: storyLength,
                pageIndex: page,
                pageLength: gkey.currentState?.storiesLength.length ?? 0,
                onPageLimit: () {
                  Navigator.pop(context);
                  gkey.currentState?.firstInitCards = gkey.currentState?.newCards ?? [];

                },
              );
            },
          ),
        );
      },
      child: Container(
        decoration: gkey.currentState?.newCards[page].state ==
                MoveWatchedState.unwatched
            ? cardBorderDecor.boxDecoration
            : null,
        child: card,
      ),
    );
  }
}
