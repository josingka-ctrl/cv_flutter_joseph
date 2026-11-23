import 'package:material_ui/material_ui.dart';

import '../api/api_exception.dart';
import '../api/cv_api.dart';
import '../models/family_member.dart';
import '../theme/app_theme.dart';
import '../widgets/member_photo.dart';
import 'family_form_page.dart';

class FamilyDetailPage extends StatefulWidget {
  const FamilyDetailPage({super.key, required this.api, required this.member});

  final CvApi api;
  final FamilyMember member;

  @override
  State<FamilyDetailPage> createState() => _FamilyDetailPageState();
}

class _FamilyDetailPageState extends State<FamilyDetailPage> {
  late FamilyMember _member = widget.member;
  bool _busy = false;

  Future<void> _edit() async {
    final updated = await Navigator.of(context).push<FamilyMember>(
      MaterialPageRoute(
        builder: (_) => FamilyFormPage(api: widget.api, existing: _member),
      ),
    );
    if (!mounted || updated == null) return;
    setState(() => _member = updated);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer ce membre ?'),
          content: Text(
            '${_member.fullName} sera retiré de la base de données.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await widget.api.deleteMember(_member.id);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.details)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(title: Text(_member.prenom)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          Center(
            child: MemberPhoto(
              imageUrl: _member.imageUrl,
              width: 180,
              height: 220,
              iconSize: 72,
            ),
          ),
          const SizedBox(height: 16),
          Center(child: _RelationChip(label: _member.parente)),
          const SizedBox(height: 10),
          Text(
            _member.fullName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Nom', value: _member.nom),
          _InfoRow(label: 'Postnom', value: _member.postnom),
          _InfoRow(label: 'Prénom', value: _member.prenom),
          _InfoRow(label: 'Lieu de naissance', value: _member.lieuNaissance),
          _InfoRow(label: 'Date de naissance', value: _member.dateLabel),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _busy ? null : _edit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Modifier'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _busy ? null : _delete,
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
            label: const Text('Supprimer'),
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.clay),
          ),
        ],
      ),
    );
  }
}

class _RelationChip extends StatelessWidget {
  const _RelationChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.forestDeep,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 148,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
