import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';

/// Төлбөрийн арга сонгох (Payment) — карт нэмсэн/нэмээгүй хоёр төлөвтэй.
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  static const _methods = [
    (PaymentMethod.cash, 'Бэлэн', Icons.payments_outlined),
    (PaymentMethod.visa, 'Visa', Icons.credit_card),
    (PaymentMethod.mastercard, 'Mastercard', Icons.credit_card_outlined),
    (PaymentMethod.paypal, 'PayPal', Icons.account_balance_wallet_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final isCard = app.paymentMethod == PaymentMethod.visa ||
        app.paymentMethod == PaymentMethod.mastercard;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Төлбөр'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                children: [
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _methods.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final (method, label, icon) = _methods[i];
                        final selected = app.paymentMethod == method;
                        return GestureDetector(
                          onTap: () => app.selectPayment(method),
                          child: Container(
                            width: 76,
                            decoration: BoxDecoration(
                              color: AppColors.field,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? AppColors.lime
                                    : Colors.transparent,
                                width: 1.6,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(icon, size: 28),
                                    if (selected)
                                      const Positioned(
                                        right: -10,
                                        top: -8,
                                        child: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: AppColors.lime,
                                          child: Icon(
                                            Icons.check,
                                            size: 11,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  label,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isCard)
                    _CardSection(app: app)
                  else
                    _SimpleMethodInfo(method: app.paymentMethod),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'НИЙТ ДҮН: ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        formatPrice(app.total),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: isCard && app.cards.isEmpty
                        ? 'КАРТ НЭМЭХ'
                        : 'ТӨЛБӨР ТӨЛӨХ & БАТАЛГААЖУУЛАХ',
                    onPressed: () {
                      if (isCard && app.cards.isEmpty) {
                        context.push(Routes.addCard);
                      } else {
                        context.push(Routes.paymentSuccess);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleMethodInfo extends StatelessWidget {
  const _SimpleMethodInfo({required this.method});

  final PaymentMethod method;

  @override
  Widget build(BuildContext context) {
    final text = method == PaymentMethod.cash
        ? 'Хүргэлт ирэхэд бэлнээр төлнө.'
        : 'PayPal дансаар төлбөр төлөхөд бэлэн.';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  const _CardSection({required this.app});

  final AppState app;

  @override
  Widget build(BuildContext context) {
    if (app.cards.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 76,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9966), Color(0xFFFF5E62)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.credit_card, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 14),
            const Text(
              'Карт нэмээгүй байна',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              'Та карт нэмж дараагийн захиалгадаа хадгалах боломжтой.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              onPressed: () => context.push(Routes.addCard),
              icon: const Icon(Icons.add, size: 18, color: AppColors.orange),
              label: const Text(
                'ШИНЭЭР НЭМЭХ',
                style: TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final card in app.cards)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.credit_card, color: Colors.white, size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.masked,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${card.holder} · ${card.expiry}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: AppColors.lime),
              ],
            ),
          ),
        TextButton.icon(
          onPressed: () => context.push(Routes.addCard),
          icon: const Icon(Icons.add, size: 18, color: AppColors.orange),
          label: const Text(
            'ШИНЭЭР НЭМЭХ',
            style: TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
