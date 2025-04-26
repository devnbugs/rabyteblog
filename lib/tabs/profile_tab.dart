import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wordpress_app/blocs/notification_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wordpress_app/blocs/settings_bloc.dart';
import 'package:wordpress_app/blocs/theme_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/config.dart';
import 'package:wordpress_app/config/wp_config.dart';
import 'package:wordpress_app/pages/login.dart';
import 'package:wordpress_app/pages/security.dart';
import 'package:wordpress_app/pages/welcome.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../blocs/config_bloc.dart';
import '../widgets/language.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with AutomaticKeepAliveClientMixin {
  void openLicenceDialog() {
    final SettingsBloc sb = Provider.of<SettingsBloc>(context, listen: false);
    showDialog(
        context: context,
        builder: (_) {
          return AboutDialog(
            applicationName: Config.appName,
            applicationVersion: sb.appVersion,
            applicationIcon: const Image(
              image: AssetImage(Config.appIcon),
              height: 30,
              width: 30,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ub = context.watch<UserBloc>();
    final configs = context.read<ConfigBloc>().configs!;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: 140,
          pinned: true,
          backgroundColor: Theme.of(context).primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            title: const Text('settings', style: TextStyle(color: Colors.white)).tr(),
            titlePadding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
          ),
        ),
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: configs.loginEnabled,
                  child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor),
                      child: !ub.isSignedIn ? const GuestUserUI() : const UserUI()),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'general-settings',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.5, wordSpacing: 1),
                      ).tr(),
                      const SizedBox(height: 15),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 18,
                          child: const Icon(
                            Feather.bell,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text(
                          'get-notifications',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ).tr(),
                        trailing: Switch.adaptive(
                            inactiveThumbColor: Colors.grey,
                            value: context.watch<NotificationBloc>().subscribed,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool value) => context.read<NotificationBloc>().handleSubscription(context, value)),
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 18,
                          child: Icon(
                            Icons.wb_sunny,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text(
                          'dark-mode',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ).tr(),
                        trailing: Switch.adaptive(
                            inactiveThumbColor: Colors.grey,
                            value: context.watch<ThemeBloc>().darkTheme!,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (_) {
                              context.read<ThemeBloc>().toggleTheme();
                            }),
                      ),
                      Visibility(
                        visible: configs.multiLanguageEnabled,
                        child: Column(
                          children: [
                            const _Divider(),
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.purpleAccent,
                                radius: 18,
                                child: Icon(
                                  Icons.translate,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'language',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ).tr(),
                              trailing: const Icon(Feather.chevron_right),
                              onTap: () => nextScreenPopupiOS(context, const LanguagePopup()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'about-app',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.7, wordSpacing: 1),
                      ).tr(),
                      const SizedBox(height: 15),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 18,
                          child: Icon(
                            Feather.lock,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text(
                          'privacy-policy',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        onTap: () => AppService().openLinkWithCustomTab(context, configs.priivacyPolicyUrl),
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.pinkAccent,
                          radius: 18,
                          child: Icon(
                            Feather.star,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text(
                          'rate-app',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        onTap: () => AppService().launchAppReview(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'social-settings',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -0.7, wordSpacing: 1),
                      ).tr(),
                      const SizedBox(height: 15),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent[100],
                          radius: 18,
                          child: const Icon(
                            Feather.mail,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text(
                          'contact-us',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        onTap: () => AppService().openEmailSupport(context, configs.supportEmail),
                      ),
                      const _Divider(),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 18,
                          child: const Icon(
                            Feather.link,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text(
                          'our-website',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ).tr(),
                        trailing: const Icon(Feather.chevron_right),
                        onTap: () => AppService().openLinkWithCustomTab(context, WpConfig.baseURL),
                      ),
                      Visibility(
                        visible: configs.fbUrl != '',
                        child: Column(
                          children: [
                            const _Divider(),
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 18,
                                child: Icon(
                                  Feather.facebook,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'facebook',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ).tr(),
                              trailing: const Icon(Feather.chevron_right),
                              onTap: () => AppService().openLink(context, configs.fbUrl),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: configs.youtubeUrl != '',
                        child: Column(
                          children: [
                            const _Divider(),
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                radius: 18,
                                child: Icon(
                                  Feather.youtube,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'youtube',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ).tr(),
                              trailing: const Icon(Feather.chevron_right),
                              onTap: () => AppService().openLink(context, configs.youtubeUrl),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: configs.instagramUrl != '',
                        child: Column(
                          children: [
                            const _Divider(),
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.deepPurple,
                                radius: 18,
                                child: Icon(
                                  Feather.instagram,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'instagram',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ).tr(),
                              trailing: const Icon(Feather.chevron_right),
                              onTap: () => AppService().openLink(context, configs.instagramUrl),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: configs.twitterUrl != '',
                        child: Column(
                          children: [
                            const _Divider(),
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 18,
                                child: Icon(
                                  Feather.twitter,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'twitter',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ).tr(),
                              trailing: const Icon(Feather.chevron_right),
                              onTap: () => AppService().openLink(context, configs.twitterUrl),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: configs.threadsUrl != '',
                        child: Column(
                          children: [
                            const _Divider(),
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 18,
                                child: Icon(
                                  Feather.at_sign,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'threads',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ).tr(),
                              trailing: const Icon(Feather.chevron_right),
                              onTap: () => AppService().openLink(context, configs.threadsUrl),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: ub.isSignedIn,
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      _SecurityOption(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class _SecurityOption extends StatelessWidget {
  const _SecurityOption();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        isThreeLine: false,
        leading: const CircleAvatar(
          backgroundColor: Colors.redAccent,
          radius: 20,
          child: Icon(
            Feather.settings,
            size: 20,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'security',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ).tr(),
        trailing: const Icon(Feather.chevron_right),
        onTap: () => nextScreen(context, const SecurityPage()),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.0,
      thickness: 0.2,
      indent: 50,
      color: Colors.grey[400],
    );
  }
}

class GuestUserUI extends StatelessWidget {
  const GuestUserUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: Icon(
              Feather.user_plus,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'login',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ).tr(),
          trailing: const Icon(Feather.chevron_right),
          onTap: () => nextScreenPopupiOS(
              context,
              const LoginPage(
                popUpScreen: true,
              )),
        ),
      ],
    );
  }
}

class UserUI extends StatelessWidget {
  const UserUI({super.key});

  @override
  Widget build(BuildContext context) {
    final UserBloc ub = context.watch<UserBloc>();
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 18,
            child: Icon(
              Feather.user_check,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.name!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const _Divider(),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent[100],
            radius: 18,
            child: const Icon(
              Feather.mail,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            ub.email!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const _Divider(),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.redAccent[100],
            radius: 18,
            child: const Icon(
              Feather.log_out,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: Text(
            'logout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary),
          ).tr(),
          trailing: const Icon(Feather.chevron_right),
          onTap: () => openLogoutDialog(context),
        ),
      ],
    );
  }

  openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('logout-description').tr(),
            title: const Text('logout-title').tr(),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    _handleLogout(context);
                  },
                  child: const Text('logout').tr()),
            ],
          );
        });
  }

  Future _handleLogout(context) async {
    final UserBloc ub = Provider.of<UserBloc>(context, listen: false);
    await ub.userSignout().then((value) => nextScreenCloseOthersAnimation(context, const WelcomePage()));
  }
}
