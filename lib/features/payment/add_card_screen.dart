import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../auth/validators.dart';

/// Төлбөрийн карт нэмэх → амжилттай бол төлбөрийн амжилттай дэлгэц рүү.
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _holder = TextEditingController();
  final _number = TextEditingController();
  final _expiry = TextEditingController();
  final _cvc = TextEditingController();

  @override
  void dispose() {
    _holder.dispose();
    _number.dispose();
    _expiry.dispose();
    _cvc.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final app = AppScope.of(context);
    app.addCard(
      PaymentCard(
        holder: _holder.text.trim(),
        number: _number.text,
        expiry: _expiry.text,
      ),
    );
    // Картыг нэмсний дараа төлбөрийн хуудсыг орхиж, амжилттай дэлгэц рүү шилжинэ.
    final router = GoRouter.of(context);
    router.pop();
    router.push(Routes.paymentSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Карт нэмэх'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Картын эзэмшигчийн нэр',
                        hint: 'Bilguun Tumurbaatar',
                        controller: _holder,
                        validator: (v) => Validators.required(v, 'Нэр'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Картын дугаар',
                        hint: '2134 _ _ _ _ _ _ _ _',
                        controller: _number,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          _CardNumberFormatter(),
                        ],
                        validator: (v) {
                          final digits = (v ?? '').replaceAll(' ', '');
                          return digits.length == 16
                              ? null
                              : 'Картын дугаар 16 оронтой байна';
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Дуусах хугацаа',
                              hint: 'MM/YY',
                              controller: _expiry,
                              keyboardType: TextInputType.number,
                              inputFormatters: [_ExpiryFormatter()],
                              validator: (v) =>
                                  (v ?? '').length == 5 ? null : 'MM/YY',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: AppTextField(
                              label: 'CVC',
                              hint: '***',
                              controller: _cvc,
                              obscure: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              validator: (v) =>
                                  (v ?? '').length >= 3 ? null : '3-4 орон',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: AppButton(
                label: 'КАРТ НЭМЭХ & ТӨЛБӨР ТӨЛӨХ',
                onPressed: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "1234567812345678" -> "1234 5678 1234 5678"
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// "1228" -> "12/28"
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);
    final text = digits.length > 2
        ? '${digits.substring(0, 2)}/${digits.substring(2)}'
        : digits;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
