import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart';
import 'core/network/dio_client.dart';
import 'data/datasource/auth_remote_datasource.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_state.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioClient.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository(AuthRemoteDatasource())),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MenteCart',
        theme: AppTheme.theme,
        home: const _AuthGate(),
      ),
    );
  }
}

/// Auth gate: shows login/register flow until authenticated, then HomeScreen.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  bool _showRegister = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Replace entire stack with HomeScreen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (_) => false,
          );
        }
      },
      child: _showRegister
          ? RegisterScreen(
              onGoToLogin: () => setState(() => _showRegister = false),
              onRegisterSuccess: () {
                // After register, dispatch login automatically or go to login
                setState(() => _showRegister = false);
              },
            )
          : LoginScreen(
              onGoToRegister: () => setState(() => _showRegister = true),
              onLoginSuccess: () {
                // handled by BlocListener above
              },
            ),
    );
  }
}
