import 'package:flutter/material.dart';

class Setting extends StatefulWidget{
  const Setting({super.key, required this.iconData, required this.label, required this.child});
  final IconData iconData;
  final String label;
  final Widget child;

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isExpanded = false;


  @override
  Widget build(BuildContext context) {
    void showSetting () {
      setState(() {
        isExpanded = !isExpanded;
      });
    }

    return GestureDetector(
      onTap: showSetting,
      child: Column(
        children: [
          //* Setting title, icon and arrow_down
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.iconData, size: Theme.of(context).textTheme.headlineLarge!.fontSize,),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.label,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )),
              AnimatedRotation(
                turns: isExpanded? 0.5 : 0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: const Icon(Icons.keyboard_arrow_down),
              ),
              
            ],
          ),

          //* Dropdown settings
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: widget.child,
            crossFadeState: isExpanded? CrossFadeState.showSecond : CrossFadeState.showFirst, 
            duration: const Duration(milliseconds: 200),
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeIn,
          )
        ],
      )
    );
  }
}