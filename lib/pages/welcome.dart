import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/pages/create_account.dart';
import 'package:wordpress_app/pages/done.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/widgets/app_logo.dart';
import 'package:wordpress_app/widgets/language.dart';

import '../blocs/config_bloc.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _onSkipPressed() async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    await ub.loginAsGuestUser().then((_) {
      if (!mounted) return;
      nextScreenReplaceAnimation(context, const DonePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            actions: [
              TextButton(
                style: const ButtonStyle(),
                child: const Text(
                  'skip',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ).tr(),
                onPressed: () => _onSkipPressed(),
              ),
              Visibility(
                visible: context.read<ConfigBloc>().configs!.multiLanguageEnabled,
                child: IconButton(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: 10),
                  iconSize: 18,
                  icon: const Icon(Icons.translate),
                  onPressed: () {
                    nextScreenPopupiOS(context, const LanguagePopup());
                  },
                ),
              ),
            ],
          ),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Image(
                        image: AssetImage(Config.splash),
                        height: 130,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'welcome-to',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
                              ).tr(),
                              const SizedBox(
                                width: 8,
                              ),
                              const AppLogo(
                                height: 40,
                                width: 160,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 35, right: 35, top: 15),
                            child: Text(
                              'welcome-intro',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.secondary),
                            ).tr(),
                          )
                        ],
                      ),
                    ],
                  )),
              const Spacer(),
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: 45,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "login-to-continue",
                              style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600, color: Colors.white,),
                            ).tr(),
                            const SizedBox(
                              width: 15,
                            ),
                            const Icon(
                              Feather.arrow_right,
                              color: Colors.white,
                            )
                          ],
                        ),
                        onPressed: () => nextScreenPopupiOS(context, const LoginPage()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "no-account",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.secondary),
                        ).tr(),
                        TextButton(
                          child: Text(
                            'create-account',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                          ).tr(),
                          onPressed: () => nextScreenPopupiOS(context, const CreateAccountPage()),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
