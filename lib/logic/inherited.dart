import 'package:flutter/material.dart';
import 'package:fstories_widget/models/enums.dart';
import 'package:fstories_widget/models/stories_card.dart';

typedef OnAnimatePage = void Function(int, AnimationController);

class IndexModel extends ChangeNotifier {
  IndexModel({
    required this.controller,
    required this.storyIndex,
    required this.pageIndex,
    required this.onAnimatePage,
    required this.cards,
    required this.onPageLimitReachedCallback,
    this.isEnded = false,
  }) : _onCard = cards[pageIndex];

  final controller;

  int pageIndex;
  int storyIndex;
  OnAnimatePage onAnimatePage;
  bool isEnded;

  List<StoriesCard> cards;
  StoriesCard _onCard;
  VoidCallback? onPageLimitReachedCallback;

  List<StoriesCard> _deleteIndexes = [];


  get currentStoryIndex => storyIndex >= storyLimit ? storyLimit : storyIndex;

  get currentPage => _onCard;

  get storyLimit => _onCard.content.length - 1;

  get storyLength => _onCard.content.length;

  get pageLimit => cards.length - 1;

  get pageLength => cards.length;

  // новая копия списка cards
  void _modifyCardsList() {

    cards.removeWhere((element) => _deleteIndexes.contains(element));

    for (var item in _deleteIndexes) {
      cards.add(item.copyWith(state: MoveWatchedState.watched));
    }
    _deleteIndexes.clear();

    controller.sink.add(cards);
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
    //как пишут логи мастера посмотреть суперТекст
    print('Story limit: $storyLimit , Story index: $storyIndex');


    if (storyIndex == storyLimit) {
      _onPageLimitReached();
      _openNextPage();

      return;

    } 

    storyIndex += 1;
    notifyListeners();


  }

  onClose(VoidCallback? callback,) {
      print('tapped close button');

      _modifyCardsList();
      callback?.call();

    
  }

  _onPageLimitReached() {

    _deleteIndexes.add(_onCard);

    if (pageIndex == pageLimit) {
      print('page limit reached');

      _modifyCardsList();

      onPageLimitReachedCallback?.call();
      return;
    }
  }

  _openNextPage() {
    pageIndex += 1;
    print('Open next page');
    print(' page index : $pageIndex');
    print(cards[pageIndex].content);
    print(' ______________________');

    _onCard = cards[pageIndex];
    storyIndex = 0;

    notifyListeners();

    //onAnimatePage(pageIndex, controller);
  }

  _openPrevPage() {}
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
