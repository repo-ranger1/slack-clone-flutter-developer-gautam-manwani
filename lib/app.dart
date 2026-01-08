import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slack_clone_gautam_manwani/core/utils/app_injector.dart';
import 'package:slack_clone_gautam_manwani/core/utils/config/app_theme.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/auth_repository.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/channel_repository.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/message_repository.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_bloc.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_event.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_state.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/pages/login_page.dart';
import 'package:slack_clone_gautam_manwani/presentation/channels/bloc/channel_bloc.dart';
import 'package:slack_clone_gautam_manwani/presentation/channels/pages/channel_list_page.dart';
import 'package:slack_clone_gautam_manwani/presentation/chat/bloc/chat_bloc.dart';
import 'package:slack_clone_gautam_manwani/presentation/theme/theme_cubit.dart';

/// Root app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Theme Cubit
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),

        // Auth Bloc
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authRepository: AppInjector.get<AuthRepository>(),
          )..add(const AuthCheckRequested()),
        ),

        // Channel Bloc
        BlocProvider<ChannelBloc>(
          create: (_) => ChannelBloc(
            channelRepository: AppInjector.get<ChannelRepository>(),
          ),
        ),

        // Chat Bloc
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(
            messageRepository: AppInjector.get<MessageRepository>(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp(
            title: 'Slack Clone',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                // Show loading screen while checking auth status
                if (state is AuthInitial || state is AuthLoading) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Show channel list if authenticated
                if (state is AuthAuthenticated) {
                  return const ChannelListPage();
                }

                // Show login page if unauthenticated
                return const LoginPage();
              },
            ),
          );
        },
      ),
    );
  }
}
