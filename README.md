
Flutter package that allows you to use stories mechanism in your Flutter app. It can customizeble. Package don't use external dependencies.


## Usage

`StoriesPage` requires at least three arguments: `content`, `cardDecoration`.

``` dart
/// Minimum example:
return Scaffold(
  body: StoriesCardList(
    cards: [
        StoriesPage(
          cardDecoration: const CardDecorationWidget(
            imageSrc: 'images/s.png',
            shape: Shape.rectangle,
            size: Size(65, 85),
            color: Color(0xffb74093),
          ),
          content: [
            'images/6.jpeg',
          ],
        ),
    ]
```


The example above just shows 1 story by 1 page.

One more example.

``` dart
 @override
  Widget build(BuildContext context) {
    return StoriesCardList(
      cards: [
        StoriesPage(
          name: 'man mustaches',
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
```
