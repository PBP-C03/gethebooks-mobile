class UserData{
  bool isLoggedIn;
  String username;

  UserData({required this.isLoggedIn, required this.username});

}

UserData user = UserData(isLoggedIn: true, username: "Guest");
