import 'package:flutter/material.dart';
import 'package:fstories_widget/_logging.dart';
import 'package:fstories_widget/models/enums.dart';
import 'package:fstories_widget/models/stories_card.dart';

class IndexModel extends ChangeNotifier {
  IndexModel({
    required this.controller,
    required this.storyIndex,
    required this.pageIndex,
    required this.cards,
  }) : _onCard = cards[pageIndex];

  final controller;

  int pageIndex;
  int storyIndex;

  List<StoriesCard> cards;
  StoriesCard _onCard;


  List<StoriesCard> _deleteIndexes = [];

  bool isRowVisible = true;

  get currentStoryIndex => storyIndex >= storyLimit ? storyLimit : storyIndex;

  get currentPage => _onCard;

  get storyLimit => _onCard.content.length - 1;

  get storyLength => _onCard.content.length + 1;

  get pageLimit => cards.length - 1;

  get pageLength => cards.length;

  get isEndContentPage => storyIndex == storyLimit;

  get isEndAllPages => pageIndex == pageLimit;

  void _modifyCardsList() {
    cards.removeWhere((element) => _deleteIndexes.contains(element));

    for (var item in _deleteIndexes) {
      cards.add(item.copyWith(state: MoveWatchedState.watched));
    }
    _deleteIndexes.clear();

    controller.sink.add(cards);
  }

  visible(value, shouldNotify) {
    isRowVisible = value;
    if (shouldNotify) {
      notifyListeners();
    }
  }

  decrementStoryIndex() {
    if (storyIndex == 0) {
      return false;
    }
    storyIndex -= 1;
    notifyListeners();
    return false;
  }

  incrementStoryIndex() {
    storyIndex += 1;
    notifyListeners();
  }

  onClose(
    VoidCallback? callback,
  ) {
    fStoriesLog.fine('tapped close button');

    _modifyCardsList();
    callback?.call();
  }

  onPageLimitReached() {
    _markPageAsWatched();

    if (pageIndex == pageLimit) {
      _modifyCardsList();
      return;
    }
  }

  _markPageAsWatched() {
    _deleteIndexes.add(_onCard);
  }

  openNextPage() async {
    _markPageAsWatched();

    pageIndex += 1;

    _onCard = cards[pageIndex];

    storyIndex = 0;

  }


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
