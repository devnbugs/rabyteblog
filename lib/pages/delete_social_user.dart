import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/pages/welcome.dart';
import 'package:wordpress_app/utils/next_screen.dart';

import '../utils/toast.dart';

class DeleteSocialUser extends StatefulWidget {
  const DeleteSocialUser({super.key});

  @override
  State<DeleteSocialUser> createState() => _DeleteSocialUserState();
}

class _DeleteSocialUserState extends State<DeleteSocialUser> {


  final _btnCtlr = RoundedLoadingButtonController();

  

  _handleDeleteAccount() async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    _btnCtlr.start();
    await ub.userSignout().then((value){
      Future.delayed(const Duration(seconds: 1)).then((value){
        _btnCtlr.success();
        openToast('Account deleted successfully!');
        Future.delayed(const Duration(seconds: 1)).then((value){
          if (!mounted) return;
          Navigator.pop(context);
          nextScreenCloseOthersAnimation(context, const WelcomePage());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 150,
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
        child: RoundedLoadingButton(
          animateOnTap: false,
          controller: _btnCtlr,
          elevation: 0,
          color: Theme.of(context).primaryColor,
          onPressed: () => _handleDeleteAccount(),
          child: Text(
            'account-delete-confirm',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ).tr(),
        ),
      ),
    );
  }
}
