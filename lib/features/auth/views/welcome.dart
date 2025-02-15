import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constants/enums.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/views/sign_up.dart';
import 'package:task_manager/features/auth/views/sign_in.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});


  void navigateToSignUpPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BlocProvider(
      create: (context)=>AuthCubit(),
      child: const SignUp()
    )));
  }
  void navigateToSignInPage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BlocProvider(
        create: (context)=>AuthCubit(),
        child: const SignIn()
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:ConstantSizes.horizontalPadding),
        child: Column(
          children: [
            const Spacer(),
            Image.asset("assets/images/img1.jpg"),
            const Spacer(),
            ElevatedButton(onPressed: ()=>navigateToSignInPage(context), child: const Text("Sign In",style: TextStyle(color: Colors.white),)),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: ()=>navigateToSignUpPage(context), child: const Text("Sign Up",style: TextStyle(color: Colors.white),)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
