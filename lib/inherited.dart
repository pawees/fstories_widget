import 'package:flutter/material.dart';
import 'package:fstories_widget/storyCard.dart';
import 'package:fstories_widget/utils.dart';

class IndexModel extends ChangeNotifier  {
  IndexModel({
    required this.storyIndex,
    required this.storyLength,
    required this.pageIndex,
    required this.pageLength,
    required this.onAnimatePage,
    required this.safeLimit,
    this.isEnded = false,
  });

  int storyLength;
  int pageLength;
  int pageIndex;
  int storyIndex;
  final void Function(int, AnimationController) onAnimatePage;
  bool isEnded;
  int safeLimit;

  get currentStoryIndex => storyIndex >= storyLimit ? storyLimit : storyIndex;

  get currentPageIndex => pageIndex >= pageLimit ? pageLimit : pageIndex;

  get storyLimit => storyLength - 1;

  get pageLimit => pageLength - 1;



  decrementStoryIndex() {
    if (storyIndex == 0) {
      return false;
    }
    storyIndex -= 1;
    notifyListeners();
    return false;
  }


  incrementStoryIndex() {
    if (storyIndex == storyLimit) {
      return true;
    }

    storyIndex += 1;
    notifyListeners();
    return false;
  }


  markCardAsWatched() {

    moveWatchedController.value = MoveWatchedState.watched;

  }
  markCardAsUnWatched() {

    moveWatchedController.value = MoveWatchedState.unwatched;

  }

  openNextPage(
    VoidCallback? callback,
      controller,
  ) {

    if (safeLimit == 0 || pageIndex == pageLimit ) {
      gkey.currentState?.currentPage = pageIndex;
      moveWatchedController.value = MoveWatchedState.watched;
      onPageLimitReached(callback);

    }

    gkey.currentState?.pageLength -= 1;


    gkey.currentState?.currentPage = pageIndex;
    pageIndex += 1;
    onAnimatePage(pageIndex, controller);
  }

  void onPageLimitReached(VoidCallback? callback) {
    callback?.call();
  }

  openPrevPage() {}
}

class IndexNotifierProvider extends InheritedNotifier<IndexModel> {
  IndexNotifierProvider({
    required this.model,
    required Widget child,
    Key? key,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );
  final IndexModel model;

  ///call rebuild
  static IndexModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<IndexNotifierProvider>()
        ?.model;
  }

  ///without update
  static IndexModel? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<IndexNotifierProvider>()
        ?.widget;
    return widget is IndexNotifierProvider ? widget.notifier : null;
  }

  @override
  bool updateShouldNotify(IndexNotifierProvider oldWidget) {
    return notifier != oldWidget.notifier;
  }
}

