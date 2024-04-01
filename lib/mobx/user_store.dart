import 'dart:convert';

import 'package:bobok/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:bobok/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _saveUserToCache(userData);
    notifyListeners();
    // Notificar os ouvintes sobre as mudanças nos dados do usuário
  }

  Future<void> _saveUserToCache(UserData userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convertendo o mapa retornado por toJson() em uma representação de String
    String userDataString = jsonEncode(userData.toJson());
    // Salvando os dados do usuário na cache
    await prefs.setString('userData', userDataString);
  }

  Future<void> clearUserFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Limpando os dados do usuário da cache
    await prefs.clear();
  }

  Future loadUserFromCache(
    UserProvider userProvider,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Recuperando os dados do usuário da cache
    String? userDataString = prefs.getString('userData');
    print(prefs.getString('userData'));

    if (userDataString != null) {
      // Convertendo a String de volta para um mapa JSON
      Map<String, dynamic> userDataMap = jsonDecode(userDataString);
      // Usando o método fromJson para criar uma instância de UserData
      UserData userData = UserData.fromJson(userDataMap);
      // Atribuindo o usuário recuperado à variável _user
      userProvider.setUser(userData);
    }
  }
}
