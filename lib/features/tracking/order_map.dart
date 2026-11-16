import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_colors.dart';
import '../../services/geo_service.dart';
import '../../services/order_service.dart';

/// Захиалгын бодит газрын зураг (OpenStreetMap).
///
/// Ресторан (🍴) → хүргэх хаяг (🏠) хүртэлх замыг зурж, захиалгын шатаар
/// хүргэгчийн хөдөлгөөнийг харуулна:
///   • Хүлээгдэж / Бэлтгэж байна → хүргэгч рестораны өмнө
///   • Хүргэлтэд гарсан          → замын дагуу хөдөлнө
///   • Дууссан                   → хаягт хүрсэн
class OrderMap extends StatefulWidget {
  const OrderMap({super.key, required this.record});

  final OrderRecord? record;

  @override
  State<OrderMap> createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  List<LatLng>? _route;
  String? _routeKey;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _loadRoute();
    // Хүргэгчийн байрлалыг секунд тутам шинэчилнэ.
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && widget.record?.stage == OrderStage.delivering) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant OrderMap old) {
    super.didUpdateWidget(old);
    _loadRoute();
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  LatLng get _origin {
    final r = widget.record;
    return LatLng(
      r?.originLat ?? GeoService.center.latitude,
      r?.originLng ?? GeoService.center.longitude,
    );
  }

  LatLng get _dest {
    final r = widget.record;
    final d = LatLng(
      r?.destLat ?? GeoService.center.latitude + 0.01,
      r?.destLng ?? GeoService.center.longitude + 0.01,
    );
    // Эхлэл, төгсгөл давхцвал газрын зураг тохирохгүй тул бага зэрэг холдуулна.
    final o = _origin;
    if ((d.latitude - o.latitude).abs() < 0.0003 &&
        (d.longitude - o.longitude).abs() < 0.0003) {
      return LatLng(d.latitude + 0.004, d.longitude + 0.004);
    }
    return d;
  }

  Future<void> _loadRoute() async {
    final key = '${_origin.latitude},${_origin.longitude}>'
        '${_dest.latitude},${_dest.longitude}';
    if (key == _routeKey) return;
    _routeKey = key;
    final pts = await GeoService.route(_origin, _dest);
    if (!mounted || key != _routeKey) return;
    setState(() => _route = pts);
  }

  @override
  Widget build(BuildContext context) {
    final origin = _origin;
    final dest = _dest;
    final route = _route ?? [origin, dest];
    final progress = widget.record?.deliveryProgress ?? 0;
    var courier = GeoService.along(route, progress);

    // Хүргэгчийн бодит GPS (сүүлийн 90 секундэд шинэчлэгдсэн, хаягаас
    // 40 км дотор бол) байвал симуляцийн оронд түүнийг харуулна.
    final rec = widget.record;
    if (rec != null &&
        rec.stage == OrderStage.delivering &&
        rec.courierLat != null &&
        rec.courierLng != null &&
        rec.locAt != null &&
        DateTime.now().difference(rec.locAt!).inSeconds < 90) {
      final real = LatLng(rec.courierLat!, rec.courierLng!);
      if (GeoService.km(real, dest) < 40) courier = real;
    }

    return Stack(
      children: [
        FlutterMap(
          // Эхлэл, төгсгөлийг багтаах түвшинд нээнэ.
          options: MapOptions(
            initialCameraFit: CameraFit.bounds(
              bounds: LatLngBounds.fromPoints([origin, dest]),
              padding: const EdgeInsets.fromLTRB(56, 110, 56, 190),
              maxZoom: 16,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'mn.student.fooddelivery',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: route,
                  strokeWidth: 5,
                  color: AppColors.primary,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: origin,
                  width: 40,
                  height: 40,
                  child: const _Pin(
                    icon: Icons.restaurant,
                    color: AppColors.orange,
                  ),
                ),
                Marker(
                  point: dest,
                  width: 40,
                  height: 40,
                  child: const _Pin(
                    icon: Icons.home,
                    color: AppColors.primary,
                  ),
                ),
                if (widget.record != null &&
                    widget.record!.stage != OrderStage.cancelled)
                  Marker(
                    point: courier,
                    width: 44,
                    height: 44,
                    child: const _Pin(
                      icon: Icons.delivery_dining,
                      color: AppColors.dark,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ],
        ),
        // OpenStreetMap-ийн лицензийн шаардлага.
        const Positioned(
          left: 8,
          bottom: 4,
          child: Text(
            '© OpenStreetMap contributors',
            style: TextStyle(fontSize: 9, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.icon, required this.color, this.size = 20});

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size),
    );
  }
}
