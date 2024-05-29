// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStoreBase, Store {
  Computed<UserData?>? _$userComputed;

  @override
  UserData? get user => (_$userComputed ??=
          Computed<UserData?>(() => super.user, name: '_UserStoreBase.user'))
      .value;

  late final _$_userAtom = Atom(name: '_UserStoreBase._user', context: context);

  @override
  UserData? get _user {
    _$_userAtom.reportRead();
    return super._user;
  }

  @override
  set _user(UserData? value) {
    _$_userAtom.reportWrite(value, super._user, () {
      super._user = value;
    });
  }

  late final _$_UserStoreBaseActionController =
      ActionController(name: '_UserStoreBase', context: context);

  @override
  void setUser(UserData userData) {
    final _$actionInfo = _$_UserStoreBaseActionController.startAction(
        name: '_UserStoreBase.setUser');
    try {
      return super.setUser(userData);
    } finally {
      _$_UserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user}
    ''';
  }
}
