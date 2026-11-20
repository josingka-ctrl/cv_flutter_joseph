import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import 'shell_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final id = _idController.text.trim();
    final password = _passwordController.text;
    if (id.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Veuillez remplir l’identifiant et le mot de passe.';
      });
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ShellPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: AppColors.forestDeep,
                    padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
                    child: const Column(
                      children: [
                        CircleAvatar(
                          radius: 54,
                          backgroundColor: AppColors.gold,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/joseph.jpg'),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Abbé Joseph Siringi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.ivory,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Curriculum vitæ',
                          style: TextStyle(
                            color: AppColors.goldSoft,
                            fontSize: 15,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Connexion',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Entrez votre identifiant pour consulter le parcours, la famille et les coordonnées.',
                              style: TextStyle(
                                color: AppColors.muted,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextField(
                              controller: _idController,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: 'Identifiant',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              onChanged: (_) {
                                if (_error != null) {
                                  setState(() => _error = null);
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: _passwordController,
                              obscureText: _hidePassword,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _hidePassword
                                      ? 'Afficher le mot de passe'
                                      : 'Masquer le mot de passe',
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              onChanged: (_) {
                                if (_error != null) {
                                  setState(() => _error = null);
                                }
                              },
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                _error!,
                                style: const TextStyle(
                                  color: AppColors.clay,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.gold,
                                foregroundColor: AppColors.ink,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _submit,
                              child: const Text(
                                'Se connecter',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Démonstration : identifiant joseph, mot de passe siringi.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 12.5,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
