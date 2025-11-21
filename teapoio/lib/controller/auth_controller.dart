import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { tea, caregiver }

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  UserType? _userType;
  bool _isLoading = false;

  User? get user => _user;
  UserType? get userType => _userType;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  AuthController() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  void setUserType(UserType type) {
    _userType = type;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return _tratarErroFirebase(e.code);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Erro desconhecido: $e';
    }
  }

  Future<String?> register(String name, String email, String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;
        
        await userCredential.user?.updateDisplayName(name);

        await _firestore.collection('usuarios').doc(uid).set({
          'nome': name,
          'email': email,
          'telefone': phone,
          'data_cadastro': FieldValue.serverTimestamp(),
        });
      }

      await _auth.signOut();

      _isLoading = false;
      notifyListeners();
      return null; // Sucesso total!
      
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return _tratarErroFirebase(e.code);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Erro ao finalizar cadastro: $e';
    }
  }

  Future<String?> recoverPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return _tratarErroFirebase(e.code);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _userType = null;
    notifyListeners();
  }

  String _tratarErroFirebase(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      default:
        return 'Erro: $code';
    }
  }
}