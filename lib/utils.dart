import 'package:flutter/material.dart';

enum Shape {
  rectangle,
  circle,
}

enum MoveWatchedState {
  watched,
  unwatched,
}

class CardDecorationWidget extends StatelessWidget {
  const CardDecorationWidget(
      {required this.shape,
      required this.size,
      required this.color,
      required this.imageSrc,
      Key? key,
      this.imageRadius})
      : super(key: key);

  final Shape shape;
  final Size size;
  final Color color;
  final String imageSrc;
  final double? imageRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(imageRadius ?? 16),
          image: DecorationImage(
            image: AssetImage(imageSrc),
            fit: BoxFit.cover,
          ),
        ));
  }
}

class BorderDecoration {
  final Color color;
  final double strokeWidth;
  final double? borderRadius;
  final BoxDecoration boxDecoration;

  BorderDecoration({
    required this.color,
    required this.strokeWidth,
    this.borderRadius,
  }) : boxDecoration = BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? 25),
          ),
          border: Border.fromBorderSide(
            BorderSide(
              color: color,
              width: strokeWidth,
            ),
          ),
        );

  static const Color standartColor = Color(0xff76A3B9);
  static const double standartBorderRadius = 20;
  static const double standartStroke = 4;

  const BorderDecoration.standart()
      : borderRadius = standartBorderRadius,
        color = standartColor,
        strokeWidth = standartStroke,
        boxDecoration = const BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(standartBorderRadius),
          ),
          border: Border.fromBorderSide(
            BorderSide(color: standartColor, width: standartStroke),
          ),
        );
}

class StoriesPage {
  /// Name of the story circle
  String? name;
  String id;

  final BorderDecoration? borderDecoration;

  final List<String> content;

  final Widget cardDecoration;

  MoveWatchedState state;

  int get storiesLength => content.length;

  /// Add a story
  StoriesPage({
    this.borderDecoration = const BorderDecoration.standart(),
    this.name,
    required this.id,
    required this.content,
    required this.cardDecoration,
    this.state = MoveWatchedState.unwatched,
  });
}


StoriesPage? findCardById(String id, cards) {
  for (var card in cards) {
    if (card.id == id) {
      return card;
    }
  }
  return null; // Если элемент с указанным id не найден
}