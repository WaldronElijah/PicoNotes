import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  /// Pass either a bare name like '021-carousel'
  /// or a full path like 'assets/darkmodecollection/svg/021-carousel.svg'
  const SvgIcon(
    this.name, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticsLabel,
  });

  final String name;
  final double size;
  final Color? color;
  final String? semanticsLabel;

  String _resolvePath(BuildContext context) {
    // Since we're only using dark mode icons for now
    final isDark = true; // Theme.of(context).brightness == Brightness.dark;

    // sanitize quotes/spaces that may come from lists/json
    final raw = name.replaceAll('"', '').trim();

    // If caller passed a full path, use it
    if (raw.startsWith('assets/')) {
      return raw.endsWith('.svg') ? raw : '$raw.svg';
    }

    // Otherwise build the themed path (dark mode only for now)
    final base = isDark
        ? 'assets/darkmodecollection/svg'
        : 'assets/lightmodecollection/svg';
    final filename = raw.endsWith('.svg') ? raw : '$raw.svg';
    return '$base/$filename';
  }

  @override
  Widget build(BuildContext context) {
    final path = _resolvePath(context);

    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (_) => SizedBox(width: size, height: size),
    );
  }
}
