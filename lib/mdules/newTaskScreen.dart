import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteappudemy/components/TaskItem.dart';
import 'package:noteappudemy/components/conditionalWidget.dart';
import 'package:noteappudemy/cubit/cubit.dart';
import 'package:noteappudemy/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:  (context, state){},
      builder: (context, state){
        var tasks = AppCubit.get(context).newtasks;
        return tasks.length>0?ListView.separated(
            itemBuilder:(context,index)=>TaskItem(model: tasks[index],) ,
            separatorBuilder:(context,index)=>Padding(
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: Container(width: double.infinity,height: 1.0,color: Colors.grey[300],),
            ) ,
            itemCount:tasks.length):
        ConditionalWidget();
      } ,
    );
  }
}
/*
class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder:(context,index)=>TaskItem(model: tasks[index],) ,
        separatorBuilder:(context,index)=>Padding(
          padding: const EdgeInsetsDirectional.only(start: 20),
          child: Container(width: double.infinity,height: 1.0,color: Colors.grey[300],),
        ) ,
        itemCount:tasks.length);
  }
}
*/
