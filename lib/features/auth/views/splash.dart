import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/views/welcome.dart';
import '../../../core/utils/utils.dart';
import '../../home/views/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2),() {
      context.read<AuthCubit>().tokenIsValid();
    });
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthLoggedIn) {
      _navigateTo(context, const Home());
    } else if (state is AuthFailure) {
      debugPrint(state.error); // Use debugPrint instead of print
      _navigateTo(context, const Welcome());
    }
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: _handleAuthState, // Cleaner listener function
        builder: (context, state) => const SplashInitialScreen(),
      ),
    );
  }
}

class SplashInitialScreen extends StatelessWidget {
  const SplashInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/img1.jpg"),
          const SizedBox(height: 16),
          centerLoader(),
          const SizedBox(height: 16),
          const Text("Loading..."),
        ],
      ),
    );
  }
}
