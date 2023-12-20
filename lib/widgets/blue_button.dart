import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String placeholder;

  const BlueButton({
    Key? key,
    required this.onPressed,
    required this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(2),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: Center(
            child: Text(
          placeholder,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        )),
      ),
    );
  }
}
