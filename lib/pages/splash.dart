import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/pages/home.dart';
import 'package:wordpress_app/pages/welcome.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/widgets/loading_indicator_widget.dart';
import '../config/config.dart';
import 'no_internet.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _afterSplash() async {
    final UserBloc ub = context.read<UserBloc>();
    final configs = context.read<ConfigBloc>().configs!;
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      if (ub.isSignedIn == true || ub.guestUser == true || !configs.welcomeScreenEnabled) {
        _gotoHomePage();
      } else {
        _gotoWelcomePage();
      }
    });
  }

  void _gotoHomePage() {
    nextScreenReplaceAnimation(context, const HomePage());
  }

  void _gotoWelcomePage() {
    nextScreenReplaceAnimation(context, const WelcomePage());
  }

  @override
  void initState() {
    
    // ignore: use_build_context_synchronously
    Future.microtask(() => context.read<ConfigBloc>().getConfigsData().then((bool hasData) {
          if (hasData) {
            _afterSplash();
          } else {
            debugPrint('No configs data found');
            if (!mounted) return;
            nextScreenReplaceAnimation(context, const NoInternet());
          }
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: SafeArea(child: LoadingIndicatorWidget()),
      body: Center(
        child: Image(
          height: 120,
          width: 120,
          image: AssetImage(Config.splash),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
