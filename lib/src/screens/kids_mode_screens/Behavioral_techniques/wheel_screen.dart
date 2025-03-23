import 'dart:math';
import 'package:adhd_helper/constants/appbar.dart';
import 'package:flutter/material.dart';
import 'package:adhd_helper/constants/background.dart'; // Import the background
import 'package:adhd_helper/src/widgets/submit_button.dart'; // Import the SubmitButton widget
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class StartWheel extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> rotationTween;

  StartWheel({
    Key? key,
    required this.animationController,
  })  : rotationTween = Tween<double>(begin: 0, end: 10 * 360).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0, 1, curve: Curves.decelerate),
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);
    return Scaffold(
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          background, // Use the same background as in KidsHomeScreen
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  AnimatedBuilder(
                    animation: animationController,
                    child: const Image(
                      image: AssetImage('assets/images/ch.png'),
                    ),
                    builder: (BuildContext context, Widget? child) {
                      return Transform.rotate(
                        angle:
                            (rotationTween.value * pi / getRandomDenominator()),
                        child: child,
                      );
                    },
                  ),
                  const Image(
                    image: AssetImage('assets/images/arrow.png'),
                    width: 90,
                    height: 90,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Use SubmitButton instead of ElevatedButton
              SubmitButton(
                onPressed: () {
                  animationController.reset();
                  animationController.forward();
                  /*int valeur = getRandomDenominator();
                  _saveRandomValueToFirestore(valeur);*/
                },
                buttonText: AppLocalizations.of(context)!.startPlaying,
              ),
            ],
          ),
        ],
      ),
    );
  }

  int getRandomDenominator() {
    Random random = Random();
    int min = 160;
    int max = 180;
    return min + random.nextInt(max - min + 1);
  }
}

class WheelScreen extends StatefulWidget {
  const WheelScreen({Key? key}) : super(key: key);

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Handle completion if needed
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StartWheel(animationController: animationController);
  }
}
