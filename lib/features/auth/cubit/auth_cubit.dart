import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/custom_exception/network_exception.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/features/auth/repository/auth_remote_repository.dart';
import '../../../core/custom_exception/status_code_exception.dart';
import '../../../core/utils/sp_helper.dart';
import '../repository/auth_local_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState>{
  AuthCubit():super(AuthInitial());
  final SpHelper spHelper = SpHelper();
  final AuthRemoteRepository authRemoteRepository = AuthRemoteRepositoryImpl();
  final AuthLocalRepository authLocalRepository = AuthLocalRepositoryImpl();

  void signUp(String name, String email, String password)async{
    try{
      emit(AuthLoading());
      final response = await authRemoteRepository.signUp(name, email, password);
      if(response!=null){
        emit(AuthSuccess());
      }
    }on StatusCodeException catch(e){
      emit(AuthFailure(e.message));
    } catch(e){
      emit(AuthFailure(e.toString()));
    }
  }

  void signIn(String email, String password)async{
    try{
      emit(AuthLoading());
      final response = await authRemoteRepository.login(email, password);
      if(response!=null){
        spHelper.setToken(response.token);
        await authLocalRepository.insertUser(response);
        emit(AuthLoggedIn(response));
      }else{
        emit(AuthFailure("Some Error Occurred"));
      }

    }on StatusCodeException catch(e){
      emit(AuthFailure(e.message));
    } catch(e){
      emit(AuthFailure(e.toString()));
    }
  }

  void tokenIsValid()async{
    try {
      emit(AuthLoading());
      final token = await spHelper.getToken();
      if(token==null){
        emit(AuthFailure("Token is null"));
        return;
      }
      final response = await authRemoteRepository.tokenIsValid(token);
      if(response!=null){
        emit(AuthLoggedIn(response));
      }
    }on NetworkException catch(e){
      final user = await authLocalRepository.getUser();
      if(user!=null){
        emit(AuthLoggedIn(user));
      }else{
        emit(AuthFailure("Failed to load offline data"));
      }
    }on StatusCodeException catch(e){
      emit(AuthFailure(e.message));
    }catch(e){
      emit(AuthFailure(e.toString()));
    }
  }
}