class ProfileData {
  static const courtesy = 'Abbé';
  static const name = 'Joseph Siringi';
  static const fullName = 'Abbé Joseph Siringi';
  static const title = 'Économe général';
  static const organization = 'Diocèse de Goma';
  static const city = 'Goma, République démocratique du Congo';
  static const phoneDisplay = '+243 813 875 830';
  static const phoneUri = 'tel:+243813875830';
  static const email = 'josingka@gmail.com';
  static const whatsappUri = 'https://wa.me/243813875830';
  static const mapsUri =
      'https://www.google.com/maps/search/?api=1&query=Goma%2C%20R%C3%A9publique%20d%C3%A9mocratique%20du%20Congo';

  static const githubUrl =
      'https://github.com/search?q=cv_flutter_joseph&type=repositories';
  static const githubLabel = 'cv_flutter_joseph';
  static const photo = 'assets/images/joseph.jpg';

  static const profile =
      'Prêtre catholique et économe général du diocèse de Goma. '
      'J’assure la gestion financière, administrative et matérielle des activités diocésaines. '
      'Je prépare la défense d’une licence en informatique de gestion, pour mettre les outils numériques au service de l’organisation.';

  static const formations = [
    Formation(
      diploma: 'Licence en Informatique de Gestion',
      school: 'Préparation de la défense',
      detail:
          'Parcours orienté vers la gestion, l’administration et les systèmes d’information.',
    ),
    Formation(
      diploma: 'Ministère sacerdotal',
      school: 'Diocèse de Goma',
      detail:
          'Prêtre au service de la pastorale et de la gestion de la vie diocésaine.',
    ),
  ];

  static const experiences = [
    Experience(
      role: 'Économe général',
      place: 'Diocèse de Goma',
      kind: 'Emploi',
      detail:
          'Gestion financière, administrative et matérielle. Organisation et suivi des activités du diocèse.',
    ),
    Experience(
      role: 'Application de gestion diocésaine',
      place: 'Projet personnel',
      kind: 'Projet',
      detail:
          'Conception d’un outil numérique pour la gestion administrative et le suivi des activités du diocèse.',
    ),
    Experience(
      role: 'Application mobile de curriculum vitæ',
      place: 'Flutter',
      kind: 'Projet',
      detail:
          'Application présentant le parcours et les coordonnées, avec une connexion réelle et la famille enregistrée dans la base via l’API REST.',
    ),
  ];

  static const technicalSkills = [
    'Gestion financière',
    'Gestion administrative',
    'Informatique de gestion',
    'Organisation',
    'Planification',
    'Communication',
    'Outils numériques',
    'Flutter',
  ];

  static const languages = [
    LanguageSkill('Français', 'Courant'),
    LanguageSkill('Kiswahili', 'Courant'),
  ];

  static const interests = [
    'Informatique',
    'Nouvelles technologies',
    'Gestion',
    'Projets de développement',
    'Vie pastorale',
  ];

}

class Formation {
  const Formation({
    required this.diploma,
    required this.school,
    required this.detail,
  });

  final String diploma;
  final String school;
  final String detail;
}

class Experience {
  const Experience({
    required this.role,
    required this.place,
    required this.kind,
    required this.detail,
  });

  final String role;
  final String place;
  final String kind;
  final String detail;
}

class LanguageSkill {
  const LanguageSkill(this.name, this.level);

  final String name;
  final String level;
}
