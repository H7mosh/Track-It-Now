
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/config/theme.dart';
import '../../features/authentication/presentation/cubit/auth_cubit.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current user from AuthCubit
    final authState = context.read<AuthCubit>().state;
    String userName = '';

    if (authState is AuthAuthenticated) {
      userName = authState.user.nameUser;
    }

    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          // User info section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                const Text(
                  'بەخێربێیت',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  title: 'نەخشەی شوێن',
                  icon: Icons.map,
                  isSelected: true,
                  onTap: () {
                    // Already on tracking screen
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  context,
                  title: 'ڕێکخستنەکان',
                  icon: Icons.settings,
                  onTap: () {
                    // Will implement settings functionality
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // Logout button
          Container(
            padding: const EdgeInsets.all(16),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'دەرچوون',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthCubit>().signOut();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required String title,
        required IconData icon,
        bool isSelected = false,
        required VoidCallback onTap,
      }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryColor : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}