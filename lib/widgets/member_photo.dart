import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

class MemberPhoto extends StatelessWidget {
  const MemberPhoto({
    super.key,
    required this.imageUrl,
    this.width = 96,
    this.height = 118,
    this.iconSize = 36,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: width,
        height: height,
        child: url == null || url.isEmpty
            ? _placeholder()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder(),
              ),
      ),
    );
  }

  Widget _placeholder() {
    return ColoredBox(
      color: AppColors.goldSoft,
      child: Icon(Icons.person, size: iconSize, color: AppColors.forestDeep),
    );
  }
}
