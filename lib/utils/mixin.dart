import 'package:flutter/material.dart';
import 'package:fstories_widget/logic/inherited.dart';

ValueNotifier<String?> activeControllerNotifier = ValueNotifier<String?>(null);

const _animationDuration = Duration(milliseconds: 400);
const _animationDuration2 = Duration(milliseconds: 700);

mixin PlayIndicatorMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  Duration get duration => _animationDuration;
  Duration? get reverseDuration => null;
  double get upperBound => 1.0;
  double get lowerBound => 0.0;

  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );

  get changeIndicatorListener =>
      animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          IndexNotifierProvider.read(context)?.incrementStoryIndex();
          animationController.forward(from: 0);
          print('curernt index ${IndexNotifierProvider.read(context)?.currentStoryIndex}');
          

          //если лемит я запускаю анимацию
          if (IndexNotifierProvider.read(context)?.canAnimate ?? false) {
            print('endPageReached');
            activeControllerNotifier.value = 'switchPage';
          }
        }
      });

  get listener => activeControllerNotifier.addListener(() {
        if (activeControllerNotifier.value == 'switchPage') {
          print('stopped controller');
          animationController.stop();
        } else {
          animationController.forward();
        }
      });

  Future<void> playAnimation() => animationController.isCompleted
      ? animationController.reverse()
      : animationController.forward();

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

mixin PageControllerMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  Duration get duration => _animationDuration;
  Duration? get reverseDuration => null;
  double get upperBound => 1.0;
  double get lowerBound => 0.0;

  late final pageController = PageController(
    initialPage: IndexNotifierProvider.read(context)?.pageIndex ?? 0,
  );

  get listener => activeControllerNotifier.addListener(() {
        final page = IndexNotifierProvider.read(context)?.pageIndex ?? 0;
        if (activeControllerNotifier.value == 'switchPage') {
          print('listed to page $page');
          pageController.animateToPage(
            page ,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeIn,
          );
        }
      });

  get logicSwicherListener => pageController.addListener(() {
        if (!mounted)
          return; // Проверяем, все ли еще виджет находится в дереве виджетов

        if (pageController.page!.round() != pageController.page) {
          // Перелистывание началось
          // Останавливаем анимацию
          activeControllerNotifier.value = 'switchPage';
        } else {
          // Перелистывание закончилось
          activeControllerNotifier.value = 'noSwitchPage';
          //
          setState(() {});
        }
      });

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
