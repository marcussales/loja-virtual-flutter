import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  bool loading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    loadCurrentUser();
  }

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pswd,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailed}) {
    loading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: pswd)
        .then((user) async {
      firebaseUser = user;
      await _saveUserData(userData);
      onSuccess();
      loading = false;
      notifyListeners();
    }).catchError((e) {
      onFailed();
      loading = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String email,
      @required String pswd,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailed}) async {
    loading = true;
    notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: pswd)
        .then((user) async {
      firebaseUser = user;
      await loadCurrentUser();
      onSuccess();
      loading = false;
      notifyListeners();
    }).catchError((e) {
      onFailed();
      loading = false;
      notifyListeners();
    });
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData(this.userData);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
        notifyListeners();
      }
    }
  }

  void signOut() async {
    await this._auth.signOut();
    this.userData = Map();
    firebaseUser = null;
    notifyListeners();
  }
}
