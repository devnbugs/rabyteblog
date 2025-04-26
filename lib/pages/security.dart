import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/pages/delete_social_user.dart';
import 'package:wordpress_app/pages/delete_user.dart';


class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {

  
  _openDeletePopup (){
    final UserBloc ub = context.read<UserBloc>();
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).canvasColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context, builder: (context){
        if(ub.signInProvider == 'email'){
          return const DeleteUser();
        }else{
          return const DeleteSocialUser();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('security').tr(),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(15),
                isThreeLine: false,
                title: const Text(
                  'account-delete',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ).tr(),
                leading: const CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 20,
                  child: Icon(
                    Feather.trash,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: ()=> _openDeletePopup()
              ),
            ],
          ),
        ],
      ),
    );
  }
}




