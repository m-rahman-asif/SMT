import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:smt/providers/login_provider.dart";
import "package:smt/providers/APIrepository.dart";
import 'package:smt/screens/forgot_password_screen.dart';
import 'package:smt/screens/locations_screen.dart';
import 'package:smt/screens/signup_screen.dart';

class HomeScreen extends ConsumerWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account Settings")),
      body: Column(
        children: [
          // UPDATE BUTTON
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Update Password"),
            onTap: () async {
              await ref.read(authRepositoryProvider).updateAccount(userId, {
                "name": "Updated User",
                "data": {"password": "newPassword123", "email": "user@test.com"}
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Account Updated!")));
            },
          ),

          // DELETE BUTTON
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Delete Account",
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              await ref.read(authRepositoryProvider).deleteAccount(userId);
              Navigator.of(context).pushReplacementNamed('/login');
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Account Deleted!")));
            },
          ),
        ],
      ),
    );
  }
}
