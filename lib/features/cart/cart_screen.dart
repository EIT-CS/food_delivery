import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';

/// Сагс (My Cart) болон Сагс засах (Edit Cart) — нэг widget, `editing` флагаар ялгана.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key, this.editing = false});

  final bool editing;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final items = app.cart;

    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            PageHeader(
              title: 'Сагс',
              dark: true,
              trailing: null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: GestureDetector(
                  onTap: () {
                    if (editing) {
                      context.pop();
                    } else {
                      context.push(Routes.cartEdit);
                    }
                  },
                  child: Text(
                    editing ? 'БОЛСОН' : 'ЗАСАХ',
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const _EmptyCart()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, i) =>
                          _CartRow(item: items[i], editing: editing),
                    ),
            ),
            _CheckoutPanel(editing: editing),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.white.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Таны сагс хоосон байна',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.go(Routes.home),
            child: const Text(
              'ХООЛ СОНГОХ',
              style: TextStyle(color: AppColors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.item, required this.editing});

  final CartItem item;
  final bool editing;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Row(
      children: [
        FoodImage(
          icon: item.food.icon,
          color: item.food.color,
          size: 72,
          radius: 14,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.food.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (editing)
                    GestureDetector(
                      onTap: () => app.removeFromCart(item),
                      child: const CircleAvatar(
                        radius: 11,
                        backgroundColor: AppColors.danger,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                formatPrice(item.total),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '${item.size}"',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  QuantityStepper(
                    value: item.quantity,
                    dark: false,
                    onMinus: () => app.decrement(item),
                    onPlus: () => app.increment(item),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckoutPanel extends StatelessWidget {
  const _CheckoutPanel({required this.editing});

  final bool editing;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'ХҮРГЭЛТИЙН ХАЯГ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push(Routes.addresses),
                  child: const Text(
                    'ЗАСАХ',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.field,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                app.currentAddress.text,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
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
                const Spacer(),
                GestureDetector(
                  onTap: () => _showBreakdown(context, app),
                  child: const Row(
                    children: [
                      Text(
                        'Дэлгэрэнгүй',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.orange,
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          size: 16, color: AppColors.orange),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppButton(
              label: 'ЗАХИАЛГА ӨГӨХ',
              onPressed:
                  app.cart.isEmpty ? null : () => context.push(Routes.payment),
            ),
          ],
        ),
      ),
    );
  }

  void _showBreakdown(BuildContext context, AppState app) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _line('Бүтээгдэхүүний дүн', formatPrice(app.subtotal)),
            const SizedBox(height: 10),
            _line('Хүргэлтийн төлбөр', formatPrice(app.deliveryFee)),
            const Divider(height: 28),
            _line('Нийт', formatPrice(app.total), bold: true),
          ],
        ),
      ),
    );
  }

  Widget _line(String a, String b, {bool bold = false}) {
    final style = TextStyle(
      fontSize: 14,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(a, style: style), Text(b, style: style)],
    );
  }
}
