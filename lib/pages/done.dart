import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabyteblog/blocs/config_bloc.dart';
import 'package:rabyteblog/config/config.dart';
import 'package:rabyteblog/pages/home.dart';
import 'package:rabyteblog/pages/intro.dart';
import 'package:rabyteblog/utils/next_screen.dart';

class DonePage extends StatefulWidget {
  const DonePage({super.key});

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2000))
    .then((value) => _gotoNextScreen());
    super.initState();
  }

  _gotoNextScreen (){
    final configs = context.read<ConfigBloc>().configs!;
    if(configs.onBoardingEnbaled){
      nextScreenReplaceAnimation(context, const IntroPage());
    }else{
      nextScreenCloseOthersAnimation(context, const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: const Center(
          child: SizedBox(
        height: 280,
        width: 280,
        child: FlareActor(
          Config.doneAnimation,
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "done",
          //color: Theme.of(context).primaryColor.withOpacity(0.6),
        ),
      )),
    );
  }
}
