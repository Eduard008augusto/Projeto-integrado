// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './services/token_service.dart';

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
            onTap: () { Navigator.pushNamed(context, '/perfil'); },
          ),
          
          const Divider(
            height: 50,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(136, 41, 40, 40),
          ),
          
          ListTile(
            leading: const Icon(Icons.home_outlined, size: 30.0,),
            title: const Text(
              'Mapa dos Centros',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () { Navigator.pushNamed(context, '/mapa'); },
          ),

          const Divider(
            height: 50,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(136, 41, 40, 40),
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
            onTap: () { Navigator.pushNamed(context, '/scroll'); },
          ),

          const Divider(
            height: 50,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(136, 41, 40, 40),
          ),

          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text(
              'Eventos',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () { Navigator.pushNamed(context, '/feedeventos'); },
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
