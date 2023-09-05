import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;

import '../../BLoC/notes_bloc.dart';
import 'notes_screen.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleTextFieldController = TextEditingController();
  final descriptionTextFieldController = TextEditingController();

  late String title = '';
  late String description = '';
  bool isValid = false;

  @override
  void initState() {
    titleTextFieldController.addListener(() {
      _formKey.currentState!.validate();
    });
    descriptionTextFieldController.addListener(() {
      _formKey.currentState!.validate();
    });
    super.initState();
  }

  String? validate() {
    if (titleTextFieldController.text.isNotEmpty &&
        descriptionTextFieldController.text.isNotEmpty) {
      title = titleTextFieldController.text;
      description = descriptionTextFieldController.text;
      isValid = true;
    } else {
      isValid = false;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context: context),
    );
  }

  AppBar buildAppBar() => AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotesScreen(),
                  ),
                ),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: CupertinoColors.white,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isValid == true ? Colors.teal : Colors.black54,
              ),
              onPressed: () async {
                if (isValid == true) {
                  BlocProvider.of<NotesBloc>(context).add(AddNoteEvent(
                      id: mongo_dart.ObjectId(),
                      title: title,
                      description: description,
                      createdTime: DateTime.now(), ),);
                }
              },
              child: const Text('Add'),
            ),
          ),
        ],
      );

  Widget buildBody({required BuildContext context}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 0,
            left: 12,
            right: 12,
          ),
          child: BlocListener<NotesBloc, NotesState>(
            listener: (context, state) {
             if(state is NoteCreatedSuccessfullyState){
               Navigator.push(
                   context,
                   MaterialPageRoute(
                       builder: (context) => const NotesScreen(),),);
             }
            },
            child: buildForm(),
          ),
        ),
      ),
    );
  }

  Widget buildForm() => Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitleTextField(),
            const SizedBox(height: 8),
            buildDescriptionTextField(),
            const SizedBox(height: 16),
          ],
        ),
      );

  Widget buildTitleTextField() => TextFormField(
        controller: titleTextFieldController,
        maxLines: 1,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (value) => validate(),
      );

  Widget buildDescriptionTextField() => TextFormField(
        controller: descriptionTextFieldController,
        maxLines: 5,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (value) => validate(),
      );
}
