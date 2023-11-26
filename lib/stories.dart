library stories;

import 'package:flutter/material.dart';
import 'package:fstories_widget/safe.dart';

import 'storyCard.dart';
import 'inherited.dart';

typedef StoryItemBuilder = Widget Function(
    BuildContext context, int pageIndex, int storyIndex);

class StoriesView extends StatefulWidget {
  const StoriesView(
      {
      required this.onPageLimit,
      this.isWatchedController,
      required this.storyLength,
      required this.pageIndex,
      required this.pageLength,
      Key? key})
      : super(key: key);


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

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.pageIndex);

    currentPageValue = widget.pageIndex.toDouble();

    pageController!.addListener(() {
      setState(() {
        currentPageValue = pageController!.page;
      });
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
                isCurrentPage: currentPageValue == index,
                contentBuilder: gkey.currentState?.content[index] ?? [''],
                pageIndex: index,
                onPageLimit: widget.onPageLimit,
                storyLength: gkey.currentState?.storiesLength[index] ?? 0,
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
      {required this.isCurrentPage,
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
  final bool isCurrentPage;

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
        isCurrentPage: isCurrentPage,
      ),
    );
  }
}

class _StoriesViewBuilder extends StatefulWidget {
  const _StoriesViewBuilder(
      {required this.isCurrentPage,
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
  final bool isCurrentPage;

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
      duration: Duration(milliseconds: 2800),
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

    final int currentStoryIndex =
        IndexNotifierProvider.watch(context)?.currentStoryIndex ?? 0;

    return Scaffold(
      body: ColoredBox(
        color: Colors.black,
        child: Stack(
          children: [

            ///image
            Positioned.fill(
              child: Image.asset(
                widget.contentBuilder[currentStoryIndex],
              ),
            ),


            ///indicator
            Positioned(
              top: MediaQuery.of(context).padding.top + 5,
              left: 8.0 - 2.0 / 2,
              right: 8.0 - 2.0 / 2,
              child: _IndicatorsRow(
                isCurrentPage: widget.isCurrentPage,
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
                      gkey.currentState?.firstInitCards = gkey.currentState?.newCards ?? [];
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
      {required this.isCurrentPage,
      required this.animationController,
      Key? key})
      : super(key: key);

  final AnimationController animationController;
  final bool isCurrentPage;

  @override
  State<_IndicatorsRow> createState() => _IndicatorsRowState();
}

class _IndicatorsRowState extends State<_IndicatorsRow>
    with SetStateAfterFrame {
  late Animation<double> indicatorAnimation;
  late int storyLength;
  late int currentStoryIndex;

  @override
  void initState() {
    super.initState();
    widget.animationController.forward();
    indicatorAnimation =
        Tween(begin: 0.0, end: 1.0).animate(widget.animationController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void didChangeDependencies() {
    storyLength = IndexNotifierProvider.read(context)?.storyLimit ?? 0;

    if (!widget.isCurrentPage) {
      widget.animationController.stop();
      IndexNotifierProvider.read(context)?.markCardAsWatched();
    }

    if (widget.isCurrentPage) {
      widget.animationController.forward();
      IndexNotifierProvider.read(context)?.markCardAsUnWatched();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _IndicatorsRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isCurrentPage) {
      widget.animationController.forward();
      IndexNotifierProvider.read(context)?.markCardAsUnWatched();
    }
  }

  @override
  Widget build(BuildContext context) {
    currentStoryIndex = IndexNotifierProvider.read(context)?.storyIndex ?? 0;

    return Row(
      children: List.generate(storyLength + 1, (index) {
        return _Indicator(
          index: index,
          progress: (index == currentStoryIndex)
              ? indicatorAnimation.value
              : (index > currentStoryIndex)
                  ? 0
                  : 1,
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
  const _Indicator({required this.progress, required this.index, Key? key})
      : super(key: key);

  ///need for calculate padding between indicators
  final int index;
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
