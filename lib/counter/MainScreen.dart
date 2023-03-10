import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteappudemy/counter/cubit/cubit.dart';
import 'package:noteappudemy/counter/cubit/states.dart';

class CounterScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(BuildContext context)=>CounterCubit() ,
        child: BlocConsumer<CounterCubit,CounterStates>(
          listener:(context, state){
            if(state is CounterMinusState){
              //print('Minus State ${state.counter}');
            }
            if(state is CounterPlusState){
              //print('Plus State  ${state.counter}');
            }
          } ,
            builder:(context, state)=> Scaffold(
              body: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){
                      CounterCubit.get(context).minus();
                    }, child: Text('MINUS')),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('${CounterCubit.get(context).counter}',style: TextStyle(fontSize: 50,fontWeight: FontWeight.w900),),
                    ),
                    TextButton(onPressed: (){
                      CounterCubit.get(context).plus();
                    }, child: Text('PLUS'))

                  ],
                ),
              ),
            ),));
  }

}