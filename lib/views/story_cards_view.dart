import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fstories_widget/models/enums.dart';
import 'package:fstories_widget/models/stories_card.dart';
import 'package:fstories_widget/styles.dart';
import 'package:fstories_widget/views/stories_view.dart';

_sheeet({context, cards, cardIndex, currentCard, controller}) {
  return showModalBottomSheet<void>(
    elevation: 1,
    useRootNavigator: true,
    context: context,
    builder: (BuildContext context) {
      return StoriesViewF(
          cards: cards, cardIndex: cardIndex, controller: controller);
    },
  );
}

//TODO добавить mouseRegion
class StoryCardsView extends StatefulWidget {
  StoryCardsView(
      {required this.cards,
      required this.shape,
      required this.size,
      BorderDecoration? borderDecoration,
      Key? key}) :
        borderDecoration = borderDecoration ?? BorderDecoration(shape: shape, color: Colors.greenAccent, strokeWidth: 3.0), //TODO: set material Color!!!
       super(key: key);


  final BorderDecoration borderDecoration;
  final Shape shape;
  final Size size;

  final List<StoriesCard> cards;

  @override
  State<StoryCardsView> createState() => _StoryCardsViewState();
}

class _StoryCardsViewState extends State<StoryCardsView> {
  late StreamController<List<StoriesCard>> controller;

  @override
  void initState() {
    super.initState();
    controller = StreamController<List<StoriesCard>>();
    controller.sink.add(widget.cards);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox = context.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final BoxConstraints parentConstraints = renderBox.constraints;

        assert(
              parentConstraints.maxHeight >= widget.size.height,
          'Max height of StoryCardsView widget cannot be more than ${parentConstraints.maxHeight}',
        );
      }
    });

    return StreamBuilder<List<StoriesCard>>(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Получаем данные из стрима
          final cards = snapshot.data!;
          return SizedBox(
            height: widget.size.height,
            child: ListView.builder(
              itemCount: cards.length,
              prototypeItem: Container(
                height: widget.size.height,
                width: widget.size.width,
                decoration: BoxDecoration(
                  shape: widget.shape == Shape.circle
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                ),
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: OnStoryCardWidgetF(
                  //use KEY
                  onTap: () {
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //     'storiesView', (predicate) => false,
                    //     arguments: index);
                    _sheeet(
                        context: context,
                        cards: cards,
                        currentCard: cards[index],
                        cardIndex: index,
                        controller: controller);
                    //_show(context);
                  },
                  storyCards: cards,
                  cardBorderDecor: widget.borderDecoration,
                  state: cards[index]!.state,
                  card: CardDecorationWidget(
                    shape: widget.shape,
                    size: widget.size,
                    imageSrc: cards[index]!.imageSrc, //fix
                  ),
                  page: index,
                  storyLength: cards[index]!.content.length,
                  content: cards[index]!.content,
                ),
              ),
            ),
          );
        });
  }
}

class OnStoryCardWidgetF extends StatelessWidget {
  final BorderDecoration cardBorderDecor;
  final Widget card;

  final int storyLength;
  final int page;
  final List<String> content;
  final storyCards;
  final state;

  final onTap;

  const OnStoryCardWidgetF({
    required this.onTap,
    required this.storyCards,
    required this.storyLength,
    required this.page,
    required this.content,
    required this.cardBorderDecor,
    required this.card,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        decoration: state == MoveWatchedState.unwatched
            ? cardBorderDecor.boxDecoration
            : null,
        child: card,
      ),
    );
  }
}
