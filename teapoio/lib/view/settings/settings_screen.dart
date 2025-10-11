import 'package:flutter/material.dart';
import 'package:teapoio/controller/auth_controller.dart';
import 'package:teapoio/main.dart'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volumeCuidador = 50.0;
  double _volumeCrianca = 50.0; 
  bool _ativarVersaoCrianca = false;

  @override
  Widget build(BuildContext context) {
    final authController = AppState.of(context).authController;
    final bool isCaregiver = authController.userType == UserType.caregiver;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: const Color(0xFFB59DD9),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isCaregiver)
 
              _buildConfigSection(
                title: 'Menu Configurações Cuidador',
                isCuidador: true,
                volume: _volumeCuidador,
                onVolumeChanged: (value) {
                  setState(() {
                    _volumeCuidador = value;
                  });
                },
              )
            else
              // --- SEÇÃO CONFIGURAÇÕES DA CRIANÇA ---
              _buildConfigSection(
                title: 'Menu Configurações Criança',
                isCuidador: false,
                volume: _volumeCrianca,
                onVolumeChanged: (value) {
                  setState(() {
                    _volumeCrianca = value;
                  });
                },
              ),
            
            const SizedBox(height: 20),

            if (isCaregiver)
              Card(
                elevation: 2,
                child: SwitchListTile(
                  title: const Text(
                    'Ativar versão Criança',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Habilita as funcionalidades específicas para crianças'),
                  value: _ativarVersaoCrianca,
                  onChanged: (value) {
                    setState(() {
                      _ativarVersaoCrianca = value;
                    });
                  },
                  activeColor: const Color(0xFFB59DD9),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSection({
    required String title,
    required bool isCuidador,
    required double volume,
    required ValueChanged<double> onVolumeChanged,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Configurações',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(Icons.volume_up, size: 20),
                SizedBox(width: 8),
                Text(
                  'Leitor de PECs',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Volume do Leitor de PECs:'),
                const SizedBox(height: 8),
                Slider(
                  value: volume,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: '${volume.round()}%',
                  onChanged: onVolumeChanged,
                  activeColor: const Color(0xFFB59DD9),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${volume.round()}%',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: const Color(0xFFB59DD9),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded( 
                        child: Text(
                          isCuidador
                              ? 'Escaneie o QR Code do app TEApoio'
                              : 'Para maior segurança, o Chat só será liberado',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isCuidador
                        ? 'presente no app da criança, para se conectar e liberar as funcionalidades do Chat'
                        : 'após o pareamento do App TEApoio com App TEApoio versão do Cuidador, através do QR Code',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildFunctionalityButtons(isCuidador: isCuidador),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionalityButtons({required bool isCuidador}) {
    return Column(
      children: [
        _buildFunctionalityButton(
          icon: Icons.chat,
          title: 'Chat',
          subtitle: isCuidador ? 'Disponível' : 'Aguardando pareamento',
          isEnabled: isCuidador,
          onTap: () {
            if (isCuidador) {
              _showQRCodeScanner(context);
            } else {
              _showPairingMessage(context);
            }
          },
        ),
        const SizedBox(height: 12),
        _buildFunctionalityButton(
          icon: Icons.add_photo_alternate,
          title: 'Novo PEC',
          subtitle: 'Configurado',
          isEnabled: true,
          onTap: () {
            _showPECMessage(context);
          },
        ),
      ],
    );
  }

  Widget _buildFunctionalityButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      color: isEnabled ? Colors.white : Colors.grey[100],
      child: ListTile(
        leading: Icon(
          icon,
          color: isEnabled ? const Color(0xFFB59DD9) : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isEnabled ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isEnabled ? Colors.green : Colors.grey,
            fontSize: 12,
          ),
        ),
        trailing: isEnabled
            ? const Icon(Icons.arrow_forward_ios, size: 16)
            : const Icon(Icons.lock, size: 16, color: Colors.grey),
        onTap: isEnabled ? onTap : null,
      ),
    );
  }

  void _showQRCodeScanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escanear QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.grey[200],
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Área do QR Code'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Posicione a câmera no QR Code do dispositivo da criança',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dispositivo pareado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB59DD9),
            ),
            child: const Text('Simular Pareamento'),
          ),
        ],
      ),
    );
  }

  void _showPairingMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat disponível apenas após pareamento com versão Cuidador'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showPECMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abrindo criação de novo PEC'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}