import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freelancer2capitalist/pages/login_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:freelancer2capitalist/pages/onboarding/widget/button_widget.dart';

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Investor-Freelancer Platform',
              body: 'Connect with Investors and Freelancers with Ease',
              image: buildImage('assets/ebook.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Swipe Cards',
              body:
                  'Find the perfect match for your project with our Tinder-like swipe cards.',
              image: buildImage('assets/manthumbs.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Video Calls',
              body:
                  'Communicate with potential investors and freelancers through video calls.',
              image: buildImage('assets/learn.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Chat Functionality',
              body:
                  'Keep in touch with your connections using our chat feature.',
              footer: ButtonWidget(
                text: 'Get Started',
                onClicked: () => goToHome(context),
                // padding: EdgeInsets.symmetric(
                //     horizontal: 12.0,
                //     vertical: 8.0), // adjust padding as desired
              ),
              image: buildImage('assets/readingbook.png'),
              decoration: getPageDecoration(),
            ),
          ],
          done:
              const Text('Read', style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () => goToHome(context),
          showSkipButton: true,
          skip: const Text(
            'Skip',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.left,
          ),

          onSkip: () => goToHome(context),
          next: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => log('Page $index selected'),
          globalBackgroundColor: Theme.of(context).primaryColor,
          dotsFlex: 0,
          nextFlex: 0,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      );

  void goToHome(context) => Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false);

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color.fromARGB(255, 248, 248, 248),
        //activeColor: Colors.orange,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle:
            const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: const TextStyle(fontSize: 20),
        bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
