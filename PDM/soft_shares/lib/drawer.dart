import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MenuDrawer());
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 20.0,),

          ListTile(
            leading: const Icon(Icons.account_circle_outlined, size: 40.0,),
            title: const Text(
              'NOME DO UTILIZADOR',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () { Navigator.pushNamed(context, '/'); },
          ),
          
          const Divider(
            height: 50,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(255, 41, 40, 40),
          ),
          
          ListTile(
            leading: const Icon(Icons.home_outlined, size: 30.0,),
            title: const Text(
              'Centro Selecionado',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () { Navigator.pushNamed(context, '/mapa'); },
          ),

          const Divider(
            height: 50,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(255, 41, 40, 40),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text(
              'Areas',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () { Navigator.pushNamed(context, '/areas'); },
          ),

          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text(
              'Favoritos',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () { Navigator.pushNamed(context, '/'); },
          ),

          const Divider(
            height: 50,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(255, 41, 40, 40),
          ),

          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text(
              'Eventos',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () { Navigator.pushNamed(context, '/feed'); },
          ),
          
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text(
              'Definições',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () { Navigator.pushNamed(context, '/settings'); },
          ),

          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text(
              'Terminar Sessão',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () { Navigator.pushNamed(context, '/login'); },
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
