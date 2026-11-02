import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/common_widgets.dart';
import 'validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.go(Routes.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DarkHeaderScaffold(
      title: 'Бүртгүүлэх',
      subtitle: 'Эхлэхийн тулд бүртгэлээ үүсгэнэ үү',
      showBack: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Нэр',
                hint: 'John Doe',
                controller: _name,
                validator: (v) => Validators.required(v, 'Нэр'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'И-мэйл хаяг',
                hint: 'example@gmail.com',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              PasswordField(
                label: 'Нууц үг',
                hint: '••••••••',
                controller: _password,
                validator: Validators.password,
              ),
              const SizedBox(height: 16),
              PasswordField(
                label: 'Нууц үг давтах',
                hint: '••••••••',
                controller: _confirm,
                validator: (v) =>
                    v != _password.text ? 'Нууц үг таарахгүй байна' : null,
              ),
              const SizedBox(height: 28),
              AppButton(label: 'БҮРТГҮҮЛЭХ', onPressed: _submit),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go(Routes.login),
                child: const Text('Бүртгэлтэй юу? Нэвтрэх'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
