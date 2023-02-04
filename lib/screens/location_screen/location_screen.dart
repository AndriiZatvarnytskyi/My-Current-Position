import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_current_position/bloc/auth_bloc/auth_bloc.dart';
import 'package:my_current_position/screens/login_screen/login_screen.dart';
import 'package:my_current_position/screens/profile_screen/profile_screen.dart';

import 'widgets/google_map_widget.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MapView(),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const ProfileScreen())));
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 95,
                        color: Colors.black54,
                      ),
                      Text(
                        'My\nprofile'.toUpperCase(),
                        style: Theme.of(context).textTheme.headline4,
                      )
                    ],
                  ),
                )),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _signOut(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.exit_to_app,
                      size: 30,
                      color: Colors.red,
                    ),
                    Text(
                      'Exit'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontSize: 30),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
