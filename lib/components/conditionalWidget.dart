import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,color: Colors.grey,size: 70,),
          Text('No Tasks Yet, Please Add Some Taskes',style: TextStyle(color: Colors.grey,fontSize: 16.0),)

        ],),
    );
  }
}