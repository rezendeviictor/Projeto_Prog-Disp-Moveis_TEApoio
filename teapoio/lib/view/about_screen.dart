import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o App'),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // ADICIONE ESTE WIDGET
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO E TÍTULO
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'TEApoio',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB59DD9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // DESCRIÇÃO DO APP
              const Text(
                'Sobre o Projeto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'O TEApoio é um aplicativo de comunicação alternativa desenvolvido '
                'para crianças com Transtorno do Espectro Autista (TEA). Utiliza o '
                'sistema PECS (Picture Exchange Communication System) para facilitar '
                'a comunicação entre crianças e seus cuidadores.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),

              // FUNCIONALIDADES
              const Text(
                'Funcionalidades',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FeatureItem(text: 'Chat bidirecional com PECs'),
                  _FeatureItem(text: 'Conversão texto ↔ imagem'),
                  _FeatureItem(text: 'Interface adaptada para TEA'),
                  _FeatureItem(text: 'Sistema de avatares personalizáveis'),
                ],
              ),
              const SizedBox(height: 30),

              // DESENVOLVEDORES
              const Text(
                'Desenvolvimento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Desenvolvido como projeto acadêmico para a disciplina de '
                'Desenvolvimento Mobile com Flutter.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                'Equipe:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text('• Victor Hugo Marçal Rezende'),
              const SizedBox(height: 10),
              const Text(
                'Faculdade: FATEC - Ribeirão Preto',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const Text(
                'Ano: 2025',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),

              const SizedBox(height: 30), // Substitui o Spacer por SizedBox

              // VERSÃO DO APP
              Center(
                child: Text(
                  'Versão 1.0.0',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espaço extra no final
            ],
          ),
        ),
      ),
    );
  }
}

// WIDGET AUXILIAR PARA ITENS DA LISTA
class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}