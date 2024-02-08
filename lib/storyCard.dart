import 'package:flutter/material.dart';
import 'package:fstories_widget/stories.dart';
import 'package:fstories_widget/safe.dart';
import 'package:fstories_widget/utils.dart';

class MoveWatchedController extends ValueNotifier<String> {
  MoveWatchedController._() : super("");
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

  List cards = [];

  void _moveWatchedToEnd(StoriesPage find) {
    cards.removeWhere((i) => i.hashCode == find.hashCode);
    cards.add(find);
  }

  void _watchedBorder(StoriesPage find) {
    for (var i in cards) {
      if (i.hashCode == find.hashCode) {
        i.state = MoveWatchedState.watched;
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    cards = [...widget.cards ?? []];

    listener = () {
      StoriesPage? find = findCardById(moveWatchedController.value, cards);
      if (find != null) {
        _watchedBorder(find);
        _moveWatchedToEnd(find);
        safeSetState(() {});
      }
      ;

      moveWatchedController.addListener(listener);
    };
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
                  cards.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: OnStoryCardWidget(
                      s_page: cards[index],
                      cardPosition: index,
                      cardsLength: cards.length,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class OnStoryCardWidget extends StatelessWidget {
  final StoriesPage s_page;
  final int cardPosition;
  final int cardsLength;

  const OnStoryCardWidget({
    required this.s_page,
    required this.cardPosition,
    required this.cardsLength,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return StoriesView(
                cardId: s_page.id,
                cardContent: s_page.content,
                pageLength: cardsLength,
                storyLength: s_page.storiesLength,
                pageIndex: cardPosition,
                onPageLimit: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
      child: Container(
        decoration: s_page.state == MoveWatchedState.unwatched
            ? s_page.borderDecoration!.boxDecoration //todo !
            : null,
        child: s_page.cardDecoration,
      ),
    );
  }
}
