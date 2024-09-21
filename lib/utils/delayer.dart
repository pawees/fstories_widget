delayer(message,delay) async {

  Future.delayed(Duration(milliseconds: delay), () {
    print(message);
  });
}