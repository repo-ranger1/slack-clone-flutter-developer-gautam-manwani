import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slack_clone_gautam_manwani/core/constants/string_constants.dart';
import 'package:slack_clone_gautam_manwani/core/constants/size_constants.dart';
import 'package:slack_clone_gautam_manwani/core/extensions/context_extensions.dart';
import 'package:slack_clone_gautam_manwani/core/extensions/string_extensions.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_bloc.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_event.dart';
import 'package:slack_clone_gautam_manwani/presentation/auth/bloc/auth_state.dart';
import 'package:slack_clone_gautam_manwani/presentation/channels/pages/channel_list_page.dart';

/// Login page for user authentication
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _pwdFocus = FocusNode();
  bool _showPwd = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _pwdFocus.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailCtrl.text.trim(),
              password: _pwdCtrl.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to channel list
            context.pushAndRemoveUntil(const ChannelListPage());
          } else if (state is AuthError) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(SizeC.paddingL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Logo/Title
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80,
                        color: context.colorScheme.primary,
                      ),
                      const SizedBox(height: SizeC.paddingM),
                      Text(
                        StringC.appName,
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: SizeC.paddingXL),

                      // Email field
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: StringC.email,
                          hintText: StringC.emailHint,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isBlank) {
                            return StringC.emailValidation;
                          }
                          if (!value.isValidEmail) {
                            return StringC.emailValidation;
                          }
                          return null;
                        },
                        enabled: !isLoading,
                        onFieldSubmitted: (_) => _pwdFocus.requestFocus(),
                      ),
                      const SizedBox(height: SizeC.paddingM),

                      // Password field
                      TextFormField(
                        controller: _pwdCtrl,
                        focusNode: _pwdFocus,
                        obscureText: !_showPwd,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: StringC.password,
                          hintText: StringC.passwordHint,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPwd
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPwd = !_showPwd;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return StringC.passwordValidation;
                          }
                          return null;
                        },
                        enabled: !isLoading,
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                      const SizedBox(height: SizeC.paddingXL),

                      // Login button
                      ElevatedButton(
                        onPressed: isLoading ? null : _handleLogin,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(StringC.continueTxt),
                      ),
                      const SizedBox(height: SizeC.paddingM),

                      // Helper text
                      Text(
                        'Demo: Use any email/password to create an account',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withAlpha(153),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
