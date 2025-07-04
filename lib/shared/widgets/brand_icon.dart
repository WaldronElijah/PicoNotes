import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BrandIcon extends StatelessWidget {
  final String brand;
  final double size;
  final Color? color;
  final bool useOfficialColors;

  const BrandIcon({
    super.key,
    required this.brand,
    this.size = 24,
    this.color,
    this.useOfficialColors = true,
  });

  @override
  Widget build(BuildContext context) {
    final brandData = _getBrandData(brand.toLowerCase());
    
    return Icon(
      brandData.icon,
      size: size,
      color: color ?? (useOfficialColors ? brandData.color : null),
    );
  }

  BrandData _getBrandData(String brand) {
    switch (brand) {
      case 'youtube':
        return BrandData(
          icon: FontAwesomeIcons.youtube,
          color: const Color(0xFFFF0000), // YouTube Red
        );
      case 'instagram':
        return BrandData(
          icon: FontAwesomeIcons.instagram,
          color: const Color(0xFFE4405F), // Instagram Pink
        );
      case 'apple music':
      case 'applemusic':
        return BrandData(
          icon: FontAwesomeIcons.music,
          color: const Color(0xFFFA243C), // Apple Music Red
        );
      case 'soundcloud':
        return BrandData(
          icon: FontAwesomeIcons.soundcloud,
          color: const Color(0xFFFF5500), // SoundCloud Orange
        );
      case 'spotify':
        return BrandData(
          icon: FontAwesomeIcons.spotify,
          color: const Color(0xFF1DB954), // Spotify Green
        );
      case 'maps':
      case 'apple maps':
        return BrandData(
          icon: FontAwesomeIcons.mapPin,
          color: const Color(0xFF007AFF), // Apple Blue
        );
      case 'tiktok':
        return BrandData(
          icon: FontAwesomeIcons.tiktok,
          color: const Color(0xFF000000), // TikTok Black
        );
      case 'x':
      case 'twitter':
        return BrandData(
          icon: FontAwesomeIcons.xTwitter,
          color: const Color(0xFF000000), // X Black
        );
      case 'reddit':
        return BrandData(
          icon: FontAwesomeIcons.reddit,
          color: const Color(0xFFFF4500), // Reddit Orange
        );
      case 'pinterest':
        return BrandData(
          icon: FontAwesomeIcons.pinterest,
          color: const Color(0xFFBD081C), // Pinterest Red
        );
      default:
        return BrandData(
          icon: FontAwesomeIcons.link,
          color: Colors.grey,
        );
    }
  }
}

class BrandData {
  final IconData icon;
  final Color color;

  const BrandData({
    required this.icon,
    required this.color,
  });
}

// Helper widget for brand buttons with text
class BrandButton extends StatelessWidget {
  final String brand;
  final String? text;
  final VoidCallback? onTap;
  final double iconSize;
  final double fontSize;

  const BrandButton({
    super.key,
    required this.brand,
    this.text,
    this.onTap,
    this.iconSize = 20,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            BrandIcon(
              brand: brand,
              size: iconSize,
            ),
            if (text != null) ...[
              const SizedBox(width: 12),
              Text(
                text!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontFamily: 'SF Pro Text',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 