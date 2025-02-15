import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/utils/utils.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/views/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void handleSignUp(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (name.isEmpty) {
      showSnackBar("Name cannot be empty.",context);
      return;
    }

    final isValidPassword = validatePassWord(password);
    if (isValidPassword != null) {
      showSnackBar(isValidPassword,context);
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(email)) {
      showSnackBar("Invalid email format.",context);
      return;
    }

    executeSafely((){
      context.read<AuthCubit>().signUp(name, email, password);
    });
  }

  void navigateToSignInPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal:16,),
        child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if(state is AuthFailure){
            showSnackBar("Sign up failed: ${state.error}", context);
          }
          if(state is AuthSuccess){
            showSnackBar("Sign up Success", context);
            navigateToSignInPage(context);
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
                      const Text("Sign Up.",style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold
                      ),),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: "Name"
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            hintText: "Email"
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                            hintText: "Password"
                        ),
                      ),
                      const SizedBox(height: 10,),
                     ElevatedButton(onPressed: ()=>handleSignUp(context), child: const Text("SIGN UP",style: TextStyle(color: Colors.white),)),
                      const SizedBox(height: 10,),
                      RichText(
                          text: TextSpan(
                        style: Theme.of(context).textTheme.titleMedium,
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()..onTap=()=>navigateToSignInPage(context),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            text: "Sign in"
                          )
                        ]
                      ))
                    ],
                  ),
                ),
                if(state is AuthLoading) const CircularProgressIndicator(),
              ],
            );
        },
      ),
      ),
    );
  }
}
