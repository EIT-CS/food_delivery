import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/common_widgets.dart';
import 'validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DarkHeaderScaffold(
      title: 'Нууц үгээ мартсан',
      subtitle: 'И-мэйл хаягаар кодыг хүлээн аваарай',
      showBack: true,
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
              const SizedBox(height: 28),
              AppButton(
                label: 'КОД ИЛГЭЭХ',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.push(Routes.verify);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
