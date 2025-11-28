import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'register_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter esteja inicializado
  await Hive.initFlutter(); // Inicializa o Hive com Flutter

  // Abrir (ou criar) uma box  (tabela simples)
  await Hive.openBox('usersBox');

  runApp(const MyApp());
}

// Widget raiz do aplicativo
class MyApp extends StatelessWidget { 
  const MyApp({super.key});

// Construção do MaterialApp
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cadastro e Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RegisterPage(),
    );
  }
}
