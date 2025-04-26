import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/models/user.dart';
import 'package:wordpress_app/pages/done.dart';
import 'package:wordpress_app/pages/create_account.dart';
import 'package:wordpress_app/pages/forgot_password.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import 'package:wordpress_app/widgets/social_logins.dart';
import '../models/icon_data.dart';
import '../services/auth_service.dart';
import '../utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.popUpScreen});

  final bool? popUpScreen;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formKey = GlobalKey<FormState>();
  var userNameCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  final _btnController = RoundedLoadingButtonController();

  bool offsecureText = true;
  Icon lockIcon = LockIcon.lock;

  Future _handleLoginWithUsernamePassword() async {
    final UserBloc ub = context.read<UserBloc>();
    if (userNameCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(context, 'Username is required');
    } else if (passwordCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(context, 'Password is required');
    } else {
      FocusScope.of(context).unfocus();
      AppService().checkInternet().then((hasInternet) async {
        if (!hasInternet) {
          _btnController.reset();
          if (!mounted) return;
          openSnacbar(context, 'no-internet'.tr());
        } else {
          await AuthService.loginWithEmail(userNameCtrl.text, passwordCtrl.text).then((UserModel? userModel) async {
            if (userModel != null) {
              _btnController.reset();
              ub.guestUserSignout().then((value) => ub.saveUserData(userModel, 'email')).then((value) => ub.setSignIn()).then((value) {
                _btnController.success();
                afterSignIn();
              });
            } else {
              _btnController.reset();
              if (!mounted) return;
              openSnacbar(context, 'Username or password is invalid');
            }
          });
        }
      });
    }
  }

  void _onlockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon.open;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon.lock;
      });
    }
  }

  void afterSignIn() async {
    if (widget.popUpScreen == null || widget.popUpScreen == false) {
      nextScreenReplaceAnimation(context, const DonePage());
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configs = context.read<ConfigBloc>().configs!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'login',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
            ).tr(),
            const SizedBox(
              height: 10,
            ),
            Text(
              'login-to-access-features',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ).tr(),
            Visibility(
                visible: configs.socialLoginsEnabled,
                child: SocialLogins(
                  afterSignIn: afterSignIn,
                )),
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'username/email',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ).tr(),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  alignment: Alignment.center,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'enter-username-or-email'.tr(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(
                          Icons.person,
                          size: 20,
                        )),
                    controller: userNameCtrl,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Text(
                  'password',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ).tr(),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.center,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'enter-password'.tr(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(icon: lockIcon, onPressed: () => _onlockPressed()),
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 20,
                        )),
                    controller: passwordCtrl,
                    obscureText: offsecureText,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text(
                      'forgot-password',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueAccent),
                    ).tr(),
                    onPressed: () => nextScreeniOS(context, const ForgotPasswordPage()),
                  ),
                ),
                RoundedLoadingButton(
                  animateOnTap: true,
                  controller: _btnController,
                  onPressed: () => _handleLoginWithUsernamePassword(),
                  width: MediaQuery.of(context).size.width * 1.0,
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  child: Wrap(
                    children: [
                      Text(
                        'login',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                      ).tr()
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 15),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "no-account",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
                      ).tr(),
                      TextButton(
                          child: Text(
                            'create-account',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                          ).tr(),
                          onPressed: () => nextScreenReplaceiOS(
                              context,
                              CreateAccountPage(
                                popUpScreen: widget.popUpScreen,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
