import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/pages/home.dart';
import 'package:wordpress_app/utils/next_screen.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final introKey = GlobalKey<IntroductionScreenState>();

    void onComplete() {
      nextScreenCloseOthersAnimation(context, const HomePage());
    }

    const PageDecoration pageDecoration = PageDecoration(
        bodyAlignment: Alignment.bottomCenter,
        bodyFlex: 0,
        titlePadding: EdgeInsets.only(left: 20, right: 20),
        bodyPadding: EdgeInsets.only(left: 20, right: 20, top: 20));

    const TextStyle titletextStyle =
        TextStyle(letterSpacing: -0.5, wordSpacing: 5, fontSize: 22, fontWeight: FontWeight.bold);

    const TextStyle bodytextStyle =
        TextStyle(color: Colors.blueGrey, fontSize: 18, fontWeight: FontWeight.normal);

    final PageViewModel page1 = PageViewModel(
        decoration: pageDecoration,
        titleWidget: const Text(
          'intro',
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: titletextStyle,
        ).tr(gender: 'title-1'),
        bodyWidget: const Text(
          'intro',
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: bodytextStyle,
        ).tr(gender: 'description-1'),
        image: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          alignment: Alignment.center,
          child: SvgPicture.asset(Config.introImage1),
        ));

    final PageViewModel page2 = PageViewModel(
        decoration: pageDecoration,
        titleWidget: const Text(
          'intro',
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: titletextStyle,
        ).tr(gender: 'title-2'),
        bodyWidget: const Text(
          'intro',
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: bodytextStyle,
        ).tr(gender: 'description-2'),
        image: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          alignment: Alignment.center,
          child: SvgPicture.asset(Config.introImage2),
        ));

    final PageViewModel page3 = PageViewModel(
        decoration: pageDecoration,
        titleWidget: const Text(
          'intro',
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: titletextStyle,
        ).tr(gender: 'title-3'),
        bodyWidget: const Text(
          'intro',
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: bodytextStyle,
        ).tr(gender: 'description-3'),
        image: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          alignment: Alignment.center,
          child: SvgPicture.asset(Config.introImage3),
        ));

    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        onDone: () => onComplete(),
        onSkip: () => onComplete(),
        globalBackgroundColor: Theme.of(context).canvasColor,
        pages: [page1, page2, page3],
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: false,
        //rtl: true, // Display as right-to-left
        back: const Icon(Icons.arrow_back),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
