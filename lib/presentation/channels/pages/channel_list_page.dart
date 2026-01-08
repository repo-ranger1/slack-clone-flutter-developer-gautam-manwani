import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slack_clone_gautam_manwani/core/constants/string_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/size_constants.dart';
import 'package:slack_clone_gautam_manwani/core/extensions/context_extensions.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_bloc.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_event.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_state.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/pages/login_page.dart';
import 'package:slack_clone_gautam_manwani/presentation/channels/bloc/channel_bloc.dart';
import 'package:slack_clone_gautam_manwani/presentation/channels/bloc/channel_event.dart';
import 'package:slack_clone_gautam_manwani/presentation/channels/bloc/channel_state.dart';
import 'package:slack_clone_gautam_manwani/presentation/channels/widgets/channel_tile.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/pages/chat_page.dart';
import 'package:slack_clone_gautam_manwani/presentation/theme/theme_cubit.dart';

/// Channel list page showing available channels
class ChannelListPage extends StatefulWidget {
  const ChannelListPage({super.key});

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  static const String defaultWorkspaceId = 'default-workspace';

  @override
  void initState() {
    super.initState();
    // Load channels
    context.read<ChannelBloc>().add(
      const ChannelLoadRequested(workspaceId: defaultWorkspaceId),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringC.logout),
        content: const Text(StringC.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(StringC.no),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.pop();
            },
            child: const Text(StringC.yes),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringC.channelListTitle),
        actions: [
          // Dark mode toggle
          BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDark) {
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                tooltip: StringC.darkMode,
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: StringC.logout,
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.pushAndRemoveUntil(const LoginPage());
          }
        },
        child: BlocBuilder<ChannelBloc, ChannelState>(
          builder: (context, state) {
            if (state is ChannelLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ChannelError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(StringC.error, style: context.textTheme.titleLarge),
                    const SizedBox(height: SizeC.paddingM),
                    Text(state.message),
                    const SizedBox(height: SizeC.paddingM),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ChannelBloc>().add(
                          const ChannelLoadRequested(
                            workspaceId: defaultWorkspaceId,
                          ),
                        );
                      },
                      child: const Text(StringC.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is ChannelLoaded) {
              final channels = state.channels;

              // Subscribe to unread count changes when channels are loaded
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                // Trigger subscription for unread counts
                Future.microtask(() {
                  if (!context.mounted) return;
                  context.read<ChannelBloc>().add(
                    ChannelUnreadCountsSubscribed(
                      workspaceId: defaultWorkspaceId,
                      userId: authState.user.id,
                    ),
                  );
                });
              }

              if (channels.isEmpty) {
                return const Center(child: Text(StringC.noChannelsPlaceholder));
              }

              return ListView.builder(
                itemCount: channels.length,
                padding: const EdgeInsets.symmetric(vertical: SizeC.paddingS),
                itemBuilder: (context, index) {
                  final channel = channels[index];

                  return ChannelTile(
                    channel: channel,
                    onTap: () {
                      // Mark channel as selected
                      context.read<ChannelBloc>().add(
                        ChannelSelected(channelId: channel.id),
                      );

                      // Navigate to chat page
                      context.push(
                        ChatPage(
                          workspaceId: defaultWorkspaceId,
                          channel: channel,
                        ),
                      );
                    },
                  );
                },
              );
            }

            return const Center(child: Text(StringC.loading));
          },
        ),
      ),
    );
  }
}
