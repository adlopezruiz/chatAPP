import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/users_page.dart';
import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return const Center(
            child: Text('Cargando...'),
          );
        },
        future: checkLoginState(context).then((isAuthenticated) {
          if (isAuthenticated) {
            socketService.connect();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const UsersPage(),
                transitionDuration: const Duration(milliseconds: 0),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LoginPage(),
                transitionDuration: const Duration(milliseconds: 0),
              ),
            );
          }
        }),
      ),
    );
  }

  Future<bool> checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);

    final authenticated = await authService.isLoggedIn();
    return authenticated;
  }
}
