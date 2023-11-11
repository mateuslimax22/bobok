import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:bobok/models/user.dart';

part 'user_store.g.dart';

class UserStore = _UserStoreBase with _$UserStore;

abstract class _UserStoreBase with Store, ChangeNotifier {
  @observable
  UserData? _user;

  @computed
  UserData? get user => _user;

  @action
  void setUser(UserData userData) {
    _user = userData;
    notifyListeners();
    // Notificar os ouvintes sobre as mudanças nos dados do usuário
  }
}
