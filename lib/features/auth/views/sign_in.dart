import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:task_manager/features/home/views/home.dart';
import '../../../core/utils/utils.dart';
import '../cubit/auth_cubit.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleSignIn(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (!RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(email)) {
      showSnackBar("Invalid email format.", context);
      return;
    }

    executeSafely(() {
      context.read<AuthCubit>().signIn(email, password);
    });
  }

  void navigateToSignUpPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
      create: (context) => AuthCubit(),
      child: const SignUp(),
    )));
  }

  void navigateToHome(BuildContext context){
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Home(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar("Sign in failed: ${state.error}", context);
            }
            if (state is AuthLoggedIn) {
              showSnackBar("Sign in Success", context);
              navigateToHome(context);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign In.",
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(hintText: "Email"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(hintText: "Password"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => handleSignIn(context),
                        child: const Text("SIGN IN", style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleMedium,
                          text: "Don't have an account? ",
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => navigateToSignUpPage(context),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              text: "Sign up",
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (state is AuthLoading) const CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
