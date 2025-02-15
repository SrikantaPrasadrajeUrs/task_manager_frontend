
import 'package:task_manager/core/constants/config.dart';
import 'package:task_manager/core/constants/endpoints.dart';
import 'package:task_manager/core/services/http_service.dart';

abstract class AuthRemoteRepository{
  Future<void> signUp(String userName,String email,String password);
  Future<void> login(String email, String password);
}

class AuthRemoteRepositoryImpl implements AuthRemoteRepository{
    @override
  Future<dynamic> signUp(String name, String email, String password) async{
    return await HTTPService.post("$domain${Endpoints.signUp}", {
      "name":name,
      "email":email,
      "password":password
    }, statusCode: 201);
  }

  @override
  Future<void> login(String email, String password) async{
      
  }
}