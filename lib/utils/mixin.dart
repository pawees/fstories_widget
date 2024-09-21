import 'package:flutter/material.dart';
import 'package:fstories_widget/logic/inherited.dart';
import 'package:fstories_widget/utils/delayer.dart';

mixin ControllerMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  //TODO: каким то образом прокинуть дюрацию для контроллера

  late final pageController = PageController(initialPage: IndexNotifierProvider.read(context)?.pageIndex ?? 0 );

  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  );

  get changeIndicatorListener => (status) async {
        if (status == AnimationStatus.completed) {
          //если страницы кончились
          if (IndexNotifierProvider.read(context)?.isEndAllPages) {
            IndexNotifierProvider.read(context)?.onPageLimitReached();

            return;
          }

          //если не лимит я прибавляю след сторис
          if (!IndexNotifierProvider.read(context)?.isEndContentPage) {
            IndexNotifierProvider.read(context)?.incrementStoryIndex();
            animationController.forward(from: 0);
            return;
          }

          //если лимит я переключаю страницу
          if (IndexNotifierProvider.read(context)?.isEndContentPage) {
            delayer('endPageReached', 1000);

            animationController.stop();
            delayer('stopped controller', 100);

            print(
                'я сейчас на странице ${IndexNotifierProvider.read(context)?.pageIndex ?? 0}');
            IndexNotifierProvider.read(context)?.openNextPage();
            delayer('я вызывал метод инхерит openNextPage', 100);

              IndexNotifierProvider.read(context)?.visible(false,false);

            await switchPageAnimation().then((_) {
              animationController.forward(from: 0);
              print('doneee');
              print('_________________________________________');
              IndexNotifierProvider.read(context)?.visible(true,true);
            });
          }
        }
      };

  switchPageAnimation() async {
    var page = IndexNotifierProvider.read(context)?.pageIndex ?? 0;

    delayer('animation __ перехожу на страницу $page', 500);

    if (!mounted) {
      print('animation __ $widget не прицеплен!!!!');
      return; // Проверяем, все ли еще виджет находится в дереве виджетов
    }

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
