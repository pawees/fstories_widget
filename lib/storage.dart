import 'package:fstories_widget/models/stories_card.dart';

abstract class Storage<S> {
  Future<void> set(String key, List<StoriesCard> value, S engine);
  Future<List<StoriesCard?>> get(String key, S engine);
}

Future<List<StoriesCard?>> compare(
    Storage storage, List<StoriesCard> cards, engine) async {

  //получаем список карточек, которые у нас сохранены как просмотренные.
  Set<StoriesCard?> watchedCards = await storage.get('stroriescards', engine).then((cards) {
    return cards.toSet();
  });

  //если ниче нет то возвращаем исходный список
  if (watchedCards.isEmpty) {
    return cards;
  }

  // Преобразуем второй список в множество для быстрого поиска.
  Set<StoriesCard> initializeCards = cards.toSet();
  // Списки для хранения совпадающих и несовпадающих элементов
  List<StoriesCard?> nonMatching = [];
  List<StoriesCard?> matching = [];


  



  //Находим пересечения
  matching = initializeCards.intersection(watchedCards).toList();


  print('совпадающее = посмотренное');
  print(matching.map((cards) => cards));


  //Находим различия
  nonMatching = initializeCards.difference(watchedCards).toList();


    print('разное');
    print(nonMatching.map((cards) => cards));




  return [...nonMatching, ...matching];
}
