import 'package:material_ui/material_ui.dart';

import '../data/profile_data.dart';
import '../theme/app_theme.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
      children: [
        Text(
          'Les miens',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        const Text(
          'Quelques membres de la famille, à Goma.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 14),
        for (final member in ProfileData.family) ...[
          _FamilyCard(member: member),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard({required this.member});

  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                member.photo,
                width: 96,
                height: 118,
                fit: BoxFit.cover,
                alignment: member.alignment,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.goldSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      member.relation,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.forestDeep,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.note,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
