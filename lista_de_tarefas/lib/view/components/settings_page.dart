import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/view/components/page.dart';

import 'settings/language_setting.dart';


class SettingsPage extends StatelessWidget implements MyPage{
  const SettingsPage({super.key, required this.label, this.onLoad});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).cardColor, width: 1),
          ),
          child: const LanguageSetting(),
        )
      ],
    );
  }
  
  @override
  Icon get icon => const Icon(Icons.settings);
  
  @override
  final String label;
  
  @override
  final Function? onLoad;

}