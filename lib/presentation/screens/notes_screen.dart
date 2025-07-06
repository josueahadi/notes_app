import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/presentation/bloc/auth_bloc.dart';
import 'package:notes_app/presentation/bloc/notes_bloc.dart';
import 'package:notes_app/presentation/widgets/note_item.dart';
import 'package:notes_app/presentation/widgets/note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(FetchNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOut());
            },
          ),
        ],
      ),
      body: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is NotesOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return const Center(
                child: Text(
                  'Nothing here yet—tap ➕ to add a note.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return NoteItem(
                  note: note,
                  onEdit: () => _showNoteDialog(context, note.id, note.text),
                  onDelete: () => _deleteNote(context, note.id),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Something went wrong. Please try again.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNoteDialog(BuildContext context, [String? noteId, String? initialText]) {
    showDialog(
      context: context,
      builder: (context) => NoteDialog(
        noteId: noteId,
        initialText: initialText,
        onSave: (text) {
          if (noteId != null) {
            context.read<NotesBloc>().add(UpdateNote(noteId, text));
          } else {
            context.read<NotesBloc>().add(AddNote(text));
          }
        },
      ),
    );
  }

  void _deleteNote(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NotesBloc>().add(DeleteNote(noteId));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}