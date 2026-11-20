import 'package:material_ui/material_ui.dart';

import '../data/profile_data.dart';
import '../theme/app_theme.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
      children: const [
        _IdentityCard(),
        SizedBox(height: 14),
        _Block(
          icon: Icons.person_outline,
          title: 'Profil',
          child: Text(ProfileData.profile),
        ),
        SizedBox(height: 14),
        _Block(
          icon: Icons.school_outlined,
          title: 'Formation',
          child: _Formations(),
        ),
        SizedBox(height: 14),
        _Block(
          icon: Icons.work_outline,
          title: 'Expériences',
          child: _Experiences(),
        ),
        SizedBox(height: 14),
        _Block(
          icon: Icons.memory_outlined,
          title: 'Compétences techniques',
          child: _SkillWrap(labels: ProfileData.technicalSkills),
        ),
        SizedBox(height: 14),
        _Block(
          icon: Icons.translate,
          title: 'Compétences linguistiques',
          child: _Languages(),
        ),
        SizedBox(height: 14),
        _Block(
          icon: Icons.favorite_border,
          title: 'Centres d’intérêt',
          child: _SkillWrap(labels: ProfileData.interests),
        ),
      ],
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 58,
              backgroundColor: AppColors.gold,
              child: CircleAvatar(
                radius: 54,
                backgroundImage: AssetImage(ProfileData.photo),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              ProfileData.fullName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              ProfileData.title,
              style: TextStyle(
                color: AppColors.forest,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              ProfileData.organization,
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.place_outlined, size: 16, color: AppColors.gold),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    ProfileData.city,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.forest, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _Formations extends StatelessWidget {
  const _Formations();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < ProfileData.formations.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _FormationTile(item: ProfileData.formations[i]),
        ],
      ],
    );
  }
}

class _FormationTile extends StatelessWidget {
  const _FormationTile({required this.item});

  final Formation item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.circle, size: 10, color: AppColors.gold),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.diploma,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                item.school,
                style: const TextStyle(
                  color: AppColors.forest,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(item.detail, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _Experiences extends StatelessWidget {
  const _Experiences();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < ProfileData.experiences.length; i++) ...[
          if (i > 0) const Divider(height: 22),
          _ExperienceTile(item: ProfileData.experiences[i]),
        ],
      ],
    );
  }
}

class _ExperienceTile extends StatelessWidget {
  const _ExperienceTile({required this.item});

  final Experience item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.role,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.goldSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.kind,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.forestDeep,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          item.place,
          style: const TextStyle(
            color: AppColors.forest,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(item.detail),
      ],
    );
  }
}

class _SkillWrap extends StatelessWidget {
  const _SkillWrap({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final label in labels)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EBDD),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE0D3BC)),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
      ],
    );
  }
}

class _Languages extends StatelessWidget {
  const _Languages();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < ProfileData.languages.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  ProfileData.languages[i].name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                ProfileData.languages[i].level,
                style: const TextStyle(
                  color: AppColors.forest,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
