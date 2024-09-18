library stories;

import 'package:flutter/material.dart';
import 'package:fstories_widget/models/stories_card.dart';
import 'package:fstories_widget/utils/safe.dart';
import '../logic/inherited.dart';

typedef StoryItemBuilder = Widget Function(
    BuildContext context, int pageIndex, int storyIndex);

class StoriesViewF extends StatefulWidget {
  const StoriesViewF(
      {required this.cards,
      required this.cardIndex,
      required this.controller,
      Key? key})
      : super(key: key);
  final List<StoriesCard> cards;
  final int cardIndex;
  final controller;

  @override
  State<StoriesViewF> createState() => _StoriesViewStateF();
}

class _StoriesViewStateF extends State<StoriesViewF> {
  PageController? pageController;
  //тоже можно вынести в модель, лучше вынести в миксин управления анимациями
  //переменная отвечает за паузу полоски индикатора, но из-за не приходится перестраивать
  //в глубину много страниц
  //убрать ее в модели и заставить следить индикатор

  @override
  Widget build(BuildContext context) {
    return IndexNotifierProvider(
      model: IndexModel(
        onPageLimitReachedCallback: () {
          Navigator.of(context).pop();
        },
        storyIndex: 0,
        cards: widget.cards,
        pageIndex: widget.cardIndex,
        onAnimatePage: (index, controller) {
          pageController?.animateToPage(
            index,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeIn,
          );
        }, //под вопросом
        isEnded: false,
        controller: widget.controller,
      ),
      child: NewWidget(
        pageController: pageController,
      ),
    );
  }
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    super.key,
    required this.pageController,
  });

  final PageController? pageController;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  bool animate = true;
  late final pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(
        initialPage: IndexNotifierProvider.read(context)?.pageIndex ?? 0);
    //TODO: maybe mixin organaise and encapsulate this listeners?
    pageController!.addListener(() {
      //TODO: smells very bad
      if (!mounted)
        return; // Проверяем, все ли еще виджет находится в дереве виджетов

      if (pageController!.page!.round() != pageController!.page) {
        // Перелистывание началось
        // Останавливаем анимацию полоски
        animate = false;
      } else {
        // Перелистывание закончилось продолжаем анимацию полоски
        animate = true;
        //
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: PageView.builder(
          controller: widget.pageController,
          itemCount: IndexNotifierProvider.read(context)?.storyLength,
          itemBuilder: (context, index) {
            return _StoriesViewBuilderF(
              isAnimatingRow: animate,
            );
          }),
    );
  }
}

class _StoriesViewBuilderF extends StatefulWidget {
  const _StoriesViewBuilderF({required this.isAnimatingRow, Key? key})
      : super(key: key);

  final bool isAnimatingRow; //TODO: smells BAD

  @override
  State<_StoriesViewBuilderF> createState() => _StoriesViewBuilderStateF();
}

class _StoriesViewBuilderStateF extends State<_StoriesViewBuilderF>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          IndexNotifierProvider.read(context)?.incrementStoryIndex();

          _controller.forward(from: 0);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.black,
        child: Stack(
          children: [
            ///image
            Center(
              child: _Content(),
            ),

            ///indicator
            Positioned(
              top: MediaQuery.of(context).padding.top + 5,
              left: 8.0 - 2.0 / 2,
              right: 8.0 - 2.0 / 2,
              child: _IndicatorsRow(
                isAnimatingRow: widget.isAnimatingRow,
                animationController: _controller,
              ),
            ),

            ///gestures
            _Gestures(
              animationController: _controller,
            ),

            ///close btn
            Positioned(
              top: 43,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                    onPressed: () {
                      _controller.stop();
                      IndexNotifierProvider.read(context)
                          ?.onClose(() {
                        Navigator.of(context).pop();
                      });
                    },
                    icon: const Icon(Icons.close_rounded)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({
    super.key,
  });

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content>
    with SingleTickerProviderStateMixin {
  late final _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 180), vsync: this);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int currentStoryIndex =
        IndexNotifierProvider.watch(context)?.currentStoryIndex;

    final String src = IndexNotifierProvider.read(context)
        ?.currentPage
        .content[currentStoryIndex];

    if (currentStoryIndex != 0) {
      _controller.reset();
      _controller.forward();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: child,
        );
      },
      child: Image.asset(src),
    );
  }
}

class _Gestures extends StatelessWidget {
  const _Gestures({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  final AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                animationController!.forward(from: 0);
                IndexNotifierProvider.read(context)?.decrementStoryIndex();
              },
              onTapDown: (_) {
                animationController!.stop();
              },
              onTapUp: (_) {
                animationController!.forward();
              },
              onLongPress: () {
                animationController!.stop();
              },
              onLongPressUp: () {
                animationController!.forward();
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                animationController!.forward(from: 0);
                animationController!.value = 1;
              },
              onTapDown: (_) {
                animationController!.stop();
              },
              onTapUp: (_) {
                animationController!.forward();
              },
              onLongPress: () {
                animationController!.stop();
              },
              onLongPressUp: () {
                animationController!.forward();
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _IndicatorsRow extends StatefulWidget {
  const _IndicatorsRow(
      {required this.isAnimatingRow,
      required this.animationController,
      Key? key})
      : super(key: key);

  final AnimationController animationController;
  final bool isAnimatingRow;

  @override
  State<_IndicatorsRow> createState() => _IndicatorsRowState();
}

class _IndicatorsRowState extends State<_IndicatorsRow>
    with SetStateAfterFrame {
  //late Animation<double> indicatorAnimation;
  late int storyLength;
  late int currentStoryIndex;

  @override
  void initState() {
    super.initState();
    widget.animationController.forward();
    // indicatorAnimation =
    //     Tween(begin: 0.0, end: 1.0).animate(widget.animationController);
  }

  @override
  void didChangeDependencies() {
    storyLength = IndexNotifierProvider.read(context)?.storyLimit ?? 0;

    if (!widget.isAnimatingRow) {
      widget.animationController.stop();
    }

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_IndicatorsRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimatingRow) {
      widget.animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    currentStoryIndex = IndexNotifierProvider.watch(context)?.storyIndex ?? 0;

    return Row(
      children: List.generate(storyLength + 1, (index) {
        return AnimatedBuilder(
          animation: widget.animationController,
          builder: (context, child) {
            return _Indicator(
              progress: (index == currentStoryIndex)
                  ? widget.animationController.value
                  : (index > currentStoryIndex)
                      ? 0
                      : 1,
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.animationController.dispose();
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.progress, Key? key}) : super(key: key);

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0 / 2),
        height: 3,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(2.0)),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            color: Color(0xffffffff),
          ),
        ),
      ),
    );
  }
}
