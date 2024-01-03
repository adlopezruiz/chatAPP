import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String message;
  final bool isLogin;

  const Labels({
    Key? key,
    required this.route,
    required this.message,
    this.isLogin = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, route),
          child: Text(
            isLogin ? 'Iniciar sesión' : 'Regístrate!',
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
