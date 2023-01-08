import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:noteappudemy/components/customForm.dart';
import 'package:noteappudemy/cubit/cubit.dart';
import 'package:noteappudemy/cubit/states.dart';
import 'package:noteappudemy/mdules/archiveTaskScreen.dart';
import 'package:noteappudemy/mdules/doneTaskScreen.dart';
import 'package:noteappudemy/mdules/newTaskScreen.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController? timeController = TextEditingController();
  TextEditingController? dateController = TextEditingController();

  @override
  validationTitle(String x) {
    if (x.isEmpty) {
      return 'Title must not be empty';
    }
  }

  validationTime(String x) {
    if (x.isEmpty) {
      return 'Title must not be empty';
    }
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
        if (state is AppInsertDataBaseState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titels[cubit.currentIndex]),
            centerTitle: true,
          ),
          body: state is AppGetDataBaseLoadingState
              ? Center(child: CircularProgressIndicator())
              : cubit.widgets[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (cubit.isBottomSheetshow) {
                if (formKey.currentState!.validate()) {
                  cubit.insertToDataBase(
                      title: titleController.text,
                      time: timeController!.text,
                      date: dateController!.text);
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                        (context) => Container(
                              padding: const EdgeInsets.all(20.0),
                              color: Colors.white,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormFieldWidget(
                                        title: 'Task Title',
                                        validator: validationTitle,
                                        controller: titleController,
                                        textInputType: TextInputType.text,
                                        icon: Icons.title,
                                        onTap: () {
                                          print(
                                              '*****************************Timing tapped');
                                        }),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormFieldWidget(
                                      title: 'Task Time',
                                      validator: validationTime,

                                      controller: timeController!,
                                      //textInputType: TextInputType.datetime,
                                      icon: Icons.watch_later_outlined,
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController!.text = (value
                                              ?.format(context)
                                              .toString())!;
                                          //print(value.format(context));
                                        }).catchError((error) {
                                          print(
                                              '-------------------------------------------------------------');
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormFieldWidget(
                                      title: 'Task Date',
                                      validator: validationTime,
                                      controller: dateController!,
                                      //textInputType: TextInputType.datetime,
                                      icon: Icons.calendar_today,
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2023-03-05'))
                                            .then((value) {
                                          print(DateFormat.yMMMd()
                                              .format(value!));
                                          dateController!.text =
                                              DateFormat.yMMMd()
                                                  .format(value)
                                                  .toString();
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                        elevation: 20.0)
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(isShaw: false, icon: Icons.edit);
                });
                cubit.changeBottomSheetState(isShaw: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: 'Archived'),
            ],
          ),
        );
      }),
    );
  }
}

/*
  class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetshow = false;
  IconData fabIcon = Icons.edit;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  @override
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
  // Instance of 'Future<String>'
  // Future<String> getName()async{
  //   return 'Laila Anouar';
  // }

  void initState(){
    super.initState();
    createDataBase();
  }
   validationTitle(String x){
    if(x.isEmpty){
      return 'Title must not be empty';
    }
  }
  validationTime(String x){
    if(x.isEmpty){
      return 'Title must not be empty';
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titels[currentIndex]),
        centerTitle: true,
      ),
      body: tasks.length==0?Center(child: CircularProgressIndicator()):widgets[currentIndex],
      /*
      * ConditionalBuilder(
        condition: tasks.length>0,
        builder: (context) {
          return widgets[currentIndex];
        },
        fallback: (context) {
          return Center(child: CircularProgressIndicator());
      }
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /*
          * // ال تراي كاتش ما بتضمن انه حيطبع الاسم قبل ليلى
          try{
            var name = await getName();
            print(name);
            print('laila');
          }catch(error){
            print('error : ${error.toString()}');
          }
          */
          /*
          *  // بتضمن انه يتنفذ بالترتيب
          getName().then((value){
            print(value);
            print('laila');
          }).catchError((error){print('error: ${error.toString()}');});
          */
          if(isBottomSheetshow){
            if(formKey.currentState!.validate()){
              insertToDataBase(title: titleController.text,time:timeController.text ,date: dateController.text).then((value) {
                getDataFromDataBase(Database).then((value){
                  Navigator.pop(context);
                  setState((){
                    isBottomSheetshow=false;
                    fabIcon = Icons.edit;
                    tasks=value;
                    print('+++++++++++++++++++++++++++++++++++++++++++++++++ $tasks');
                  });
                });
              });
            }
          }
          else{
            scaffoldKey.currentState!.showBottomSheet((context) =>
                 Container(
                   padding: const EdgeInsets.all(20.0),
                   color: Colors.white,
                   child: Form(
                     key: formKey,
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         TextFormFieldWidget(title: 'Task Title', validator: validationTitle, controller: titleController,textInputType:TextInputType.text,icon: Icons.title
                             ,onTap: (){
                           print('*****************************Timing tapped');
                             }),
                         SizedBox(height: 20,),
                         TextFormFieldWidget(title: 'Task Time', validator: validationTime, controller: timeController,textInputType:TextInputType.datetime,icon: Icons.watch_later_outlined
                           ,onTap:(){
                           showTimePicker(context: context, initialTime: TimeOfDay.now(),).then((value){
                                 timeController.text=(value!.format(context).toString())??'';
                                 print(value!.format(context));
                           }).catchError((error){print('-------------------------------------------------------------');});
                           } ,),
                         SizedBox(height: 20,),
                         TextFormFieldWidget(title: 'Task Date', validator: validationTime ,controller: dateController,textInputType:TextInputType.datetime,icon: Icons.calendar_today
                           ,onTap:(){
                             showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse('2023-03-05'))
                                 .then((value){
                                   print(DateFormat.yMMMd().format(value!));
                                   dateController.text=DateFormat.yMMMd().format(value).toString();
                             });
                           } ,)
                       ],
                     ),
                   ),
                 ),
              elevation: 20.0
            ).closed.then((value){
              isBottomSheetshow=false;
              setState((){
                fabIcon = Icons.edit;
              });
            });
            isBottomSheetshow=true;
            setState((){
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index){
          setState((){
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu),label: 'Tasks',),
          BottomNavigationBarItem(icon: Icon(Icons.done),label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive),label: 'Archived'),
        ],
      ),
    );
  }

  void createDataBase()async{
    database = await openDatabase(
      'my_db.db',
      version: 1,
      onCreate:(database, version){
        print('Database created');
        database.execute(
            'CREATE TABLE tasks ( id INTEGER PRIMARY KEY , title TEXT , data TEXT , time TEXT , status TEXT)'
        ).then((value)=> print('Table tasks Created')).catchError((error){print('error: ${error.toString()}');});
      } ,
      onOpen: (Database){
        getDataFromDataBase(Database).then((value){
          tasks=value;
          print(tasks[0]);//{id: 1, title: First task, data: 1234, time: 456.789, status: new}
          print(tasks[0]['title']);//First task,
          print(tasks[0]['data']);//1234
        });
        print('Database Opened');
      },
    );
  }

  Future insertToDataBase({required String title,required String time,required String date,})async{
    return await database.transaction((txn){
      txn.rawInsert('INSERT INTO tasks (title, data, time,status) VALUES("$title", "$time", "$date","new")',)
          .then((value){
      print('$value Insert successfully');
    }).catchError((error){print('***************************************'+ error.toString());});
   return Future((){});
  });
}

  Future<List<Map>> getDataFromDataBase(database)async{
  return await database.rawQuery('SELECT * FROM tasks');
   }
  }*/
