import 'package:chat_app/helpers/show_alerts.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/custom_input.dart';
import 'package:provider/provider.dart';

import '../widgets/blue_button.dart';
import '../widgets/login_labels.dart';
import '../widgets/login_logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Logo superior
                  const Logo(
                    title: 'Registrate!',
                  ),
                  //Form + login button
                  _Form(),
                  //Register section
                  const Labels(
                    route: 'login',
                    message: 'Ya tienes cuenta?',
                  ),
                  //Terms
                  const Text(
                    'Términos y condiciones de uso.',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    SocketService socketService = Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInput(
          icon: Icons.perm_identity,
          placeholder: 'Nombre',
          textController: nameCtrl,
          keyboardType: TextInputType.text,
        ),
        CustomInput(
          icon: Icons.email_outlined,
          placeholder: 'Email',
          textController: emailCtrl,
          keyboardType: TextInputType.emailAddress,
        ),
        CustomInput(
          icon: Icons.lock_outline,
          placeholder: 'Password',
          textController: passCtrl,
          keyboardType: TextInputType.visiblePassword,
          isPassword: true,
        ),
        BlueButton(
          placeholder: 'Registrarse',
          onPressed: authService.authenticating
              ? null
              : () async {
                  final registerOK = await authService.register(
                      nameCtrl.text, emailCtrl.text, passCtrl.text);

                  if (registerOK == true) {
                    socketService.connect();
                    Navigator.pushReplacementNamed(context, 'users');
                  } else {
                    showAlert(context, 'Registro incorrecto', registerOK);
                  }
                },
        ),
      ]),
    );
  }
}
