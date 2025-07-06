import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/data/repositories/notes_repository.dart';
import 'package:notes_app/domain/entities/note.dart';

// Events
abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class FetchNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final String text;

  const AddNote(this.text);

  @override
  List<Object> get props => [text];
}

class UpdateNote extends NotesEvent {
  final String id;
  final String text;

  const UpdateNote(this.id, this.text);

  @override
  List<Object> get props => [id, text];
}

class DeleteNote extends NotesEvent {
  final String id;

  const DeleteNote(this.id);

  @override
  List<Object> get props => [id];
}

// States
abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object> get props => [message];
}

class NotesOperationSuccess extends NotesState {
  final String message;

  const NotesOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _notesRepository;

  NotesBloc({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(NotesInitial()) {
    
    on<FetchNotes>(_onFetchNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onFetchNotes(FetchNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await _notesRepository.fetchNotes();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    try {
      await _notesRepository.addNote(event.text);
      emit(const NotesOperationSuccess('Note added successfully'));
      add(FetchNotes());
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    try {
      await _notesRepository.updateNote(event.id, event.text);
      emit(const NotesOperationSuccess('Note updated successfully'));
      add(FetchNotes());
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    try {
      await _notesRepository.deleteNote(event.id);
      emit(const NotesOperationSuccess('Note deleted successfully'));
      add(FetchNotes());
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}
