import 'package:flutter/material.dart';
import 'package:teapoio/controller/auth_controller.dart';
import 'package:teapoio/main.dart'; 
import '../about_screen.dart';
import '../chat/chat_screen.dart';
import '../chat/child_chat_screen.dart';
import '../auth/login_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AppState.of(context).authController;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('TEApoio'),
        ),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Escolha uma opção para começar:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            GridView.count( 
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.9,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFeatureCard(
                  imagePath: 'assets/images/comunicacao2.png',
                  title: 'Comunicação',
                  subtitle: 'Sistema PECs',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sistema de Comunicação com PECs - em desenvolvimento'),
                      ),
                    );
                  },
                ),
                _buildFeatureCard(
                  imagePath: 'assets/images/Chat capa.png',
                  title: 'Chat',
                  subtitle: 'Conversação direta',
                  onTap: () {
                    if (authController.userType == UserType.caregiver) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatScreen()),
                      );
                    } else if (authController.userType == UserType.tea) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChildChatScreen()),
                      );
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tipo de usuário não definido!'),
                        ),
                      );
                    }
                  },
                ),
                _buildFeatureCard(
                  imagePath: 'assets/images/conhecimento capa.png',
                  title: 'Aprendizagem',
                  subtitle: 'Atividades educativas',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Módulo de Aprendizagem em desenvolvimento'),
                      ),
                    );
                  },
                ),
                _buildFeatureCard(
                  imagePath: 'assets/images/Jogos capa.png',
                  title: 'Jogos',
                  subtitle: 'Diversão e aprendizado',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Módulo de Jogos em desenvolvimento'),
                      ),
                    );
                  },
                ),
                _buildFeatureCard(
                  imagePath: 'assets/images/Amigo Virtual Capa.png',
                  title: 'Amigo Virtual',
                  subtitle: 'Companheiro digital',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Amigo Virtual em desenvolvimento'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adicionar nova PEC - em desenvolvimento'),
            ),
          );
        },
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 30),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.settings, size: 24),
                  Text(
                    'Configurações',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 24),
                  Text(
                    'Sobre',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            IconButton(
              icon: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.exit_to_app, size: 24, color: Colors.red),
                  Text(
                    'Sair',
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
                ],
              ),
              onPressed: () {
                _showLogoutConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 78,
                height: 78,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do App'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Você saiu do app'),
                ),
              );
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}