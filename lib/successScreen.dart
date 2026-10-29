import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF4DA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delivery_dining,
                      size: 100,
                      color: AppColors.primary,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.check, color: Colors.white, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Бүртгэл амжилттай!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              const Text(
                'Таны бүртгэл баталгаажлаа. Одоо дуртай хоолоо захиалж болно.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'ЭХЛЭХ',
                // onPressed: () => context.go(Routes.home),
                onPressed: () => (),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AppButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color textSecondary = Color(0xFF757575);
}
