enum Shape {
  rectangle,
  circle,
}

enum MoveWatchedState {
  watched,
  unwatched,
}





enum StoriesTypeView {
  dialog(route: '1',),
  page(route: '2', );

  const StoriesTypeView({
    required this.route,
  });

  final String route;

  get currRoute => this.route;
  String get carbonFootprint => route;


}
