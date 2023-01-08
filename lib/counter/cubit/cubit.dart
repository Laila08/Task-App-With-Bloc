import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteappudemy/counter/cubit/states.dart';

class CounterCubit extends Cubit<CounterStates>{
  CounterCubit() : super(CounterInitialState());
  //instance of CounterCubit
  //to be more easily when use this cubit in many place
  static CounterCubit get(context) =>BlocProvider.of(context);
  int counter= 1;
  void minus(){
    counter--;
    emit(CounterMinusState(counter));
  }
  void plus(){
    counter++;
    emit(CounterPlusState(counter));
  }
}