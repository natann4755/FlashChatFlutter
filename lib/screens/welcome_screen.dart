import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/component/button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
//        upperBound: 100.0
    );

//    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = ColorTween(begin: Colors.lightBlue, end: Colors.white)
        .animate(controller);

    controller.forward();

//    controller.addStatusListener((status) {
//      if (status == AnimationStatus.completed){
//        controller.reverse(from: 1.0);
//      }else if(status == AnimationStatus.dismissed ){
//        controller.forward();
//      }
//    });

    controller.addListener(() {
      setState(() {});
      print(controller.value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,
      backgroundColor: animation.value,
      //      backgroundColor: Colors.red.withOpacity(controller.value),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
//                    height: controller.value*100,
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ["Flash Chat"],
//                  '${controller.value.toInt()}%',
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ButoonDesigned(
              mButtonColor: Colors.lightBlueAccent,
              mButtonSttring: 'Log In',
              mButtonFunction: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            ButoonDesigned(
              mButtonColor: Colors.blueAccent,
              mButtonSttring: 'Register',
              mButtonFunction: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
