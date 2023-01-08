import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteappudemy/cubit/states.dart';
import 'package:noteappudemy/mdules/archiveTaskScreen.dart';
import 'package:noteappudemy/mdules/doneTaskScreen.dart';
import 'package:noteappudemy/mdules/newTaskScreen.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  List<Map> newtasks=[];
  List<Map> donetasks=[];
  List<Map> archeivetasks=[];

  int currentIndex = 0;
  List<Widget> widgets =[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titels =[
    'New Tasks Screen',
    'Done Tasks Screen',
    'Archived Tasks Screen'
  ];
  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  late Database database;

  void createDataBase(){
     openDatabase(
      'my_db.db',
      version: 1,
      onCreate:(database, version){
        print('Database created');
        database.execute(
            'CREATE TABLE tasks ( id INTEGER PRIMARY KEY , title TEXT , data TEXT , time TEXT , status TEXT)'
        ).then((value)=> print('Table tasks Created')).catchError((error){print('error: ${error.toString()}');});
      } ,
      onOpen: (Database){
        getDataFromDataBase(Database);
        print('Database Opened');
      },
    ).then((value) {
      database=value;
      emit(AppCreateDataBaseState());
    }
     );
  }

   insertToDataBase({required String title,required String time,required String date,})async{
     database.transaction((txn){
      txn.rawInsert('INSERT INTO tasks (title, data, time,status) VALUES("$title", "$time", "$date","new")',)
          .then((value){
        print('$value Insert successfully');
        emit(AppInsertDataBaseState());

        getDataFromDataBase(database);
      }).catchError((error){print('***************************************'+ error.toString());});
      return Future((){});
    });
  }

 void getDataFromDataBase(database){
    newtasks=[];
    donetasks=[];
    archeivetasks=[];

    emit(AppGetDataBaseLoadingState());
   database.rawQuery('SELECT * FROM tasks').then((value){
     value.forEach((element) {
       if(element['status']=='new'){
         newtasks.add(element);
       }else if(element['status']=='Done'){
         donetasks.add(element);
       } else  archeivetasks.add(element);
     });

     emit(AppGetDataBaseState());
   });
  }

  bool isBottomSheetshow = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({required bool isShaw , required IconData icon}){
    isBottomSheetshow = isShaw;
    fabIcon = icon;
    emit(AppBootomSheetState());
  }

  void updateData({required String status , required int id}){
  database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value){
          getDataFromDataBase(database);
          emit(AppUpdateDataBaseState());
  });
  }

  void deleteData({required int id}){
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value){
      getDataFromDataBase(database);
      emit(AppDeleteDataBaseState());
    });
  }
}