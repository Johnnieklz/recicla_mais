import 'package:flutter/material.dart';

// Página inicial após o login bem-sucedido
class HomePage extends StatelessWidget {
  final String userName; // Nome do usuário
  const HomePage({super.key, required this.userName}); // Construtor

// Construção da interface do HomePage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text ('Página Inicial')),
      body: Center(
        child:Text(
          'Bem-vindo, $userName!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}