import 'package:equatable/equatable.dart';
import 'package:fstories_widget/models/enums.dart';

class StoriesCard extends Equatable {
  final String imageSrc;
  final List<String> content;
  final MoveWatchedState state;

  const StoriesCard({
    required this.imageSrc,
    required this.content,
    this.state = MoveWatchedState.unwatched,
  });
  
  @override
  String toString() {
    return 'StoriesCard{$imageSrc, $state,}';
  }

  @override
  List<Object?> get props => [
        imageSrc,
      ];

  StoriesCard copyWith({
    String? imageSrc,
    List<String>? content,
    MoveWatchedState? state,
  }) {
    return StoriesCard(
      imageSrc: imageSrc ?? this.imageSrc,
      content: content ?? this.content,
      state: state ?? this.state,
    );
  }

  // Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'imageSrc': imageSrc,
      'content': content,
      'state': state.index, // Можно использовать индекс перечисления
    };
  }

  // Восстановление объекта из JSON
  factory StoriesCard.fromJson(Map<String, dynamic> json) {
    return StoriesCard(
      imageSrc: json['imageSrc'],
      content: List<String>.from(json['content']),
      state: MoveWatchedState
          .values[json['state']], // Восстанавливаем перечисление по индексу
    );
  }

  // Восстановление списка объектов из списка JSON
  static List<StoriesCard> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => StoriesCard.fromJson(json)).toList();
  }

  // Преобразование списка объектов в JSON
  static List<Map<String, dynamic>> listToJson(List<StoriesCard> list) {
    return list.map((card) => card.toJson()).toList();
  }
}
