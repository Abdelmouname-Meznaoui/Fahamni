import 'package:flutter/widgets.dart';

ImageProvider safeImage(
  String? url, {
  String defaultAsset = 'assets/images/studentmale.png',
}) {
  final String s = (url ?? '').toString().trim();
  if (s.isEmpty || s.toLowerCase() == 'null') {
    return AssetImage(defaultAsset);
  }
  if (s.startsWith('http')) {
    return NetworkImage(s);
  }
  if (s.startsWith('assets/')) {
    return AssetImage(s);
  }
  return AssetImage(defaultAsset);
}
