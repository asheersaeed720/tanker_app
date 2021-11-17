class UserModel {
  String name;
  String phoneNo;
  String password;
  UserModel({
    this.name = '',
    this.phoneNo = '',
    this.password = '',
  });

  @override
  String toString() => 'UserMode(name: $name, phoneNo: $phoneNo, password: $password)';
}
