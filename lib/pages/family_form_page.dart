import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../api/api_exception.dart';
import '../api/cv_api.dart';
import '../models/family_member.dart';
import '../theme/app_theme.dart';
import '../widgets/member_photo.dart';
import '../widgets/primary_button.dart';

class FamilyFormPage extends StatefulWidget {
  const FamilyFormPage({super.key, required this.api, this.existing});

  final CvApi api;
  final FamilyMember? existing;

  @override
  State<FamilyFormPage> createState() => _FamilyFormPageState();
}

class _FamilyFormPageState extends State<FamilyFormPage> {
  late final TextEditingController _nom;
  late final TextEditingController _postnom;
  late final TextEditingController _prenom;
  late final TextEditingController _lieu;
  late final TextEditingController _date;
  late final TextEditingController _parente;
  List<int>? _imageBytes;
  String? _imageFilename;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final member = widget.existing;
    _nom = TextEditingController(text: member?.nom ?? '');
    _postnom = TextEditingController(text: member?.postnom ?? '');
    _prenom = TextEditingController(text: member?.prenom ?? '');
    _lieu = TextEditingController(text: member?.lieuNaissance ?? '');
    _date = TextEditingController(text: member?.dateNaissance ?? '');
    _parente = TextEditingController(text: member?.parente ?? '');
  }

  @override
  void dispose() {
    _nom.dispose();
    _postnom.dispose();
    _prenom.dispose();
    _lieu.dispose();
    _date.dispose();
    _parente.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = _parseDate(_date.text.trim()) ?? DateTime(now.year - 30);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(today) ? today : initial,
      firstDate: DateTime(1900),
      lastDate: today,
    );
    if (picked == null) return;
    final month = picked.month.toString().padLeft(2, '0');
    final day = picked.day.toString().padLeft(2, '0');
    setState(() => _date.text = '${picked.year}-$month-$day');
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() {
      _imageBytes = bytes;
      _imageFilename = file.name;
    });
  }

  Future<void> _save() async {
    final input = FamilyInput(
      nom: _nom.text.trim(),
      postnom: _postnom.text.trim(),
      prenom: _prenom.text.trim(),
      lieuNaissance: _lieu.text.trim(),
      dateNaissance: _date.text.trim(),
      parente: _parente.text.trim(),
      imageBytes: _imageBytes,
      imageFilename: _imageFilename,
    );
    final localError = _validate(input);
    if (localError != null) {
      setState(() => _error = localError);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final saved = widget.existing == null
          ? await widget.api.createMember(input)
          : await widget.api.updateMember(widget.existing!.id, input);
      if (!mounted) return;
      Navigator.of(context).pop(saved);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.details);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String? _validate(FamilyInput input) {
    const limits = {
      'nom': 50,
      'postnom': 50,
      'prenom': 50,
      'lieu de naissance': 100,
      'parenté': 50,
    };
    final values = {
      'nom': input.nom,
      'postnom': input.postnom,
      'prenom': input.prenom,
      'lieu de naissance': input.lieuNaissance,
      'parenté': input.parente,
    };
    for (final entry in values.entries) {
      if (entry.value.isEmpty) {
        return 'Le champ ${entry.key} est obligatoire.';
      }
      final max = limits[entry.key]!;
      if (entry.value.length > max) {
        return 'Le champ ${entry.key} ne doit pas dépasser $max caractères.';
      }
    }
    if (input.dateNaissance.isEmpty) {
      return 'La date de naissance est obligatoire.';
    }
    final date = _parseDate(input.dateNaissance);
    if (date == null) {
      return 'La date doit être au format AAAA-MM-JJ.';
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date.isAfter(today)) {
      return 'La date de naissance ne peut pas être dans le futur.';
    }
    return null;
  }

  DateTime? _parseDate(String value) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
    if (match == null) return null;
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    final preview = _imageBytes;
    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        title: Text(editing ? 'Modifier le membre' : 'Nouveau membre'),
      ),
      body: ListView(
        key: const Key('family-form-list'),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
        children: [
          const Text(
            'Ces informations sont enregistrées dans la base de données.',
            style: TextStyle(color: AppColors.muted, height: 1.35),
          ),
          const SizedBox(height: 14),
          Center(
            child: preview != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      preview is Uint8List
                          ? preview
                          : Uint8List.fromList(preview),
                      width: 120,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  )
                : MemberPhoto(
                    imageUrl: widget.existing?.imageUrl,
                    width: 120,
                    height: 140,
                  ),
          ),
          TextButton.icon(
            onPressed: _busy ? null : _pickImage,
            icon: const Icon(Icons.photo_outlined),
            label: const Text('Choisir une photo'),
          ),
          _field(_nom, 'Nom', key: const Key('family-nom')),
          _field(_postnom, 'Postnom', key: const Key('family-postnom')),
          _field(_prenom, 'Prénom', key: const Key('family-prenom')),
          _field(_lieu, 'Lieu de naissance', key: const Key('family-lieu')),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
              key: const Key('family-date'),
              controller: _date,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Date de naissance',
                hintText: 'AAAA-MM-JJ',
                suffixIcon: IconButton(
                  tooltip: 'Choisir une date',
                  onPressed: _busy ? null : _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
            ),
          ),
          _field(
            _parente,
            'Lien de parenté',
            key: const Key('family-parente'),
            hint: 'Père, Mère, Frère, Sœur…',
          ),
          if (_error != null) ...[
            Text(
              _error!,
              style: const TextStyle(
                color: AppColors.clay,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
          ],
          PrimaryButton(label: 'Enregistrer', busy: _busy, onPressed: _save),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    required Key key,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        key: key,
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: label, hintText: hint),
      ),
    );
  }
}
