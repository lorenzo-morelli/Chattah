class MyUser {
  final String uid;

  MyUser(this.uid);
}

class UserData {
  String uid;
  String firstName;
  String lastName;
  String nickname;
  String proPicURL;

  UserData({
    this.uid = '',
    this.firstName = '',
    this.lastName = '',
    this.nickname = '',
    this.proPicURL = '',
  });
}
