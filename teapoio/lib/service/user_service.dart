import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ATUALIZAÇÃO 1: Perfil (Coleção 'usuarios')
  Future<void> updateProfile(String newName, String newPhone) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // CORREÇÃO: Usamos .set com merge: true
      // Se o usuário não tiver ficha no banco (seu caso), ele cria agora!
      await _firestore.collection('usuarios').doc(user.uid).set({
        'nome': newName,
        'telefone': newPhone,
        'email': user.email, // Garante que o email também fique salvo
      }, SetOptions(merge: true));

      // Atualiza o nome de exibição no Auth também
      await user.updateDisplayName(newName);
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  // ATUALIZAÇÃO 2: PEC (Subcoleção 'minhas_pecs')
  Future<void> updatePec(String pecId, String newText) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('usuarios')
          .doc(user.uid)
          .collection('minhas_pecs')
          .doc(pecId)
          .update({
        'texto': newText,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar PEC: $e');
    }
  }
}