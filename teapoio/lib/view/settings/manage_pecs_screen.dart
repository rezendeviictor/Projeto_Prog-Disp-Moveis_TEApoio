import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teapoio/service/user_service.dart';

class ManagePecsScreen extends StatelessWidget {
  const ManagePecsScreen({super.key});

  void _showEditDialog(BuildContext context, String pecId, String currentText) {
    final controller = TextEditingController(text: currentText);
    final userService = UserService();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Nome da PEC'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Novo nome'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await userService.updatePec(pecId, controller.text.trim());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar minhas PECs'),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user?.uid)
            .collection('minhas_pecs')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("Nenhuma PEC salva."));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final id = docs[index].id;

              return ListTile(
                leading: Image.network(data['imagemUrl'], width: 50, errorBuilder: (c,e,s) => const Icon(Icons.image)),
                title: Text(data['texto']),
                subtitle: Text(data['categoria']),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditDialog(context, id, data['texto']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}