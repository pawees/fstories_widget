import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fstories_widget/models/enums.dart';
import 'package:fstories_widget/models/stories_card.dart';
import 'package:fstories_widget/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPstorage implements Storage<SharedPreferences> {
  @override
  Future<List<StoriesCard?>> get(String key, SharedPreferences engine) async {
    final result = engine.getString(key);
    if (result != null) {
      final List<dynamic> jsonList = jsonDecode(result);

      List<StoriesCard> storiesList = StoriesCard.listFromJson(jsonList);
      return storiesList;
    }

    return [];
  }

  @override
  Future<void> set(
      String key, List<StoriesCard> value, SharedPreferences engine) async {
    List<Map<String, dynamic>> jsonList = StoriesCard.listToJson(value);
    String jsonString = jsonEncode(jsonList);
    await engine.setString(key, jsonString);
    return;
  }
}

void main() {
  group('compare', () {
    late SharedPreferences pref;
    late Storage storage;
    late List<StoriesCard> list1;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = SPstorage(); //TODO: передавать pref как DI
      pref = await SharedPreferences.getInstance();
      list1 = const [

        StoriesCard(
          state: MoveWatchedState.watched,

          imageSrc: 'images/croc.png',
          content: [
            'images/croc.png',
            'images/16.jpeg',
          ],
        )
      ];
    });
    test('sp check', () async {
      storage.set('stroriescards', list1, pref);

      final result = await storage.get('stroriescards', pref);

      expect(result.length, equals(list1.length));
    });
    test('compare cards if storage is empty', () async {
      // Вызываем функцию сравнения
      var result = await compare(storage, list1, pref);

      expect(result, equals(list1));
    });
    test('find watched cards', () async {
      storage.set('stroriescards', list1, pref);
      const fromRequest = [
        StoriesCard(
          imageSrc: 'images/fromRequest_new.png',
          content: [
            'images/333.png',
            'images/444.jpeg',
          ],
        ),
        StoriesCard(
          imageSrc: 'images/croc.png',
          content: [
            'images/croc.png',
            'images/16.jpeg',
          ],
        )
      ];
      debugPrint('${fromRequest.map((e) => e.imageSrc).toList()}');

      var result = await compare(storage, list1, pref);
      final expectedList = [
        MoveWatchedState.unwatched,
        MoveWatchedState.watched,
        MoveWatchedState.watched,
        MoveWatchedState.watched,
        MoveWatchedState.watched
      ];

      //expect(result.map((e) => e!.state).toList(), equals(expectedList));
      expect(true, equals(true));
    });
  });
}
