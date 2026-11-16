import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

/// Газрын зурагтай холбоотой туслах функцүүд (OpenStreetMap + OSRM).
class GeoService {
  GeoService._();

  /// Улаанбаатар, Сүхбаатарын талбай — газрын зургийн анхны төв.
  static const LatLng center = LatLng(47.9186, 106.9177);

  /// Хүргэгч хотоор явах дуураймал хугацаа (секунд). Жинхэнэ хүргэгчийн
  /// GPS байхгүй тул "Хүргэлтэд" шатнаас эхлэн энэ хугацаанд хөдөлнө.
  static const int simulatedDeliverySeconds = 180;

  static int _hash(String text) {
    var h = 7;
    for (final c in text.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return h;
  }

  /// Текстээс (хаяг, ID) тогтмол демо координат гаргана: төвөөс ойролцоогоор
  /// 1.5 км хүртэлх зайд. Ижил текст үргэлж ижил цэг өгнө.
  static LatLng pointForText(String text) {
    final h = _hash(text);
    final dLat = ((h % 2000) / 2000.0 - 0.5) * 0.03;
    final dLng = (((h ~/ 2000) % 2000) / 2000.0 - 0.5) * 0.04;
    return LatLng(center.latitude + dLat, center.longitude + dLng);
  }

  /// Хоёр цэгийн хоорондох шулуун зай (км, haversine).
  static double km(LatLng a, LatLng b) {
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(b.latitude - a.latitude);
    final dLng = rad(b.longitude - a.longitude);
    final h = math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(a.latitude)) *
            math.cos(rad(b.latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * 6371.0 * math.asin(math.sqrt(h.toDouble()));
  }

  /// Жолооны замын шугам (OSRM нийтийн сервер). Алдаа гарвал шулуун шугам.
  static Future<List<LatLng>> route(LatLng from, LatLng to) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 6);
    try {
      final uri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${from.longitude},${from.latitude};${to.longitude},${to.latitude}'
        '?overview=full&geometries=geojson',
      );
      final req = await client.getUrl(uri);
      req.headers.set(HttpHeaders.userAgentHeader, 'mn.student.fooddelivery');
      final res = await req.close().timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return [from, to];

      final body = await res.transform(utf8.decoder).join();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final coords = ((data['routes'] as List).first
          as Map<String, dynamic>)['geometry']['coordinates'] as List;
      final pts = [
        for (final c in coords)
          LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
      ];
      return pts.length >= 2 ? pts : [from, to];
    } catch (_) {
      return [from, to];
    } finally {
      client.close(force: true);
    }
  }

  /// Шугамын дагуух `t` (0..1) хувь дахь цэг.
  static LatLng along(List<LatLng> pts, double t) {
    if (pts.length < 2) return pts.isEmpty ? center : pts.first;
    final clamped = t.clamp(0.0, 1.0);
    if (clamped <= 0) return pts.first;
    if (clamped >= 1) return pts.last;

    const dist = Distance();
    final seg = <double>[];
    var total = 0.0;
    for (var i = 0; i < pts.length - 1; i++) {
      final d = dist.distance(pts[i], pts[i + 1]);
      seg.add(d);
      total += d;
    }
    if (total == 0) return pts.first;

    var target = total * clamped;
    for (var i = 0; i < seg.length; i++) {
      if (target <= seg[i] || i == seg.length - 1) {
        final f = seg[i] == 0 ? 0.0 : (target / seg[i]).clamp(0.0, 1.0);
        final a = pts[i];
        final b = pts[i + 1];
        return LatLng(
          a.latitude + (b.latitude - a.latitude) * f,
          a.longitude + (b.longitude - a.longitude) * f,
        );
      }
      target -= seg[i];
    }
    return pts.last;
  }
}
