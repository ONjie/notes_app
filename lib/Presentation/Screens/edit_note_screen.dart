import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/Presentation/Screens/note_details_screen.dart';
import '../../BLoC/notes_bloc.dart';
import '../../Data/Models/note_model.dart';
import '../widgets/widgets.dart';
import 'notes_screen.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key, required this.note});
  final NoteModel note;
  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  late String title = widget.note.title;
  late String description = widget.note.description;


  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if(state.status == NotesStatus.updated){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotesScreen(),),);
        }
        if(state.status == NotesStatus.error){
          ScaffoldMessenger.of(context).showSnackBar(displaySnackBarWidget(
            message: state.message!,
            color: Colors.red,
          ),
          );
        }
      },
      child: Scaffold(
        appBar: buildAppBar(note: widget.note),
        body: buildBody(context: context),
      ),
    );
  }

  AppBar buildAppBar({required NoteModel note}) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailsScreen(noteId: widget.note.id!),
          ),
        ),
        icon: const Icon(
          Icons.arrow_back,
          color: CupertinoColors.white,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: title.isNotEmpty && description.isNotEmpty
                  ? Colors.teal
                  : Colors.black54,
            ),
            onPressed: () async {
              final isValid = _formKey.currentState!.validate();
              if (isValid) {
                BlocProvider.of<NotesBloc>(context).add(
                  UpdateNoteEvent(
                    note: NoteModel(
                      id: widget.note.id,
                      title: title,
                      description: description,
                      creationTime: DateTime.now(),
                    ),
                  ),
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const NotesScreen()),
                );
              }
            },
            child: const Text(
              'Update',
              style: TextStyle(
                  fontSize: 19,
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

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
            right: 12,
            left: 12,
            bottom: 0,
          ),
          child: buildForm(),
        ),
      ),
    );
  }

  Widget buildForm(){
    return Form(
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
  }

  Widget buildTitleTextField() {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
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
      validator: (title) {
        if (title != null && title.isEmpty) {
          return 'The title cannot be empty';
        }
        return null;
      },
      onChanged: (title) => setState(() => this.title = title),
    );
  }

  Widget buildDescriptionTextField() {
   return  TextFormField(
      maxLines: 5,
      initialValue: description,
      style: const TextStyle(color: Colors.white60, fontSize: 18),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Type something...',
        hintStyle: TextStyle(color: Colors.white60),
      ),
      validator: (description) {
        if (description != null && description.isEmpty) {
          return 'The description cannot be empty';
        }
        return null;
      },
      onChanged: (description) =>
          setState(() => this.description = description),
    );
  }
}
