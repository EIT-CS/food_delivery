import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/common_widgets.dart';
import 'validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'example@gmail.com');
  final _password = TextEditingController(text: '12345678');
  bool _remember = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DarkHeaderScaffold(
      title: 'Нэвтрэх',
      subtitle: 'Өөрийн бүртгэлээр нэвтэрч орно уу',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'И-мэйл хаяг',
                hint: 'example@gmail.com',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 18),
              PasswordField(
                label: 'Нууц үг',
                hint: '••••••••',
                controller: _password,
                validator: Validators.password,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _remember,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _remember = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Намайг сана',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(Routes.forgot),
                    child: const Text(
                      'Нууц үгээ мартсан?',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(label: 'НЭВТРЭХ', onPressed: _submit),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Шинэ бүртгэл үүсгэх?  ',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(Routes.signUp),
                    child: const Text(
                      'БҮРТГҮҮЛЭХ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'Эсвэл',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(icon: Icons.facebook, color: Color(0xFF3B5998)),
                  SizedBox(width: 16),
                  _SocialButton(
                      icon: Icons.alternate_email, color: Color(0xFF1DA1F2)),
                  SizedBox(width: 16),
                  _SocialButton(icon: Icons.apple, color: Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
