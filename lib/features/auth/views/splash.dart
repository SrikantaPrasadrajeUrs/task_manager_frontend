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

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward().then((_){
        context.read<AuthCubit>().tokenIsValid();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthLoggedIn) {
      _navigateTo(context, const Home());
    } else if (state is AuthFailure) {
      debugPrint(state.error);
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
        listener: _handleAuthState,
        builder: (context, state) => SplashInitialScreen(scaleAnimation: _scaleAnimation),
      ),
    );
  }
}

class SplashInitialScreen extends StatelessWidget {
  final Animation<double> scaleAnimation;
  const SplashInitialScreen({super.key, required this.scaleAnimation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEFA), Color(0xFF4682B4)], // Sky blue gradient
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: scaleAnimation,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset("assets/images/ss.jpg", width: 300)),
            ),
            const SizedBox(height: 20),
            centerLoader(),
            const SizedBox(height: 16),
            const Text(
              "Loading...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
