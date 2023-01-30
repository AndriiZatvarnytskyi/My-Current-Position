import 'package:flutter/material.dart';
import 'package:my_current_position/constance.dart';

class CustomButtonSocial extends StatelessWidget {
  final String text;

  final void Function()? onPressed;
  const CustomButtonSocial(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 40),
              child: Image.network(
                googleLogoImage,
                height: 25,
                width: 25,
              ),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
