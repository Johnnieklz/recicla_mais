import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'login_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// Página de registro
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /// --------------------------
  /// Criação das máscaras
  /// --------------------------
  
  // Máscara para o telefone
  final _phonemask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Máscara para data de Aniversário
  final _birthdayMask = MaskTextInputFormatter(
  mask: '##/##/####',
  filter: { "#": RegExp(r'[0-9]') },
  );

  // Máscara para Número
  final _numberMask = MaskTextInputFormatter(
  mask: '#####-###',
  filter: { "#": RegExp(r'[0-9]') },
  );
  
  // Controladores dos campos
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(); // NOVO
  final _birthdayCtrl = TextEditingController();
  final _genderCtrl = TextEditingController();
  final _cityStateCtrl = TextEditingController(); // NOVO
  final _addressCtrl = TextEditingController(); // NOVO
  final _numberCtrl = TextEditingController(); // NOVO
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _acceptedTerms = false;

  final _formKey = GlobalKey<FormState>();
  final _box = Hive.box('usersBox');

  /// --------------------------
  /// Variáveis para controlar a visibilidade da senha
  /// --------------------------
  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _birthdayCtrl.dispose();
    _genderCtrl.dispose();
    _cityStateCtrl.dispose();
    _addressCtrl.dispose();
    _numberCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  /// --------------------------
  /// Função de registro
  /// --------------------------
  void _registerUser() {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos para continuar.'),
        ),
      );
      return;
    }

    /// --------------------------
    /// Deixar campo de imagem obrigatório
    /// --------------------------

    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, adicione uma foto.'),
        ),
      );
      return;
    }

    
    if (_formKey.currentState!.validate()) {
      final email = _emailCtrl.text.trim();
      final password = _passCtrl.text.trim();

      _box.put(email, {
        'name': _nameCtrl.text.trim(),
        'email': email,
        'phone': _phoneCtrl.text.trim(),
        'birthday': _birthdayCtrl.text.trim(),
        'gender': _genderCtrl.text.trim(),
        'city_state': _cityStateCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'number': _numberCtrl.text.trim(),
        'password': password,
        'image': _pickedImage?.path,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );

      _nameCtrl.clear();
      _emailCtrl.clear();
      _phoneCtrl.clear();
      _birthdayCtrl.clear();
      _genderCtrl.clear();
      _cityStateCtrl.clear();
      _addressCtrl.clear();
      _numberCtrl.clear();
      _passCtrl.clear();
      _confirmPassCtrl.clear();
      setState(() => _pickedImage = null);
    }

    
}

  /// --------------------------
  /// Função de escolher imagem
  /// --------------------------
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                  maxWidth: 1200,
                );
                if (image != null) setState(() => _pickedImage = image);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Abrir câmera'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                  maxWidth: 1200,
                );
                if (image != null) setState(() => _pickedImage = image);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancelar'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  /// --------------------------
  /// Construção da tela
  /// --------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),

                const Text(
                  'Preencha seus dados para concluir o cadastro',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                _buildInput(
                  'Nome Completo',
                  _nameCtrl,
                  requiredField: true,
                  placeholder: 'Digite seu nome completo',
                ),
                const SizedBox(height: 10),

                _buildInput(
                  'Email',
                  _emailCtrl,
                  requiredField: true,
                  placeholder: 'Digite seu email',
                ),
                const SizedBox(height: 10),

                _buildInput(
                  'Telefone',
                  _phoneCtrl,
                  requiredField: true,
                  placeholder: '(DDD) 90000-0000',
                  mask: _phonemask,
                ),
                const SizedBox(height: 10),

                _buildInput(
                  'Data de Nascimento',
                  _birthdayCtrl,
                  requiredField: true,
                  placeholder: 'dd/mm/aaaa',
                  mask: _birthdayMask,
                ),
                const SizedBox(height: 10),

                _buildInput(
                  'Gênero',
                  _genderCtrl,
                  requiredField: false,
                  placeholder: 'Masculino, Feminino...',
                ),
                const SizedBox(height: 10),

                _buildInput(
                  'Cidade - Estado',
                  _cityStateCtrl,
                  requiredField: true,
                  placeholder: 'Ex: São Paulo - SP',
                ),
                const SizedBox(height: 10),

                _buildInput(
                  'Endereço',
                  _addressCtrl,
                  requiredField: true,
                  placeholder: 'Rua, Avenida...',
                ),
                const SizedBox(height: 10),

                _buildInput(
                  'Número',
                  _numberCtrl,
                  requiredField: true,
                  placeholder: 'Ex: 123',
                  mask: _numberMask,
                ),
                const SizedBox(height: 10),

                _buildInput(
                  'Senha',
                  _passCtrl,
                  requiredField: true,
                  isPassword: true,
                  obscure: _obscureSenha,
                  toggleVisibility: (){
                    setState(() => _obscureSenha = !_obscureSenha);
                  },
                  validator: (v) => v!.length < 4 ? 'Senha muito curta' : null,
                  placeholder: 'Digite sua senha',
                ),
                const SizedBox(height: 10),

                _buildInput(
                  'Confirmar Senha',
                  _confirmPassCtrl,
                  requiredField: true,
                  isPassword: true,
                  obscure: _obscureConfirmarSenha,
                  toggleVisibility: (){
                    setState(() => _obscureConfirmarSenha = !_obscureConfirmarSenha);
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirme a senha';
                    if (v != _passCtrl.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                  placeholder: 'Repita a senha',
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: _pickedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 36,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Adicionar uma foto',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              File(_pickedImage!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (v) => setState(() => _acceptedTerms = v!),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Concordo com os Termos de Uso e Política de Privacidade',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Estou ciente de que meus dados serão utilizados conforme a legislação aplicável.',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: _registerUser,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4DB052), Color(0xFF29632C)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Criar conta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Já tenho conta! ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const TextSpan(
                          text: 'Entrar',
                          style: TextStyle(
                            color: Color(0xFF4DB052),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// --------------------------
  /// Labels com *
  /// --------------------------
  Widget _buildLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        children: required
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Color(0xFF9E2929),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : [],
      ),
    );
  }

  /// --------------------------
  /// Widget de Campos Reutilizáveis
  /// --------------------------
  Widget _buildInput(
    String label,
    TextEditingController controller, {
    bool requiredField = false,
    String? Function(String?)? validator,
    String? placeholder,
    MaskTextInputFormatter? mask,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required: requiredField),
        const SizedBox(height: 4),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400, width: 1),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? obscure : false,
            inputFormatters: mask != null ? [mask] : [], // Aplicar a máscara
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: placeholder ?? 'Digite $label',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              // 
              suffixIcon: isPassword
                ? GestureDetector(
                  onTap: toggleVisibility,
                  child: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                )
                : null,
            ),
            validator:
                validator ??
                (v) {
                  if (requiredField && (v == null || v.isEmpty)) {
                    return 'Por favor, preencha $label';
                  }
                  return null;
                },
          ),
        ),
      ],
    );
  }
}
