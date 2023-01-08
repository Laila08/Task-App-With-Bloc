import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:noteappudemy/counter/MainScreen.dart';
import 'package:noteappudemy/layouts/homeScreen.dart';

import 'components/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }

}
