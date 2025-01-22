import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lista_de_tarefas/notifiers/locale_notifier.dart';
import 'package:provider/provider.dart';

class LanguageSettingDropdown extends StatefulWidget{
  const LanguageSettingDropdown({super.key});

  @override
  State<LanguageSettingDropdown> createState() => _LanguageSettingDropdownState();
}

class _LanguageSettingDropdownState extends State<LanguageSettingDropdown> {
  Locale? selectedLocale;
  Map<String, String> languages = {
    "en": "English",
    "pt": "Português",
    "fr": "Français",
    "es": "Español",
    "ru": "Русский",
    "ja": "日本語",
    "zh": "中文",
    "ar": "العربية",
  };

  @override
  Widget build(BuildContext context) {
    LocaleNotifier localeState = context.watch<LocaleNotifier>();
    selectedLocale = localeState.locale;

    return Row(
      children: [
        Expanded(child: Text(AppLocalizations.of(context)!.selectedLanguage)),
        DropdownButton(
          value: localeState.locale,
          hint: DropdownMenuItem(
            value: null,
            child: Text(AppLocalizations.of(context)!.deviceLanguage),
          ),
          items: AppLocalizations.supportedLocales.map((locale) {
            return DropdownMenuItem(
              value: locale,
              child: Text(languages[locale.toString()] ?? 'Unexpected language: ${locale.toString()}'),
            );
          }).toList(), 
          onChanged: (value) {
            setState(() {
              selectedLocale = value;
            });
            localeState.changeLocale(value);
          },
        )
      ],
    );
  }
}