import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordpress_app/config/language_config.dart';
import 'package:wordpress_app/widgets/country_flag.dart';

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({super.key});

  @override
  State<LanguagePopup> createState() => _LanguagePopupState();
}

class _LanguagePopupState extends State<LanguagePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('select-language').tr(),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: LanguageConfig.languages.length,
        separatorBuilder: (ctx, index) => const Divider(
          height: 5,
        ),
        itemBuilder: (BuildContext context, int index) {
          final Locale currentLocale = context.locale;
          final Locale locale = Locale(
            LanguageConfig.languages.values.elementAt(index).first,
            LanguageConfig.languages.values.elementAt(index).last,
          );
          final String languageName =
              LanguageConfig.languages.keys.elementAt(index);
          return ListTile(
            leading: CountryFlag(countryCode: locale.countryCode.toString()),
            horizontalTitleGap: 15,
            title: Text(
              languageName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Visibility(
              visible: currentLocale == locale,
              child: const Icon(Icons.done),
            ),
            onTap: () async {
              final engine = WidgetsFlutterBinding.ensureInitialized();
              await context.setLocale(locale);
              await engine.performReassemble();
            },
          );
        },
      ),
    );
  }
}
