
class User {
  static User instance;
  
  String name;
  String mail;
  String group;

  User(this.name, this.mail, this.group) {
    instance = this;
  }
}