import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final bool requiredField;
  final String? placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final MaskTextInputFormatter? mask;
  final bool isPassword;
  final bool obscure;
  final VoidCallback? toggleVisibility;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.requiredField = false,
    this.placeholder,
    this.validator,
    this.mask,
    this.isPassword = false,
    this.obscure = false,
    this.toggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LABEL + ASTERISCO
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            children: requiredField
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
        ),

        const SizedBox(height: 4),

        // CAMPO
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? obscure : false,
            inputFormatters: mask != null ? [mask!] : [],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: placeholder ?? 'Digite $label',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              suffixIcon: isPassword
                  ? GestureDetector(
                      onTap: toggleVisibility,
                      child: Icon(
                        obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    )
                  : null,
            ),
            validator: validator ??
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
