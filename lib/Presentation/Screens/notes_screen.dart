import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../BLoC/notes_bloc.dart';
import 'add_note_screen.dart';
import '../widgets/widgets.dart';
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {


  @override
  void initState() {
    BlocProvider.of<NotesBloc>(context).add(const FetchNotesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (pop){
        exit(0);
      },
      child: Scaffold(
        appBar: buildAppBar(),
        body: buildBody(context: context),
        floatingActionButton: buildFloatingActionButton(),
      ),
    );
  }

  AppBar buildAppBar(){
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Notes',
        style: TextStyle(fontSize: 24, color: CupertinoColors.white, fontWeight: FontWeight.w700),
      ),
      centerTitle: true,

    );
  }

  Widget buildBody({required BuildContext context}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child:  Padding(
          padding: const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 0),
          child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state){
                if(state.status == NotesStatus.loading){

                  return const Center(
                    child: CircularProgressIndicator(color: CupertinoColors.white,),
                  );

                }
                if(state.status == NotesStatus.notesLoaded){

                  return NotesGridviewWidget(notes: state.notes!);

                }
                if(state.status == NotesStatus.error){
                  return  Center(
                    child: Text(
                     state.message!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }
          ),
        ),
      ),
    );
  }

  Widget buildFloatingActionButton(){
    return FloatingActionButton(
      backgroundColor: Colors.teal,
      child: const Icon(Icons.add, color: CupertinoColors.white,),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const AddNoteScreen()),
        );
      },
    );
  }

}

