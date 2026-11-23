class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  final int id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final String? imageUrl;

  String get fullName => '$prenom $nom $postnom'.trim();

  String get dateLabel {
    final parts = dateNaissance.split('-');
    if (parts.length >= 3 && parts[0].length == 4) {
      return '${parts[2].substring(0, 2)}/${parts[1]}/${parts[0]}';
    }
    return dateNaissance;
  }

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final rawDate = json['date_naissance']?.toString() ?? '';
    return FamilyMember(
      id: int.parse(json['id'].toString()),
      nom: json['nom']?.toString() ?? '',
      postnom: json['postnom']?.toString() ?? '',
      prenom: json['prenom']?.toString() ?? '',
      lieuNaissance: json['lieu_naissance']?.toString() ?? '',
      dateNaissance: rawDate.length >= 10 ? rawDate.substring(0, 10) : rawDate,
      parente: json['parente']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
    );
  }
}

class FamilyInput {
  const FamilyInput({
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageBytes,
    this.imageFilename,
  });

  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance;
  final String parente;
  final List<int>? imageBytes;
  final String? imageFilename;

  Map<String, String> toJson() {
    return {
      'nom': nom,
      'postnom': postnom,
      'prenom': prenom,
      'lieu_naissance': lieuNaissance,
      'date_naissance': dateNaissance,
      'parente': parente,
    };
  }
}
