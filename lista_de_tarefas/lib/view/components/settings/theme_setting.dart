import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lista_de_tarefas/notifiers/theme_notifier.dart';
import 'package:provider/provider.dart';

class ThemeSettingDropdown extends StatefulWidget{
  const ThemeSettingDropdown({super.key});

  @override
  State<ThemeSettingDropdown> createState() => _ThemeSettingDropdownState();
}

class _ThemeSettingDropdownState extends State<ThemeSettingDropdown> {
  late ThemeMode selectedTheme;

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeState = context.watch<ThemeNotifier>();
    selectedTheme = themeState.themeMode;
    AppLocalizations localization = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(child: Text(localization.selectedTheme)),
        DropdownButton(
          value: themeState.themeMode,
          items: <DropdownMenuItem<ThemeMode>>[
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text(localization.light),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text(localization.dark),
            ),
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text(localization.deviceTheme),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedTheme = value!;
            });
            themeState.setTheme(selectedTheme);
          },
        )
      ],
    );
  }
}