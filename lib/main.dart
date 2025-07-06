import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/presentation/bloc/auth_bloc.dart';
import 'package:notes_app/presentation/bloc/notes_bloc.dart';
import 'package:notes_app/data/repositories/auth_repository.dart';
import 'package:notes_app/data/repositories/notes_repository.dart';
import 'package:notes_app/presentation/screens/auth_screen.dart';
import 'package:notes_app/presentation/screens/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => NotesRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => NotesBloc(
              notesRepository: context.read<NotesRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Notes App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const NotesScreen();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}