import 'package:flutter/material.dart';
import 'package:wup/app/theme/app_color.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String platform;

  const LoginButton({Key? key, required this.onPressed, required this.platform})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: kSecondaryColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                'assets/images/${platform}_logo.png',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'login_button'.tr(namedArgs: {'lang': platform}),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: kSecondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.navigate_next,
              color: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
