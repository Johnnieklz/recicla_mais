import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'login_page.dart';

// Classe da página de registro
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

// Cria o estado da RegisterPage
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// Estado da RegisterPage
class _RegisterPageState extends State<RegisterPage> {
  final _nameCtrl = TextEditingController(); // Controlador do nome
  final _emailCtrl = TextEditingController(); // Controlador do e-mail
  final _passCtrl = TextEditingController(); // Controlador da senha
  final _confirmPassCtrl = TextEditingController(); // Controlador da confirmação de senha
  final _cpfCtrl = TextEditingController(); // Controlador do CPF/CNPJ
  final _birthdayCtrl = TextEditingController(); // Controlador da data de nascimento
  final _genderCtrl = TextEditingController(); // Controlador do gênero
  final _addressCtrl = TextEditingController(); // Controlador do endereço

// Chave do formulário
  final _formKey = GlobalKey<FormState>(); 
  final _box = Hive.box('usersBox');

// Função de registro do usuário
  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text.trim();
      final name = _nameCtrl.text.trim();
      final birthday = _birthdayCtrl.text.trim();
      final cpf = _cpfCtrl.text.trim();
      final gender = _genderCtrl.text.trim();
      final address = _addressCtrl.text.trim();

      // Salva no Hive: chave = email, valor = {nome, senha, ...}
      _box.put(email, {
        'name': name, 
        'password': password,
        'birthday': birthday,
        'cpf': cpf,
        'gender': gender,
        'address': address,
      });

// Exibe a mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );

// Limpa os campos após o cadastro
      _nameCtrl.clear();
      _emailCtrl.clear();
      _passCtrl.clear();
      _confirmPassCtrl.clear();
      _cpfCtrl.clear();
      _birthdayCtrl.clear();
      _genderCtrl.clear();
      _addressCtrl.clear();
    }
  }

// Construção da interface do RegisterPage
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nome completo'),
                  validator: (v) =>
                      v!.isEmpty ? 'Por favor, insira seu nome' : null,
                ),
                TextFormField(
                  controller: _cpfCtrl,
                  decoration: const InputDecoration(labelText: 'CPF ou CNPJ'),
                  validator: (v) =>
                  v!.isEmpty ? 'Por favor, insira seu CPF ou CNPJ' : null,
                ),
                TextFormField(
                  controller: _birthdayCtrl,
                  decoration: const InputDecoration(labelText: 'Data de Nascimento'),
                  validator: (v) =>
                  v!.isEmpty ? 'Por favor, insira sua data de nascimento!' : null,
                ),
                TextFormField(
                  controller: _genderCtrl,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  validator: (v) =>
                      v!.isEmpty ? 'Por favor, insira seu gênero' : null,
                ),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  validator: (v) =>
                      v!.length < 4 ? 'Senha muito curta' : null,
                ),
                TextFormField(
                  controller: _confirmPassCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirmar senha'),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Confirme a senha';
                    }
                    if (v != _passCtrl.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                  validator: (v) =>
                  v!.isEmpty ? 'Por favor, insira seu endeço' : null,
                ),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Cidade - Estado'),
                  validator: (v) =>
                  v!.isEmpty ? 'Por favor, insira sua cidade ou estado' : null,
                ),
    
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: const Text('Cadastrar'),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text('Ir para Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
