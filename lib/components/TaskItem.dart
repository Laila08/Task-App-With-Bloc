import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteappudemy/cubit/cubit.dart';

class TaskItem extends StatelessWidget{
  Map model;
  TaskItem({required this.model});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dismissible(
      key: Key(model['id'].toString()),
      onDismissed:(diretion){
        AppCubit.get(context).deleteData(id: model['id']);
      } ,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(radius: 40.0,child: Text(model['data']??''),),
            SizedBox(width: 20.0,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model['title']??'',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
                  Text(model['time']??'',style: TextStyle(color: Colors.grey),)
                ],
              ),
            ),
            SizedBox(width: 20.0,),
            IconButton(onPressed: (){
              AppCubit.get(context).updateData(status: 'Done', id: model['id']);
            }, icon: Icon(Icons.check_box,color: Colors.green,)),
            IconButton(onPressed: (){
              AppCubit.get(context).updateData(status: 'Archive', id: model['id']);
            }, icon: Icon(Icons.archive,color: Colors.black45,)),
          ],
        ),
      ),
    );
  }
}
