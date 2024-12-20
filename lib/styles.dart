import 'package:flutter/material.dart';
import 'package:fstories_widget/models/enums.dart';



class CardDecorationWidget extends StatelessWidget {
  const CardDecorationWidget(
      {required this.shape,
      required this.size,
      required this.imageSrc,
      this.padding = 2.0,
      Key? key,
      this.imageRadius})
      : super(key: key);

  final Shape shape;
  final Size size;
  final double? imageRadius;
  final double padding;
  final String imageSrc;

  @override
  Widget build(BuildContext context) {
    BoxShape shapeType;
    switch (shape) {
      case Shape.rectangle:
        shapeType = BoxShape.rectangle;
        break;
      case Shape.circle:
        shapeType = BoxShape.circle;
        break;
    }
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            shape: shapeType,
            color: Colors.white70,
            image: DecorationImage(
              image: AssetImage(imageSrc),
              fit: BoxFit.fill,
            ),
          )),
    );
  }
}

class BorderDecoration {
  final Color color;
  final double strokeWidth;
  final double? borderRadius;
  final BoxDecoration boxDecoration;
  final Shape shape;

  BorderDecoration({
    this.shape = Shape.rectangle,
    required this.color,
    required this.strokeWidth,
    this.borderRadius,
  }) : boxDecoration = BoxDecoration(
          // borderRadius: BorderRadius.all(
          //   Radius.circular(borderRadius ?? 25),
          // ),
          shape: shape == Shape.circle ? BoxShape.circle : BoxShape.rectangle,
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

   BorderDecoration.standart()
      : borderRadius = standartBorderRadius,
        color = standartColor,
        shape = Shape.circle,
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

