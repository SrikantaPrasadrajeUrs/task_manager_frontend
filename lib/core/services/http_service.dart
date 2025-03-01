import 'dart:convert';
import 'dart:developer';
import 'package:task_manager/core/constants/config.dart';
import 'package:task_manager/core/constants/endpoints.dart';
import 'package:task_manager/core/custom_exception/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/network/connection_checker.dart';
import 'package:task_manager/core/utils/sp_helper.dart';

import '../custom_exception/network_exception.dart';


class HTTPService {
  static final ConnectionChecker _connectionChecker = ConnectionCheckImpl();
   static String xAuthToken = "x-auth-token";
  static const Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  static Future<dynamic> get(String endPoint, {int? statusCode,Map<String,String>? extraHeaders,bool wantException = false,String? refreshKey}) async {
    return await _sendRequest(null, null, http.get, endPoint, null, statusCode,wantException: wantException,refreshKey: refreshKey);
  }

  static Future<dynamic> post(String endPoint, Map<String, dynamic>? data,
      {int? statusCode,
        bool wantErrorData = false,
        bool wantException = false,
        bool wantLogs = false,
        bool printData = false,
        bool sendHeaders = true}) async {
    return await _sendRequest(null, http.post, null, endPoint, data, statusCode,
        wantErrorData: wantErrorData,
        wantException: wantException,
        wantLogs: wantLogs,
        printData: printData,
        sendHeaders: sendHeaders);
  }

  static Future<dynamic> put(String endPoint, Map<String, dynamic>? data,
      {int? statusCode, bool wantException = false}) async {
    return await _sendRequest(null, http.put, null, endPoint, data, statusCode,
        wantException: wantException);
  }

  static Future<dynamic> delete(String endPoint,
      {int? statusCode, bool wantErrorData = false, bool wantException = false}) async {
    return await _sendRequest(
        http.delete, null, null, endPoint, null, statusCode,
        wantErrorData: wantErrorData,wantException: wantException);
  }

  static Future<dynamic> _sendRequest(
      Future<http.Response> Function(Uri url,
          {Map<String, String>? headers, Object? body})?
      delete,
      Future<http.Response> Function(Uri url,
          {Map<String, String>? headers, Object? body})?
      putOrPost,
      Future<http.Response> Function(Uri url, {Map<String, String>? headers})?
      get,
      String endPoint,
      Map<String, dynamic>? data,
      int? statusCode,
      {bool wantErrorData = false,
        bool wantException = false,
        bool wantLogs = false,
        bool printData = false,
        String? refreshKey,
        bool sendHeaders = true,Map<String,String>? extraHeaders}) async {
    try {
      if(!(await _connectionChecker.isConnected)){
        throw NetworkException("No internet connection");
      }
      bool isHeaderNotEmpty = extraHeaders!=null&&extraHeaders.isNotEmpty;

      String? token = refreshKey??accessToken;
      // Default status code to 200 if null
      if (putOrPost != null && get != null && delete != null) {
        throw Exception("Please pass either put or post or get method");
      }
      statusCode ??= 200;
      final http.Response? response;
      if (putOrPost != null) {
        response = await putOrPost(
          Uri.parse(endPoint),
          body: jsonEncode(data),
          headers: {
            ...headers,
            xAuthToken: token,
          },
        );
      } else if (get != null) {
        response = await get.call(
          Uri.parse(endPoint),
          headers: {
            ...headers,
            ...(isHeaderNotEmpty?extraHeaders:<String,String>{}),
            xAuthToken: token,
          },
        );
      } else {
        response = await delete?.call(
          Uri.parse(endPoint),
          headers: {
            ...headers,
            xAuthToken: token,
          },
        );
      }
      if(printData) log("${response?.body}, endpoint: ${Uri.parse(endPoint)}");
      if (response == null) throw NoMethodException();
      if (response.statusCode == statusCode) {
        return jsonDecode(response.body);
      } else if(response.statusCode==403){
        print("refreshing token");
        await verifyTokenAndExecuteCurrentTask();
        return _sendRequest(delete,putOrPost,get,endPoint,data,statusCode,
            wantErrorData: wantErrorData, wantException: wantException, wantLogs: wantLogs, printData: printData, sendHeaders: sendHeaders, extraHeaders: extraHeaders);
        // here execute current send request again if no excetion is sthrown
      }else {
        if (wantErrorData) {
          return jsonDecode(response.body);
        } else {
          throw StatusCodeException(
              statusCode: response.statusCode,
              message: jsonDecode(response.body)?['message'] ??
                  response.reasonPhrase ??
                  "Unknown error occurred");
        }
      }
    } catch (e, stackTrace) {
      if (wantLogs) log("Error while calling $endPoint", error: e, stackTrace: stackTrace);
      if (wantException) {
        rethrow;
      } else {
        return null;
      }
    }
  }

  static Future<void> verifyTokenAndExecuteCurrentTask()async{
    final spHelper = SpHelper();
      final refreshKey = await spHelper.getToken()??"";
      final response = await http.get(Uri.parse("$domain${Endpoints.tokenIsValid}"),headers: {
        "x-auth-token": refreshKey,
        "Content-Type": "application/json",
      });
      if(response.statusCode==498){
        throw StatusCodeException(statusCode: 498, message: "Session Expired");
      }else if(response.statusCode==200){
        final data  = jsonDecode(response.body);
        if(data is Map&& data.containsKey("userData")){
          accessToken = data['userData']['accessToken'].toString();
        }
      }else{
        if(jsonDecode(response.body)['message'].toString().contains("jwt expired")){
          throw StatusCodeException(statusCode: 498, message: "jwt expired");
        }
      }
  }
}