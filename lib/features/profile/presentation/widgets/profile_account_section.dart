import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/features/auth/presentation/controllers/auth_controller.dart';
import 'package:lokito/i18n/strings.g.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileAccountSection extends ConsumerWidget {
  const ProfileAccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.profile.account,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Edit Profile Card
        Card(
          child: ListTile(
            leading: Icon(
              LucideIcons.userCog,
              color: theme.colorScheme.primary,
            ),
            title: Text(t.profile.editProfile),
            subtitle: Text(t.profile.updateInfo),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {
              // TODO: Implement edit profile
            },
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Privacy Card
        Card(
          child: ListTile(
            leading: Icon(
              LucideIcons.shield,
              color: theme.colorScheme.primary,
            ),
            title: Text(t.profile.privacy),
            subtitle: Text(t.profile.privacySettings),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {
              // TODO: Implement privacy settings
            },
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Help & Support Card
        Card(
          child: ListTile(
            leading: Icon(
              LucideIcons.messageCircle,
              color: theme.colorScheme.primary,
            ),
            title: const Text('Help & Support'),
            subtitle: const Text('Get help and contact support'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {
              // TODO: Implement help & support
            },
          ),
        ),
        
        const SizedBox(height: 8),
        
        // About Card
        Card(
          child: ListTile(
            leading: Icon(
              LucideIcons.info,
              color: theme.colorScheme.primary,
            ),
            title: const Text('About'),
            subtitle: const Text('App version and information'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () {
              // TODO: Implement about page
            },
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Logout Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _showLogoutDialog(context, ref);
            },
            icon: const Icon(LucideIcons.logOut),
            label: Text(t.profile.logout),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
  
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.profile.confirmLogout),
        content: Text(t.profile.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.common.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authControllerProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(t.profile.logout),
          ),
        ],
      ),
    );
  }
}