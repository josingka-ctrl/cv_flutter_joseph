import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternal(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    opened = false;
  }
  if (!opened) {
    try {
      opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      opened = false;
    }
  }
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Impossible d’ouvrir ce lien sur cet appareil.'),
      ),
    );
  }
}
