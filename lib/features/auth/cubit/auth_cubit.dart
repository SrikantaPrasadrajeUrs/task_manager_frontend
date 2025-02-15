import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/repository/auth_remote_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState>{
  AuthCubit():super(AuthInitial());
  final authRepository = AuthRemoteRepositoryImpl();

  void signUp(String name, String email, String password)async{
    try{
      emit(AuthLoading());
      final response = await authRepository.signUp(name, email, password);
      if(response!=null){
        emit(AuthSignUp());
      }else{
        emit(AuthFailure());
      }
    }catch(e){
      print(e);
      emit(AuthFailure());
    }
  }
}