
import 'package:fstories_widget/models/enums.dart';

class StoriesCard {
  final String imageSrc;
  final List<String> content;
  final MoveWatchedState state;

  const StoriesCard({
    required this.imageSrc,
    required this.content,
    this.state = MoveWatchedState.unwatched,});

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
}