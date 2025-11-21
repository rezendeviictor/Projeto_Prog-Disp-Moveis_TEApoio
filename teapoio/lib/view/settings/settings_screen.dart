import 'package:flutter/material.dart';
import 'package:teapoio/view/settings/edit_profile_screen.dart'; // Importe
import 'package:teapoio/view/settings/manage_pecs_screen.dart'; // Importe

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // SEÇÃO DE CONTA
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Conta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFFB59DD9)),
            title: const Text('Editar Dados do Perfil'),
            subtitle: const Text('Alterar nome e telefone'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          const Divider(),

          // SEÇÃO DE CONTEÚDO
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Conteúdo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.image, color: Color(0xFFB59DD9)),
            title: const Text('Gerenciar minhas PECs'),
            subtitle: const Text('Editar nomes das figuras salvas'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManagePecsScreen()),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}