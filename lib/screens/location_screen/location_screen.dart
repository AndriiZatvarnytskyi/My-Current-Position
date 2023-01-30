import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_current_position/bloc/auth_bloc/auth_bloc.dart';
import 'package:my_current_position/screens/login_screen/login_screen.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              _signOut(context);
            },
            icon: const Icon(Icons.exit_to_app_outlined)),
      ),
      body: Container(color: Colors.green),
    );
  }

  void _signOut(context) {
    BlocProvider.of<AuthBloc>(context).add(
      SignOutRequested(),
    );
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }
}
