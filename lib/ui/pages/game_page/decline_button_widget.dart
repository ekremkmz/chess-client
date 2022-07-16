import 'package:flutter/material.dart';

class DeclineButton extends StatelessWidget {
  const DeclineButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        )),
        backgroundColor: MaterialStateProperty.all(Colors.red),
      ),
      onPressed: onPressed,
      child: const Center(
        child: Icon(Icons.cancel),
      ),
    );
  }
}
