import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../state/app_state.dart';

/// Төлбөр амжилттай → сагсыг цэвэрлээд хүргэлтийн явцыг харуулна.
class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Төлбөр хийгдсэн тул сагсыг build дууссаны дараа хоослоно.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppScope.of(context).clearCart();
    });
  }

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
                      Icons.takeout_dining,
                      size: 96,
                      color: AppColors.primary,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.lime,
                    child: Icon(Icons.check, color: Colors.white, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Амжилттай төлөгдлөө!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              const Text(
                'Таны захиалгыг хүлээн авлаа. Тогооч бэлтгэж эхэллээ, удахгүй хүргэгч гарна.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'ЗАХИАЛГЫН ЯВЦЫГ ХАРАХ',
                onPressed: () => context.go(Routes.tracking),
              ),
              TextButton(
                onPressed: () => context.go(Routes.home),
                child: const Text('Нүүр хуудас руу буцах'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
