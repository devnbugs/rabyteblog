import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/pages/done.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/auth_service.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import 'package:wordpress_app/widgets/social_logins.dart';
import '../models/icon_data.dart';
import '../models/user.dart';
import '../utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key, this.popUpScreen});

  final bool? popUpScreen;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  var formKey = GlobalKey<FormState>();
  var userNameCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  final _btnController = RoundedLoadingButtonController();
  bool _checkboxTicked = false;

  bool offsecureText = true;
  Icon lockIcon = LockIcon.lock;

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

  Future _handleCreateUser() async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    if (userNameCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(context, 'Username is required');
    } else if (emailCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(context, 'Email is required');
    } else if (AppService.isEmailValid(emailCtrl.text) == false) {
      _btnController.reset();
      openSnacbar(context, 'Email is invalid');
    } else if (passwordCtrl.text.isEmpty) {
      _btnController.reset();
      openSnacbar(context, 'Password is required');
    } else if (_checkboxTicked == false) {
      _btnController.reset();
      openSnacbar(context, 'Please accept the terms & conditions to continue');
    } else {
      FocusScope.of(context).unfocus();
      AppService().checkInternet().then((hasInternet) async {
        if (!hasInternet) {
          _btnController.reset();
          if (!mounted) return;
          openSnacbar(context, 'no-internet'.tr());
        } else {
          UserModel userModel = UserModel(
            userName: userNameCtrl.text,
            emailId: emailCtrl.text,
            password: passwordCtrl.text,
          );
          await AuthService.createUser(userModel).then((UserResponseModel response) async {
            if (response.code == 200) {
              await ub.guestUserSignout().then((value) => ub.saveUserData(userModel, 'email')).then((value) => ub.setSignIn()).then((value) {
                _btnController.success();
                afterSignUp();
              });
            } else {
              _btnController.reset();
              if (!mounted) return;
              openSnacbar(context, response.message);
            }
          });
        }
      });
    }
  }

  void afterSignUp() async {
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
          children: [
            Text(
              'create-account',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
            ).tr(),
            const SizedBox(
              height: 10,
            ),
            Text(
              'follow-steps',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ).tr(),
            Visibility(visible: configs.socialLoginsEnabled, child: SocialLogins(afterSignIn: afterSignUp)),
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'username',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ).tr(),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  alignment: Alignment.center,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'enter-username'.tr(),
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
                  'email',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ).tr(),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  alignment: Alignment.center,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'enter-email'.tr(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(
                          Icons.email,
                          size: 20,
                        )),
                    controller: emailCtrl,
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
                  height: 40,
                ),
                Row(
                  children: [
                    Checkbox.adaptive(
                      value: _checkboxTicked,
                      checkColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          _checkboxTicked = value!;
                        });
                      },
                    ),
                    InkWell(
                      child: const Text(
                        'accept-terms',
                        style: TextStyle(color: Colors.blueAccent),
                      ).tr(),
                      onTap: () => AppService().openLinkWithCustomTab(context, context.read<ConfigBloc>().configs!.priivacyPolicyUrl.toString()),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                RoundedLoadingButton(
                  animateOnTap: true,
                  controller: _btnController,
                  onPressed: () => _handleCreateUser(),
                  width: MediaQuery.of(context).size.width * 1.0,
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  child: Wrap(
                    children: [
                      Text(
                        'create-account',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                      ).tr()
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 10),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "already-have-account",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
                      ).tr(),
                      TextButton(
                          child:
                              Text('login', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15)).tr(),
                          onPressed: () => nextScreenReplaceiOS(
                              context,
                              LoginPage(
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
