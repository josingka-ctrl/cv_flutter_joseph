import 'package:material_ui/material_ui.dart';

import '../api/cv_api.dart';
import '../data/profile_data.dart';
import '../models/account.dart';
import '../theme/app_theme.dart';
import 'contact_page.dart';
import 'cv_page.dart';
import 'family_page.dart';
import 'login_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key, required this.api, required this.account});

  final CvApi api;
  final Account account;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  static const _titles = ['Mon CV', 'Ma famille', 'Contact'];

  late final List<Widget> _pages = [
    const CvPage(),
    FamilyPage(api: widget.api),
    const ContactPage(),
  ];

  void _select(int index) {
    setState(() => _index = index);
    _scaffoldKey.currentState?.closeDrawer();
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage(api: widget.api)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.paper,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: AppColors.forest,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.gold,
                      child: CircleAvatar(
                        radius: 33,
                        backgroundImage: AssetImage(ProfileData.photo),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      ProfileData.fullName,
                      style: TextStyle(
                        color: AppColors.ivory,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.account.email,
                      style: const TextStyle(color: AppColors.goldSoft),
                    ),
                  ],
                ),
              ),
              _DrawerTile(
                icon: Icons.badge_outlined,
                label: 'Mon CV',
                selected: _index == 0,
                onTap: () => _select(0),
              ),
              _DrawerTile(
                icon: Icons.family_restroom,
                label: 'Ma famille',
                selected: _index == 1,
                onTap: () => _select(1),
              ),
              _DrawerTile(
                icon: Icons.contact_mail_outlined,
                label: 'Contact',
                selected: _index == 2,
                onTap: () => _select(2),
              ),
              const Spacer(),
              const Divider(height: 1),
              _DrawerTile(
                icon: Icons.logout,
                label: 'Se déconnecter',
                selected: false,
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _select,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_mail_outlined),
            selectedIcon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? AppColors.forest : AppColors.muted,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.forestDeep : AppColors.ink,
        ),
      ),
      selected: selected,
      selectedTileColor: AppColors.goldSoft.withValues(alpha: 0.45),
      onTap: onTap,
    );
  }
}
