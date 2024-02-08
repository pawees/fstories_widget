import 'package:flutter/material.dart';
import 'package:fstories_widget/storyCard.dart';
import 'package:fstories_widget/utils.dart';

class IndexModel extends ChangeNotifier {
  IndexModel({
    required this.storyIndex,
    required this.storyLength,
    required this.pageIndex,
    required this.pageLength,
    required this.onAnimatePage,
    required this.safeLimit,
    required this.cardId,
    this.isEnded = false,
  });

  int storyLength;
  int pageLength;
  int pageIndex;
  int storyIndex;
  final void Function(int, AnimationController) onAnimatePage;
  bool isEnded;
  int safeLimit;
  String cardId;

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

  markCardAsWatched(String id) {
    moveWatchedController.value = id;
  }

  markCardAsUnWatched(String id) {
    moveWatchedController.value = id;
  }

  openNextPage(
    VoidCallback? callback,
    controller,
    String id,
  ) {
    if (safeLimit == 0 || pageIndex == pageLimit) {
      moveWatchedController.value = id;
      onPageLimitReached(callback);
    }

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
