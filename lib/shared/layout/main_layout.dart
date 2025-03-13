import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/authentication/presentation/cubit/auth_cubit.dart';
import '../../features/tracking/presentation/screens/tracking_screen.dart';
import 'app_drawer.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    // Simplified layout with just the TrackingScreen
    return const TrackingScreen();
  }
}