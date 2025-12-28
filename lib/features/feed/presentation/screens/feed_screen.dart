import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lokito/core/constants/app_routes.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokito Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Visibility(
        visible: user != null,
        replacement: Center(child: CircularProgressIndicator()),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user?.avatarUrl != null)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user!.avatarUrl!),
                )
              else
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person_rounded, size: 40),
                ),
              const SizedBox(height: 16),
              Text(
                'Hello, ${user?.username ?? 'User'}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Your feed will appear here soon 📸'),
            ],
          ),
        ),
      ),
    );
  }
}
