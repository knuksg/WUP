import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wup/components/constants.dart';
import 'package:wup/components/default_button.dart';
import 'package:wup/controllers/welcome_controller.dart';
import 'package:wup/routes/app_pages.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: kPrimaryColor,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text.rich(TextSpan(
                        text: '${controller.userName}님, ',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        children: const [
                          TextSpan(
                              text: '환영해요!',
                              style: TextStyle(color: kPrimaryColor))
                        ])),
                    const SizedBox(
                      height: 32,
                    ),
                    const Text('환'),
                    const Text('영'),
                    const Text('멘'),
                    const Text('트'),
                    const SizedBox(
                      height: 32,
                    ),
                    const Spacer(),
                    DefaultButton2(
                      text: 'Next',
                      press: () {
                        Get.offNamed(Routes.INPUT);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
