import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home_page.dart';

// Página de Login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


// Estado da LoginPage 
class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _box = Hive.box('usersBox');

// Função de login
  void _loginUser() {
    if (_formKey.currentState!.validate()) {
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text.trim();

      if (_box.containsKey(email)) {
        final userData = _box.get(email);
        if (userData['password'] == password) {
          // login bem-sucedido

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(userName: userData['name']),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Senha incorreta!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não encontrado!')),
        );
      }
    }
  }

// Construção da interface do LoginPage 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (v) =>
                    v!.isEmpty ? 'Insira seu e-mail' : null,
              ),
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (v) =>
                    v!.isEmpty ? 'Insira sua senha' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loginUser,
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
