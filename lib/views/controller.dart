import 'package:flutter/material.dart';
import 'package:fstories_widget/_logging.dart';
import 'package:fstories_widget/logic/inherited.dart';

mixin ControllerMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  //TODO: каким то образом прокинуть дюрацию для контроллера

  late final pageController = PageController(
      initialPage: IndexNotifierProvider.read(context)?.pageIndex ?? 0);

  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  );

  get changeIndicatorListener => (status) async {
        if (status == AnimationStatus.completed) {
          //call callback if end page
          if (IndexNotifierProvider.read(context)?.isEndAllPages) {
            IndexNotifierProvider.read(context)?.onPageLimitReached();
            Navigator.of(context).pop();
            return;
          }

          //increment for next story
          if (!IndexNotifierProvider.read(context)?.isEndContentPage) {
            IndexNotifierProvider.read(context)?.incrementStoryIndex();
            animationController.forward(from: 0);
            return;
          }

          //swich page animation [onPageAnimation] PageController
          //increment page
          if (IndexNotifierProvider.read(context)?.isEndContentPage) {
            fStoriesLog.fine('end page reached');

            animationController.stop();
            fStoriesLog.fine('stop indicator row animation');
            fStoriesLog.fine(
                'current page is ${IndexNotifierProvider.read(context)?.pageIndex ?? 0}');
            IndexNotifierProvider.read(context)?.openNextPage();
            IndexNotifierProvider.read(context)?.visible(false, false);
            fStoriesLog.fine('indicator row is invisible');

            await _switchPageAnimation().then((_) {
              animationController.forward(from: 0);
              fStoriesLog.fine('animation is done');


              IndexNotifierProvider.read(context)?.visible(true, true);
              fStoriesLog.fine('indicator row is visible back');
              fStoriesLog.fine('_ _ _ _ _');

            });
          }
        }
      };

  _switchPageAnimation() async {
    int page = IndexNotifierProvider.read(context)?.pageIndex ?? 0;

    if (!mounted) {
      return;
    }
    fStoriesLog.fine('open up $page page');

    return pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 2500),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    animationController.dispose();
    super.dispose();
  }
}
