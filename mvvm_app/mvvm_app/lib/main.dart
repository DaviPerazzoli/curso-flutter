import 'package:flutter/material.dart';
import 'package:mvvm_app/model/model.dart';
import 'package:mvvm_app/viewmodel/viewmodel.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    AdviceModel model = AdviceModel();
    AdviceState viewmodel = AdviceState(model);

    return ChangeNotifierProvider(
      create: (context) => viewmodel,
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(),
        ),
    );
    
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});


  @override
  Widget build(BuildContext context) {
    var adviceState = context.watch<AdviceState>();
    var advice = adviceState.advice;
    var errorMessage = adviceState.errorMessage;



    return Scaffold(
      body: Column(
        children: [
          if (errorMessage != null)
            Text(errorMessage, style: Theme.of(context).textTheme.labelSmall?.apply(color: Colors.red),),
          if (errorMessage == null && advice == null)
            const CircularProgressIndicator(),
          if (advice != null)
            Text(advice),
          ElevatedButton(onPressed: adviceState.nextAdvice, child: const Text('next'))
        ]
        ),
    );
  }

}