import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/common_widgets.dart';

/// 4 оронтой код оруулах + өөрийн тоон гар.
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const _length = 4;
  String _code = '';
  int _seconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
      }
      if (mounted) setState(() => _seconds = _seconds > 0 ? _seconds - 1 : 0);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _press(String key) {
    setState(() {
      if (key == '⌫') {
        if (_code.isNotEmpty) _code = _code.substring(0, _code.length - 1);
      } else if (_code.length < _length) {
        _code += key;
      }
    });
  }

  void _confirm() {
    if (_code.length == _length) {
      context.go(Routes.success);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('4 оронтой кодоо бүрэн оруулна уу')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DarkHeaderScaffold(
      title: 'Баталгаажуулалт',
      subtitle: 'Таны и-мэйл хаяг руу илгээсэн кодыг оруулна уу',
      showBack: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'КОД',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _seconds == 0 ? _startTimer : null,
                      child: Text(
                        _seconds == 0
                            ? 'Дахин илгээх'
                            : 'Дахин илгээх (0:${_seconds.toString().padLeft(2, '0')})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _seconds == 0
                              ? AppColors.orange
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_length, (i) {
                    final filled = i < _code.length;
                    final active = i == _code.length;
                    return Container(
                      width: 62,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.field,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              active ? AppColors.primary : Colors.transparent,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        filled ? _code[i] : '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                AppButton(label: 'БАТАЛГААЖУУЛАХ', onPressed: _confirm),
              ],
            ),
          ),
          const Spacer(),
          _NumPad(onKey: _press),
        ],
      ),
    );
  }
}

class _NumPad extends StatelessWidget {
  const _NumPad({required this.onKey});

  final ValueChanged<String> onKey;

  static const _keys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '',
    '0',
    '⌫',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD1D5DB),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.6,
        children: [
          for (final k in _keys)
            k.isEmpty
                ? const SizedBox.shrink()
                : Material(
                    color: k == '⌫' ? const Color(0xFFAEB3BC) : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => onKey(k),
                      child: Center(
                        child: k == '⌫'
                            ? const Icon(Icons.backspace_outlined, size: 20)
                            : Text(
                                k,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
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
