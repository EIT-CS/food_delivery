import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models.dart';
import '../../services/auth_service.dart';
import '../../services/order_service.dart';
import '../../state/app_state.dart';
import '../tracking/order_map.dart';

/// Хүргэгчийн (курьер) үндсэн дэлгэц.
///
/// Урсгал:  ресторан "Бэлэн болсон" дарна → энд "Боломжит" жагсаалтад гарна →
/// хүргэгч "Хүргэлт авах" → "Миний хүргэлт" дээр газрын зураг дээр замаа харж
/// явна → "Хүргэж өгсөн". Хэрэглэгч өөрийн tracking дэлгэцээс хүргэгчийг харна.
class CourierHomeScreen extends StatelessWidget {
  const CourierHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final available = app.availableDeliveries;
    final mine = app.myDeliveries;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.dark,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
                child: Row(
                  children: [
                    const Icon(Icons.delivery_dining, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Хүргэгч',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            app.profile.name,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Гарах',
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        app.signOut();
                        AuthService.instance.signOut();
                        context.go(Routes.login);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    _Stat(
                      label: 'НИЙТ ОРЛОГО',
                      value: formatPrice(app.courierEarnings),
                    ),
                    const SizedBox(width: 12),
                    _Stat(
                      label: 'ХҮРГЭСЭН',
                      value: '${app.completedDeliveries}',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSecondary,
                        indicatorColor: AppColors.primary,
                        tabs: [
                          Tab(text: 'Боломжит (${available.length})'),
                          Tab(text: 'Миний хүргэлт (${mine.length})'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _AvailableList(orders: available),
                            _MineList(orders: mine),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ресторан → хүргэх хаягийн шулуун зай (км).
double _km(OrderRecord r) {
  if (r.originLat == null ||
      r.originLng == null ||
      r.destLat == null ||
      r.destLng == null) {
    return 0;
  }
  const R = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(r.destLat! - r.originLat!);
  final dLng = rad(r.destLng! - r.originLng!);
  final a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(rad(r.originLat!)) *
          math.cos(rad(r.destLat!)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * R * math.asin(math.sqrt(a.toDouble()));
}

class _AvailableList extends StatelessWidget {
  const _AvailableList({required this.orders});

  final List<OrderRecord> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const _Empty(
        icon: Icons.hourglass_empty,
        text: 'Одоогоор хүргэх захиалга алга.\nРесторан хоолоо бэлэн болгоход энд гарна.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        final r = orders[i];
        return _Card(
          record: r,
          child: _ActionButton(
            label: 'ХҮРГЭЛТ АВАХ',
            onPressed: () async {
              final app = AppScope.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final ok = await app.acceptDelivery(r);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(ok
                      ? 'Захиалга #${r.orderNo} -г авлаа'
                      : 'Авч чадсангүй. Өөр хүргэгч авсан байж магадгүй'),
                ));
              if (ok && context.mounted) {
                DefaultTabController.of(context).animateTo(1);
              }
            },
          ),
        );
      },
    );
  }
}

class _MineList extends StatelessWidget {
  const _MineList({required this.orders});

  final List<OrderRecord> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const _Empty(
        icon: Icons.two_wheeler,
        text: 'Одоогоор хүргэж буй захиалга алга.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        final r = orders[i];
        return _Card(
          record: r,
          map: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 210,
              child: OrderMap(key: ValueKey(r.docId), record: r),
            ),
          ),
          child: Row(
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Чат'),
                onPressed: () =>
                    context.push(Routes.deliveryChatPath(r.docId)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
            label: 'ХҮРГЭЖ ӨГСӨН',
            onPressed: () async {
              final app = AppScope.of(context);
              final messenger = ScaffoldMessenger.of(context);
              final ok = await app.completeDelivery(r);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(ok
                      ? 'Хүргэлт дууслаа · +${formatPrice(AppState.courierFee)}'
                      : 'Шинэчилж чадсангүй. Дахин оролдоно уу'),
                ));
            },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.record, required this.child, this.map});

  final OrderRecord record;
  final Widget child;
  final Widget? map;

  @override
  Widget build(BuildContext context) {
    final r = record;
    final km = _km(r);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (map != null) ...[map!, const SizedBox(height: 12)],
          Row(
            children: [
              Expanded(
                child: Text(
                  '${r.foodName} × ${r.quantity}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '#${r.orderNo}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _Line(icon: Icons.storefront, text: r.restaurantName, tint: AppColors.primary),
          const SizedBox(height: 6),
          _Line(
            icon: Icons.home_outlined,
            text: r.address.isEmpty ? 'Хаяг тодорхойгүй' : r.address,
            tint: AppColors.orange,
          ),
          const SizedBox(height: 6),
          _Line(
            icon: Icons.person_outline,
            text: r.customerName.isEmpty ? 'Хэрэглэгч' : r.customerName,
            tint: AppColors.textSecondary,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${km.toStringAsFixed(1)} км · хөлс ${formatPrice(AppState.courierFee)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                r.payment == 'cash'
                    ? 'Бэлнээр ${formatPrice(r.total)}'
                    : 'Төлөгдсөн',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text, required this.tint});

  final IconData icon;
  final String text;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: tint),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({required this.label, required this.onPressed});

  final String label;
  final Future<void> Function() onPressed;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _busy
            ? null
            : () async {
                setState(() => _busy = true);
                await widget.onPressed();
                if (mounted) setState(() => _busy = false);
              },
        child: Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.6),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: AppColors.border),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
