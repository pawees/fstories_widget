library stories;

import 'package:flutter/material.dart';
import 'package:fstories_widget/safe.dart';

import 'storyCard.dart';
import 'inherited.dart';

typedef StoryItemBuilder = Widget Function(
    BuildContext context, int pageIndex, int storyIndex);

class StoriesView extends StatefulWidget {
  const StoriesView(
      {required this.storyCards,
      required this.onPageLimit,
      this.isWatchedController,
      required this.storyLength,
      required this.pageIndex,
      required this.pageLength,
      Key? key})
      : super(key: key);

  final storyCards;

  /// Functions like "Navigator.pop(context)" is expected.
  final VoidCallback? onPageLimit;

  /// controller witch lisen page ending
  final ValueNotifier<bool>? isWatchedController;

  final int storyLength;
  final int pageIndex;
  final int pageLength;

  @override
  State<StoriesView> createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  PageController? pageController;
  var currentPageValue;
  bool animate = true;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.pageIndex);

    pageController!.addListener(() {
      if (!mounted)
        return; // Проверяем, все ли еще виджет находится в дереве виджетов

      if (pageController!.page!.round() != pageController!.page) {
        // Перелистывание началось
        // Останавливаем анимацию
        animate = false;
      } else {
        // Перелистывание закончилось
        animate = true;
        //
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: pageController,
        itemCount: widget.pageLength,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              StoriesNotifierProvider(
                isAnimatingRow: animate,
                contentBuilder: widget.storyCards[index].content,
                pageIndex: index,
                onPageLimit: widget.onPageLimit,
                storyLength: widget.storyCards[index].content.length,
                pageLength: widget.pageLength,
                onAnimatePage: (index, controller) {
                  pageController?.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeIn,
                  );
                },
              )
            ],
          );
        });
  }
}

class StoriesNotifierProvider extends StatelessWidget {
  const StoriesNotifierProvider(
      {required this.isAnimatingRow,
      required this.onAnimatePage,
      required this.contentBuilder,
      required this.pageIndex,
      required this.onPageLimit,
      required this.storyLength,
      required this.pageLength,
      this.isWatchedController,
      Key? key})
      : super(key: key);

  final List<String> contentBuilder;
  final VoidCallback? onPageLimit;
  final void Function(int, AnimationController) onAnimatePage;
  final ValueNotifier<bool>? isWatchedController;
  final int pageLength;
  final int pageIndex;
  final int storyLength;
  final bool isAnimatingRow;

  @override
  Widget build(BuildContext context) {
    IndexModel _model = IndexModel(
      safeLimit: gkey.currentState?.pageLength ?? 0,
      storyIndex: 0,
      storyLength: storyLength,
      pageIndex: pageIndex,
      pageLength: pageLength,
      onAnimatePage: onAnimatePage,
    );

    return IndexNotifierProvider(
      model: _model,
      child: _StoriesViewBuilder(
        pageLength: pageLength,
        contentBuilder: contentBuilder,
        onPageLimit: onPageLimit,
        isWatchedController: isWatchedController,
        pageIndex: pageIndex,
        isAnimatingRow: isAnimatingRow,
      ),
    );
  }
}

class _StoriesViewBuilder extends StatefulWidget {
  const _StoriesViewBuilder(
      {required this.isAnimatingRow,
      required this.contentBuilder,
      required this.pageIndex,
      required this.onPageLimit,
      required this.pageLength,
      this.isWatchedController,
      Key? key})
      : super(key: key);

  ///contain content of pages
  final List<String> contentBuilder;
  final VoidCallback? onPageLimit;
  final ValueNotifier<bool>? isWatchedController;
  final int pageLength;
  final int pageIndex;
  final bool isAnimatingRow;

  @override
  State<_StoriesViewBuilder> createState() => _StoriesViewBuilderState();
}

class _StoriesViewBuilderState extends State<_StoriesViewBuilder>
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
          bool isNextPage =
              IndexNotifierProvider.read(context)?.incrementStoryIndex();
          if (isNextPage) {
            IndexNotifierProvider.read(context)?.openNextPage(
              widget.onPageLimit,
              _controller,
            );
          }

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
            _Content(
              widget: widget,
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
                      Navigator.pop(context);
                      gkey.currentState?.firstInitCards =
                          gkey.currentState?.newCards ?? [];
                    },
                    icon: Icon(Icons.close_rounded)),
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
    required this.widget,
  });

  final _StoriesViewBuilder widget;

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
        IndexNotifierProvider.watch(context)?.currentStoryIndex ?? 0;

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
      child: Image.asset(
        widget.widget.contentBuilder[currentStoryIndex],
      ),
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
      IndexNotifierProvider.read(context)?.markCardAsWatched();
    }

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_IndicatorsRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimatingRow) {
      widget.animationController.forward();
      IndexNotifierProvider.read(context)?.markCardAsUnWatched();
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
