import 'package:material_ui/material_ui.dart';

import '../api/api_exception.dart';
import '../api/cv_api.dart';
import '../models/family_member.dart';
import '../theme/app_theme.dart';
import '../widgets/member_photo.dart';
import 'family_detail_page.dart';
import 'family_form_page.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key, required this.api});

  final CvApi api;

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  late Future<List<FamilyMember>> _future = widget.api.listMembers();

  Future<void> _reload() async {
    final next = widget.api.listMembers();
    setState(() {
      _future = next;
    });
    try {
      await next;
    } catch (_) {
      // Le FutureBuilder affiche l'erreur et le bouton Réessayer.
    }
  }

  Future<void> _add() async {
    final created = await Navigator.of(context).push<FamilyMember>(
      MaterialPageRoute(builder: (_) => FamilyFormPage(api: widget.api)),
    );
    if (created != null) await _reload();
  }

  Future<void> _open(FamilyMember member) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FamilyDetailPage(api: widget.api, member: member),
      ),
    );
    if (mounted) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FamilyMember>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          final message = error is ApiException
              ? error.details
              : 'Impossible de charger la famille.';
          return _Message(
            message: message,
            onRetry: _reload,
          );
        }

        final members = snapshot.data ?? const <FamilyMember>[];
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 96),
                children: [
                  Text(
                    'Les miens',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Les membres sont lus et enregistrés dans la base de données, via l’API.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 14),
                  if (members.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 28),
                      child: Text(
                        'Aucun membre pour le moment. Ajoutez une personne : elle sera enregistrée sur le serveur.',
                        style: TextStyle(color: AppColors.muted, height: 1.4),
                      ),
                    )
                  else
                    for (final member in members) ...[
                      _FamilyCard(
                        member: member,
                        onTap: () => _open(member),
                      ),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton.extended(
                key: const Key('add-member'),
                onPressed: _add,
                backgroundColor: AppColors.forest,
                foregroundColor: AppColors.ivory,
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Ajouter'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}

class _FamilyCard extends StatelessWidget {
  const _FamilyCard({required this.member, required this.onTap});

  final FamilyMember member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              MemberPhoto(imageUrl: member.imageUrl),
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
                        member.parente,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.forestDeep,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      member.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${member.lieuNaissance} · ${member.dateLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
