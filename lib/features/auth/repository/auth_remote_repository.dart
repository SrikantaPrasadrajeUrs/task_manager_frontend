
import 'package:task_manager/core/constants/config.dart';
import 'package:task_manager/core/constants/endpoints.dart';
import 'package:task_manager/core/services/http_service.dart';
import 'package:task_manager/data/models/user_model.dart';

abstract class AuthRemoteRepository{
  Future<dynamic> signUp(String userName,String email,String password);
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> tokenIsValid(String token);
}

class AuthRemoteRepositoryImpl implements AuthRemoteRepository{
    @override
  Future<dynamic> signUp(String name, String email, String password) async{
    return await HTTPService.post("$domain${Endpoints.signUp}", {
      "name":name,
      "email":email,
      "password":password
    }, statusCode: 201,wantException: true);
  }

  @override
  Future<UserModel?> login(String email, String password) async{
    final response = await HTTPService.post("$domain${Endpoints.login}", {
      "email":email,
      "password":password
    },wantException: true);
    if(response is Map&&response['userData'] is Map){
      accessToken = response['userData']?['accessToken'] ?? '';
      return UserModel.fromMap(response['userData']);
    }
    return null;
  }

  @override
  Future<UserModel?> tokenIsValid(String refreshToken) async{
    final response = await HTTPService.get("$domain${Endpoints.tokenIsValid}",wantException: true,refreshKey: refreshToken);
    if(response is Map&&response['userData'] is Map){
      accessToken = response['userData']?['accessToken']??"";
      return UserModel.fromMap(response['userData']);
    }
    return null;
  }
}