import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartwatch_companion/authentication/blocs/auth_status_bloc.dart';
import 'package:smartwatch_companion/authentication/models/watch_user.dart';
import 'package:smartwatch_companion/settings/cubits/app_preference_cubit.dart';
import 'package:smartwatch_companion/settings/cubits/user_account_settings_cubit.dart';
import 'package:smartwatch_companion/settings/cubits/watch_connection_cubit.dart';

class SettingsPage extends StatelessWidget {
  static String get path => "/settings";
  static String get name => "settings";
  static GoRoute get route => GoRoute(
        path: path,
        name: name,
        builder: (_, __) => SettingsPage(),
      );

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(height: 20.0),
              Center(
                child: BlocBuilder<UserAccountSettingsCubit, WatchUser>(
                  builder: (context, state) {
                    if (state.photo != null && state.photo!.isNotEmpty) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(state.photo!),
                      );
                    } else {
                      return const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                      );
                    }
                    // return Column(
                    // children: [
                    // const SizedBox(height: 16),
                    // Text(
                    //   state.name ?? '',
                    //   style: const TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.teal,
                    //   ),
                    // ),
                    // Text(
                    //   state.email ?? '',
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    //   ],
                    // );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Smartwatch Connection Section
              ListTile(
                leading: const Icon(Icons.watch, color: Colors.teal),
                title: const Text('Smartwatch Connection'),
                subtitle:
                    BlocBuilder<WatchConnectionCubit, WatchConnectionState>(
                  builder: (context, state) {
                    String subtitle = switch (state) {
                      WatchConnectionState.connected => 'Connected!',
                      WatchConnectionState.disconnected => 'Disconnected.',
                      WatchConnectionState.loading => 'Loading...',
                      _ => 'Unknown',
                    };
                    return Text(subtitle);
                  },
                ),
                trailing:
                    BlocBuilder<WatchConnectionCubit, WatchConnectionState>(
                  builder: (context, state) {
                    // if (state != WatchConnectionState.unknown) {
                    return Switch(
                      value: state == WatchConnectionState.connected,
                      onChanged: (isConnected) {
                        if (isConnected) {
                          context.read<WatchConnectionCubit>().connect();
                        } else {
                          context.read<WatchConnectionCubit>().disconnect();
                        }
                      },
                    );
                    // }
                    // return const SizedBox.shrink();
                  },
                ),
              ),
              const Divider(),
              // Account Information Section
              const ListTile(
                title: Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.teal),
                title: const Text('Name'),
                subtitle: BlocBuilder<UserAccountSettingsCubit, WatchUser>(
                  builder: (context, state) {
                    return Text(state.name ?? '');
                  },
                ),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  _showEditDialog(context, 'Edit Name', 'Name', (value) {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.teal),
                title: const Text('Email'),
                subtitle: BlocBuilder<UserAccountSettingsCubit, WatchUser>(
                  builder: (context, state) {
                    return Text(state.email ?? '');
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.teal),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showEditDialog(
                      context, 'Change Password', 'New Password', (value) {});
                },
              ),
              const Divider(),
              // App Preferences Section
              const ListTile(
                title: Text(
                  'App Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.teal),
                title: const Text('Notifications'),
                trailing: BlocBuilder<AppPreferenceCubit, AppPreferenceState>(
                  builder: (context, state) => Switch(
                    value: state.notificationsEnabled,
                    onChanged: (isEnabled) {
                      context
                          .read<AppPreferenceCubit>()
                          .toggleNotifications(isEnabled);
                    },
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode, color: Colors.teal),
                title: const Text('Dark Mode'),
                trailing: BlocBuilder<AppPreferenceCubit, AppPreferenceState>(
                  builder: (context, state) => Switch(
                    value: state.darkModeEnabled,
                    onChanged: (isEnabled) {
                      context
                          .read<AppPreferenceCubit>()
                          .toggleDarkMode(isEnabled);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () =>
                    context.read<AuthStatusBloc>().add(LogoutEvent()),
                child: Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 16.0,
                    // decoration: TextDecoration.underline,
                    // decorationColor: Colors.teal[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String title, String hint,
      Function(String) onSubmit) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSubmit(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
