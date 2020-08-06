class User {
  String id;
  String name;

  User({this.id, this.name});

  // this is a factory -> read more about this
  factory User.fromJson(model) {
    return User(id: model['id'], name: model['name']);
  }
}
