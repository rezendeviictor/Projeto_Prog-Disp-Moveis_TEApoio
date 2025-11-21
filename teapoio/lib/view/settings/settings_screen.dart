import 'package:flutter/material.dart';
import 'package:teapoio/controller/auth_controller.dart'; 
import 'package:teapoio/main.dart';
import 'package:teapoio/view/settings/edit_profile_screen.dart';
import 'package:teapoio/view/settings/manage_pecs_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isPecReaderEnabled = true;
  double _volumeLevel = 0.5;
  bool _isChildModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final authController = AppState.of(context).authController;
    final isCaregiver = authController.userType == UserType.caregiver;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // ================= SEÇÃO: CONTA =================
          _buildSectionHeader('Conta'),
          
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

          // ================= SEÇÃO: CONTEÚDO =================
          _buildSectionHeader('Conteúdo'),

          ListTile(
            leading: const Icon(Icons.image, color: Color(0xFFB59DD9)),
            title: const Text('Gerenciar minhas PECs'),
            subtitle: const Text('Editar ou excluir figuras salvas'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManagePecsScreen()),
              );
            },
          ),

          const Divider(),

          // ================= SEÇÃO: SISTEMA =================
          _buildSectionHeader('Sistema'),

          SwitchListTile(
            secondary: const Icon(Icons.record_voice_over, color: Color(0xFFB59DD9)),
            title: const Text('Leitor de PECs'),
            subtitle: const Text('Falar o nome da figura ao tocar'),
            activeColor: const Color(0xFFB59DD9),
            value: _isPecReaderEnabled,
            onChanged: (bool value) {
              setState(() {
                _isPecReaderEnabled = value;
              });
            },
          ),

          // 2. Volume do Leitor
          ListTile(
            leading: const Icon(Icons.volume_up, color: Color(0xFFB59DD9)),
            title: const Text('Volume do Leitor'),
            subtitle: Slider(
              value: _volumeLevel,
              activeColor: const Color(0xFFB59DD9),
              onChanged: _isPecReaderEnabled 
                  ? (value) => setState(() => _volumeLevel = value) 
                  : null, 
            ),
          ),

          if (isCaregiver) 
            SwitchListTile(
              secondary: const Icon(Icons.child_care, color: Color(0xFFB59DD9)),
              title: const Text('Ativar versão Criança'),
              subtitle: const Text('Simplifica a interface do app'),
              activeColor: const Color(0xFFB59DD9),
              value: _isChildModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isChildModeEnabled = value;
                });
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Modo Criança ativado!')),
                  );
                }
              },
            ),

          const Divider(),

          // 4. Conexão (QR Code)
          ListTile(
            leading: const Icon(Icons.qr_code_scanner, color: Color(0xFFB59DD9)),
            title: const Text('Conectar ao App Parceiro'),
            subtitle: const Text('Escanear QR Code para parear'),
            trailing: const Icon(Icons.camera_alt, color: Colors.grey),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pareamento'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Escaneie o código abaixo no outro dispositivo:'),
                      const SizedBox(height: 20),
                      Container(
                        width: 150,
                        height: 150,
                        color: Colors.black12,
                        child: const Icon(Icons.qr_code_2, size: 100),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar'),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}