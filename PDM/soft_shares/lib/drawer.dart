import 'package:flutter/material.dart';


void main() {
  runApp(const MenuDrawer());
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(height: 20.0,),

          ListTile(
            leading: const Icon(Icons.account_circle, size: 40.0,),
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
            leading: const Icon(Icons.home, size: 30.0,),
            title: const Text(
              'Centro Selecionado',
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
            leading: const Icon(Icons.dashboard),
            title: const Text(
              'Areas',
              style: TextStyle(fontSize: 18.0),
              ),
            onTap: () { Navigator.pushNamed(context, '/areas'); },
          ),

          ListTile(
            leading: const Icon(Icons.favorite),
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
            leading: const Icon(Icons.calendar_month),
            title: const Text(
              'Eventos',
              style: TextStyle(fontSize: 18.0),
              ),
            onTap: () { Navigator.pushNamed(context, '/'); },
          ),
          
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(
              'Definições',
              style: TextStyle(fontSize: 18.0),
              ),
            onTap: () { Navigator.pushNamed(context, '/'); },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Terminar Sessão',
              style: TextStyle(fontSize: 18.0),
              ),
            onTap: () { Navigator.pushNamed(context, '/login'); },
          ),
        ],
      ),
    );
  }
}