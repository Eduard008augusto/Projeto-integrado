import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './database/var.dart' as globals;
import './services/token_service.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text('Run the app from the appropriate main file.'),
      ),
    ),
  ));
}

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  String _selectedRoute = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedRoute = ModalRoute.of(context)?.settings.name ?? '';
  }

  Widget _buildListTile({required IconData icon, required String title, required String routeName}) {
    bool isSelected = _selectedRoute == routeName;
    return ListTile(
      leading: Icon(icon, size: 30.0, color: isSelected ? const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0) : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          color: isSelected ? const Color.fromARGB(0xFF, 0x00, 0xB8, 0xE0) : Colors.black,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedRoute = routeName;
        });
        Navigator.pushNamed(context, routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined, size: 40.0),
            title: Text(
              globals.nomeUtilizador!,
              style: const TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              setState(() {
                _selectedRoute = '/perfil';
              });
              Navigator.pushNamed(context, '/perfil');
            },
          ),
          const Divider(
            height: 50,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(136, 41, 40, 40),
          ),
          _buildListTile(
            icon: Icons.home_outlined,
            title: 'Mapa dos Centros',
            routeName: '/mapa',
          ),
          const Divider(
            height: 50,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(136, 41, 40, 40),
          ),
          _buildListTile(
            icon: Icons.dashboard_outlined,
            title: 'Areas',
            routeName: '/areas',
          ),
          _buildListTile(
            icon: Icons.favorite_border,
            title: 'Favoritos',
            routeName: '/favoritos',
          ),
          const Divider(
            height: 50,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(136, 41, 40, 40),
          ),
          _buildListTile(
            icon: Icons.calendar_month_outlined,
            title: 'Eventos',
            routeName: '/feedeventos',
          ),
          _buildListTile(
            icon: Icons.settings_outlined,
            title: 'Definições',
            routeName: '/settings',
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text(
              'Terminar Sessão',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    icon: const Icon(Icons.info),
                    title: const Text('Deseja terminar sessão?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await TokenManager().logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text('Confirmar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Opacity(
                  opacity: 0.3,
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    height: 90.0,
                    width: 90.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
