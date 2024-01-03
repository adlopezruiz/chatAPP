// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/helpers/show_alerts.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/custom_input.dart';
import 'package:provider/provider.dart';

import '../widgets/blue_button.dart';
import '../widgets/login_labels.dart';
import '../widgets/login_logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                    title: 'Buzzs are back!',
                  ),
                  //Form + login button
                  _Form(),
                  //Register section
                  const Labels(
                    isLogin: false,
                    route: 'register',
                    message: 'No tienes cuenta? Registrate!',
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

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
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
            placeholder: 'Login',
            onPressed: authService.authenticating
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final loginOk = await authService.login(
                        emailCtrl.text.trim(), passCtrl.text.trim());

                    if (loginOk) {
                      // TODO: Connect socket server
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      //Show alert
                      showAlert(context, 'Login incorrecto',
                          'Revise sus credenciales.');
                    }
                  }),
      ]),
    );
  }
}
