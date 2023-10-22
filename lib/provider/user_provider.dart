import 'package:bobok/models/user.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  UserData? _user;

  UserData? get user => _user;

  void setUser(UserData userData) {
    _user = userData;
    notifyListeners();
  }
}
