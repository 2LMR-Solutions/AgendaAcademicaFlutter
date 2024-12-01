import 'package:flutter/material.dart';


class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          'Bem-vindo a tela de perfil!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
