import 'package:flutter/material.dart';

import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';
import '../../state/app_state.dart';
import '../auth/validators.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _bio;

  @override
  void initState() {
    super.initState();
    // Төлөвийг initState-д унших тул listen хийхгүй.
    final p =
        (context.getInheritedWidgetOfExactType<AppScope>())!.notifier!.profile;
    _name = TextEditingController(text: p.name);
    _email = TextEditingController(text: p.email);
    _phone = TextEditingController(text: p.phone);
    _bio = TextEditingController(text: p.bio);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    AppScope.of(context).updateProfile(
      name: _name.text.trim(),
      bio: _bio.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Мэдээлэл хадгалагдлаа')),
    );
    goBack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Профайл засах'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Avatar(radius: 44),
                      const SizedBox(height: 22),
                      AppTextField(
                        label: 'Бүтэн нэр',
                        controller: _name,
                        validator: (v) => Validators.required(v, 'Нэр'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'И-мэйл',
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Утасны дугаар',
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        validator: (v) => Validators.required(v, 'Утас'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Танилцуулга',
                        controller: _bio,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: AppButton(label: 'ХАДГАЛАХ', onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}
