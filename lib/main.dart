import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/Data/Data%20Provider/data_provider.dart';

import 'BLoC/notes_bloc.dart';
import 'Presentation/Screens/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize initDatabaseConnection()
  await DataProvider.initDatabaseConnection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>(create:(context) => NotesBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes',
        themeMode: ThemeMode.light,
        theme: ThemeData(
          primaryColor: CupertinoColors.black,
          scaffoldBackgroundColor: CupertinoColors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: const NotesScreen(),
      ),
    );
  }
}
