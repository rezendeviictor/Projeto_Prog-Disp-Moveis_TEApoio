import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ... (Mantenha os métodos updateProfile e updatePec iguais) ...

  Future<void> updateProfile(String newName, String newPhone) async {
    // ... (Código anterior) ...
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await _firestore.collection('usuarios').doc(user.uid).set({
        'nome': newName,
        'telefone': newPhone,
        'email': user.email,
      }, SetOptions(merge: true));
      await user.updateDisplayName(newName);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  Future<void> updatePec(String pecId, String newText) async {
    // ... (Código anterior) ...
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .collection('minhas_pecs')
          .doc(pecId)
          .update({'texto': newText});
    } catch (e) {
      throw Exception('Erro ao atualizar PEC: $e');
    }
  }

  // --- NOVO MÉTODO: EXCLUIR PEC ---
  Future<void> deletePec(String pecId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .collection('minhas_pecs')
          .doc(pecId)
          .delete();
    } catch (e) {
      throw Exception('Erro ao excluir PEC: $e');
    }
  }
}