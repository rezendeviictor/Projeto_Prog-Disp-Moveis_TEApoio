import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teapoio/service/user_service.dart';

class ManagePecsScreen extends StatelessWidget {
  const ManagePecsScreen({super.key});

  // Diálogo para EDITAR
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

  // NOVO: Diálogo para EXCLUIR
  void _confirmDelete(BuildContext context, String pecId, String text) {
    final userService = UserService();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir PEC'),
        content: Text('Tem certeza que deseja apagar "$text"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              // Fecha o diálogo
              Navigator.pop(context);
              
              try {
                // Chama o serviço para deletar
                await userService.deletePec(pecId);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PEC excluída com sucesso!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
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

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Image.network(
                      data['imagemUrl'],
                      fit: BoxFit.contain,
                      errorBuilder: (c,e,s) => const Icon(Icons.image),
                    ),
                  ),
                  title: Text(data['texto'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(data['categoria']),
                  // AQUI MUDAMOS PARA TER DOIS BOTÕES
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditDialog(context, id, data['texto']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, id, data['texto']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}