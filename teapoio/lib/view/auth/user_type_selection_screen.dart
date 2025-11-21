import 'package:flutter/material.dart';
import 'package:teapoio/controller/auth_controller.dart';
import 'package:teapoio/main.dart'; 
import 'package:teapoio/view/home/home_screen.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({Key? key}) : super(key: key);

  @override
  _UserTypeSelectionScreenState createState() => _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  UserType? _selectedUserType;

  @override
  Widget build(BuildContext context) {
    final authController = AppState.of(context).authController;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/Logo.png',
                height: 150,
              ),
              const SizedBox(height: 32),
              const Text(
                'Antes de prosseguir, precisamos saber: qual versão deseja utilizar?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF615A53),
                ),
              ),
              const SizedBox(height: 48),
              _buildUserTypeButton(
                userType: UserType.tea,
                label: 'Versão TEA',
                isSelected: _selectedUserType == UserType.tea,
              ),
              const SizedBox(height: 16),
              _buildUserTypeButton(
                userType: UserType.caregiver,
                label: 'Versão Cuidador',
                isSelected: _selectedUserType == UserType.caregiver,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _selectedUserType == null
                    ? null
                    : () {
                        authController.setUserType(_selectedUserType!);
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8A2D6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Prosseguir',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeButton({
    required UserType userType,
    required String label,
    required bool isSelected,
  }) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedUserType = userType;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFB8A2D6).withOpacity(0.2) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(
          color: isSelected ? const Color(0xFFB8A2D6) : Colors.grey,
          width: isSelected ? 2.0 : 1.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isSelected ? const Color(0xFF8A6AB8) : Colors.grey[700],
        ),
      ),
    );
  }
}