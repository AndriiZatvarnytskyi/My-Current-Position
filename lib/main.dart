import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_current_position/bloc/auth_bloc/auth_bloc.dart';
import 'package:my_current_position/bloc/geolocation/geolocation_bloc.dart';
import 'package:my_current_position/data/geolocation/geolocation_repository.dart';
import 'package:my_current_position/data/repositories/auth_repository.dart';
import 'package:my_current_position/screens/location_screen/location_screen.dart';
import 'package:my_current_position/screens/login_screen/login_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<GeolocationRepository>(
            create: (_) => GeolocationRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AuthBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider(
              create: (context) => GeolocationBloc(
                  geolocationRepository: context.read<GeolocationRepository>())
                ..add(LoadGeolocation())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const LocationScreen();
                }
                return const SignIn();
              }),
        ),
      ),
    );
  }
}
