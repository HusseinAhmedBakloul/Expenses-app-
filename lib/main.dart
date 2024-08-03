import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signup/Models/AccountModel.dart';
import 'package:signup/Models/AnalyticsModel.dart';
import 'package:signup/Models/IncomeModel.dart';
import 'package:signup/login/Auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyCBo82cZ_NM8Ia38Ga_LpuzauUzarmtKSE",
          appId: "1:808838335038:web:47a23e00285a3e18af5f6f",
          messagingSenderId: "808838335038",
          projectId: "fir-expense-74b5e",
       ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IncomeModel(),),
        ChangeNotifierProvider(create: (context) => AccountModel(),),
        ChangeNotifierProvider(create: (_) => AnalyticsModel()),
      ],
      child: Expenses(),
    ),);
}

class Expenses extends StatelessWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Auth(),
    );
  }
}

