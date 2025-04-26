import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/models/user.dart';
import 'package:wordpress_app/pages/welcome.dart';
import 'package:wordpress_app/services/auth_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({super.key});

  @override
  State<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  final formkey = GlobalKey<FormState>();
  final _btnCtlr = RoundedLoadingButtonController();
  final passwordCtlr = TextEditingController();

  _handleDeleteAccount() async {
    final UserBloc ub = context.read<UserBloc>();
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      FocusScope.of(context).requestFocus(FocusNode());
      _btnCtlr.start();
      await AuthService.loginWithEmail(ub.name!, passwordCtlr.text).then((UserModel? userModel) async {
        if (userModel != null && userModel.token != null) {
          await AuthService.deleteUserAccount(userModel.token!).then((bool value) async {
            if (value) {
              await ub.userSignout();
              _btnCtlr.success();
              Fluttertoast.showToast(msg: 'Account deleted successfully!');
              Future.delayed(const Duration(seconds: 1)).then((value) {
                if (!mounted) return;
                Navigator.pop(context);
                nextScreenCloseOthers(context, const WelcomePage());
              });
            } else {
              _btnCtlr.reset();
            }
          });
        } else {
          Fluttertoast.showToast(msg: 'Password is incorrect. Please try again');
          debugPrint('Problem while login');
          _btnCtlr.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.50,
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
        child: Column(
          children: [
            Form(
              key: formkey,
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(hintText: 'Enter your password'),
                controller: passwordCtlr,
                validator: (value) {
                  if (value!.isEmpty) return "Password shouldn't be empty";
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundedLoadingButton(
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
            )
          ],
        ),
      ),
    );
  }
}
