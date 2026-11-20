import 'package:material_ui/material_ui.dart';

import '../data/profile_data.dart';
import '../theme/app_theme.dart';
import '../utils/links.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
      children: [
        Text(
          'Me joindre',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        const Text(
          'Touchez une ligne pour appeler, écrire ou ouvrir le lien.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 14),
        const _ContactTile(
          icon: Icons.phone_outlined,
          label: 'Téléphone',
          value: ProfileData.phoneDisplay,
          url: ProfileData.phoneUri,
        ),
        const SizedBox(height: 10),
        const _ContactTile(
          icon: Icons.email_outlined,
          label: 'E-mail',
          value: ProfileData.email,
          url: 'mailto:${ProfileData.email}',
        ),
        const SizedBox(height: 10),
        const _ContactTile(
          icon: Icons.place_outlined,
          label: 'Adresse',
          value: ProfileData.city,
          url: ProfileData.mapsUri,
        ),
        const SizedBox(height: 18),
        Text(
          'Réseaux sociaux',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        const _ContactTile(
          icon: Icons.chat_outlined,
          label: 'WhatsApp',
          value: ProfileData.phoneDisplay,
          url: ProfileData.whatsappUri,
        ),
        const SizedBox(height: 10),
        const _ContactTile(
          icon: Icons.code,
          label: 'GitHub',
          value: ProfileData.githubLabel,
          url: ProfileData.githubUrl,
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String value;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => openExternal(context, url),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.goldSoft,
                foregroundColor: AppColors.forestDeep,
                child: Icon(icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new, size: 18, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
