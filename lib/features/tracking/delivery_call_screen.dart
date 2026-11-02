import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/food_image.dart';

/// Хүргэгч рүү дуудлага хийх (Delivery - Call). Улаан товчоор дуудлага таслана.
class DeliveryCallScreen extends StatefulWidget {
  const DeliveryCallScreen({super.key});

  @override
  State<DeliveryCallScreen> createState() => _DeliveryCallScreenState();
}

class _DeliveryCallScreenState extends State<DeliveryCallScreen> {
  bool _connected = false;
  bool _muted = false;
  bool _speaker = false;
  int _seconds = 0;
  Timer? _connectTimer;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Дуудлагыг 2 секундын дараа холбогдсон мэт харуулна (demo).
    _connectTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _connected = true);
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _seconds++);
      });
    });
  }

  @override
  void dispose() {
    _connectTimer?.cancel();
    _ticker?.cancel();
    super.dispose();
  }

  String get _status {
    if (!_connected) return 'Холбогдож байна...';
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mapBackground,
      body: Column(
        children: [
          const Expanded(child: SizedBox.expand()),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -36),
                    child:
                        const Avatar(radius: 40, icon: Icons.delivery_dining),
                  ),
                  const Text(
                    'Robert Fox',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _status,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundIconButton(
                        icon: _muted ? Icons.mic_off : Icons.mic_none,
                        size: 52,
                        background: _muted ? AppColors.dark : AppColors.field,
                        iconColor:
                            _muted ? Colors.white : AppColors.textPrimary,
                        onPressed: () => setState(() => _muted = !_muted),
                      ),
                      RoundIconButton(
                        icon: Icons.call_end,
                        size: 68,
                        background: AppColors.danger,
                        iconColor: Colors.white,
                        onPressed: () => goBack(context),
                      ),
                      RoundIconButton(
                        icon: _speaker ? Icons.volume_up : Icons.volume_down,
                        size: 52,
                        background: _speaker ? AppColors.dark : AppColors.field,
                        iconColor:
                            _speaker ? Colors.white : AppColors.textPrimary,
                        onPressed: () => setState(() => _speaker = !_speaker),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
