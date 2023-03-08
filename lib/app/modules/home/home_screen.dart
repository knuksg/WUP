import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';
import 'package:wup/app/modules/home/home_controller.dart';
import 'package:wup/app/modules/home/test_screen.dart';
import 'package:wup/app/theme/theme.dart';
import 'package:wup/app/widgets/bottom_navigation_bar.dart';
import 'package:wup/app/widgets/default_button.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FluttermojiCircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey[200],
              ),
              Text(
                controller.userName,
                style: textTheme().displayLarge,
              ),
              const SizedBox(height: 16),
              DefaultButton(
                  press: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const GuideScreen();
                      },
                    );
                  },
                  text: 'Modal Test'),
              const SizedBox(height: 16),
              DefaultButton(
                  press: () {
                    controller.logout();
                  },
                  text: 'Logout'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(selectedIndex: 0),
    );
  }
}
