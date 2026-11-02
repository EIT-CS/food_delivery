import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../auth/validators.dart';
import '../tracking/map_placeholder.dart';

/// Шинэ хаяг нэмэх (Add New Address): газрын зураг + талбарууд + төрөл.
class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _address = TextEditingController();
  final _apartment = TextEditingController();
  final _postal = TextEditingController();
  final _note = TextEditingController();
  String _label = 'Гэр';

  static const _labels = {
    'Гэр': Icons.home_outlined,
    'Ажил': Icons.work_outline,
    'Бусад': Icons.place_outlined,
  };

  @override
  void dispose() {
    _address.dispose();
    _apartment.dispose();
    _postal.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final app = AppScope.of(context);
    final detail = [
      _address.text.trim(),
      if (_apartment.text.trim().isNotEmpty) _apartment.text.trim(),
      if (_note.text.trim().isNotEmpty) _note.text.trim(),
    ].join(', ');
    app.addAddress(
      Address(
        label: _label.toUpperCase(),
        text: detail,
        icon: _labels[_label]!,
      ),
    );
    app.selectAddress(app.addresses.length - 1);
    goBack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: MapPlaceholder(showRoute: false),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: RoundIconButton.back(
                      context,
                      background: AppColors.dark,
                      iconColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          label: 'Хаяг',
                          hint: 'Дүүрэг, хороо, гудамж',
                          controller: _address,
                          validator: (v) => Validators.required(v, 'Хаяг'),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: 'Байр / Тоот',
                                hint: '12-р байр, 45 тоот',
                                controller: _apartment,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppTextField(
                                label: 'Шуудангийн код',
                                hint: '14200',
                                controller: _postal,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          label: 'Нэмэлт тэмдэглэл',
                          hint: 'Жишээ: орцны код 1234',
                          controller: _note,
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            children: [
                              for (final entry in _labels.entries)
                                SelectChip(
                                  label: entry.key,
                                  selected: _label == entry.key,
                                  onTap: () =>
                                      setState(() => _label = entry.key),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppButton(label: 'БАЙРШИЛ ХАДГАЛАХ', onPressed: _save),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
