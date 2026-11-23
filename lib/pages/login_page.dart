import 'package:material_ui/material_ui.dart';

import '../api/api_exception.dart';
import '../api/cv_api.dart';
import '../models/account.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import 'register_page.dart';
import 'shell_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.api});

  final CvApi api;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final localError = _validate(email, password);
    if (localError != null) {
      setState(() => _error = localError);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final account = await widget.api.login(email: email, password: password);
      if (!mounted) return;
      _openApp(account);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.details);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _openApp(Account account) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ShellPage(api: widget.api, account: account),
      ),
      (_) => false,
    );
  }

  Future<void> _openRegister() async {
    final account = await Navigator.of(context).push<Account>(
      MaterialPageRoute(builder: (_) => RegisterPage(api: widget.api)),
    );
    if (!mounted || account == null) return;
    _openApp(account);
  }

  String? _validate(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return 'Veuillez remplir l’email et le mot de passe.';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Entrez une adresse email valide.';
    }
    return null;
  }

  void _clearError() {
    if (_error != null) setState(() => _error = null);
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
                            backgroundImage: AssetImage(
                              'assets/images/joseph.jpg',
                            ),
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
                              'La connexion vérifie l’email et le mot de passe dans la base de données.',
                              style: TextStyle(
                                color: AppColors.muted,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextField(
                              controller: _emailController,
                              key: const Key('login-email'),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              onChanged: (_) => _clearError(),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: _passwordController,
                              key: const Key('login-password'),
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
                              onChanged: (_) => _clearError(),
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
                            PrimaryButton(
                              label: 'Se connecter',
                              busy: _busy,
                              onPressed: _submit,
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: _busy ? null : _openRegister,
                              child: const Text('Créer un compte'),
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
