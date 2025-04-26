import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/config_bloc.dart';
import 'package:wordpress_app/utils/toast.dart';
import '../blocs/user_bloc.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class SocialLogins extends StatefulWidget {
  const SocialLogins({super.key, required this.afterSignIn});
  final VoidCallback afterSignIn;

  @override
  State<SocialLogins> createState() => _SocialLoginsState();
}

class _SocialLoginsState extends State<SocialLogins> {
  bool googleLoginStarted = false;
  bool fbLoginStarted = false;
  bool appleLoginStarted = false;

  _handleGoogleSignIn() async {
    final ub = context.read<UserBloc>();
    setState(() => googleLoginStarted = true);
    UserModel? user = await AuthService.signInWithGoogle();
    if (user != null) {
      debugPrint(user.toJson().toString());
      ub
          .guestUserSignout()
          .then((_) => ub.saveUserData(user, 'google'))
          .then((_) => ub.setSignIn())
          .then((_) {
        setState(() => googleLoginStarted = true);
        widget.afterSignIn();
      });
    } else {
      await AuthService.googleSignIn.signOut();
      setState(() => googleLoginStarted = false);
      openToast('Error on Google Login. Please try again!');
      debugPrint('google login error');
    }
  }

  _handleFacebookSignIn() async {
    final ub = context.read<UserBloc>();
    setState(() => fbLoginStarted = true);
    UserModel? user = await AuthService.signInWithFacebook();
    if (user != null) {
      debugPrint(user.toJson().toString());
      ub
          .guestUserSignout()
          .then((_) => ub.saveUserData(user, 'fb'))
          .then((_) => ub.setSignIn())
          .then((_) {
        setState(() => fbLoginStarted = true);
        widget.afterSignIn();
      });
    } else {
      await AuthService.facebookAuth.logOut();
      setState(() => fbLoginStarted = false);
      openToast('Error on Facebook Login. Please try again!');
      debugPrint('fb login error');
    }
  }

  _handleAppleSignIn () async{
    final ub = context.read<UserBloc>();
    setState(() => appleLoginStarted = true);
    UserModel? user = await AuthService.signInWithApple().onError((error, stackTrace){
      setState(()=> appleLoginStarted = false);
      return null;
    });
    if (user != null) {
      debugPrint(user.toJson().toString());
      ub
          .guestUserSignout()
          .then((_) => ub.saveUserData(user, 'apple'))
          .then((_) => ub.setSignIn())
          .then((_) {
        setState(() => appleLoginStarted = true);
        widget.afterSignIn();
      });
    } else {
      setState(() => appleLoginStarted = false);
      openToast('Error on Apple Login. Please try again!');
      debugPrint('apple login error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _handleGoogleSignIn(),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueAccent,
              child: googleLoginStarted
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(        
                      FontAwesome.google,
                      size: 22,
                      color: Colors.white,
                    ),
            ),
          ),
          Visibility(
            visible: context.read<ConfigBloc>().configs!.fbLoginEnabled,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => _handleFacebookSignIn(),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.indigo,
                    child: fbLoginStarted
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Icon(
                            FontAwesome.facebook,
                            size: 22,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Visibility(
            visible: Platform.isIOS,
            child: InkWell(
              onTap: () => _handleAppleSignIn(),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.shade900,
                child: appleLoginStarted
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Icon(
                        FontAwesome.apple,
                        size: 22,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
