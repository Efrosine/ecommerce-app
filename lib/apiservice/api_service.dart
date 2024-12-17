import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ecommerce/model/bank_user_model.dart';
import 'package:ecommerce/model/order_model.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://ecoapi.efrosine.my.id/api',
    headers: {'Accept': 'application/json'},
  ));
  final SharedPreferencesAsync pref = SharedPreferencesAsync();

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio
          .post('/login', data: {"email": email, "password": password});
      String token = response.data['token'];
      await pref.setString('token', token);
      return 'Login Berhasil';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<String> register(String name, String email, String password,
      String confirmPassowrd) async {
    try {
      final response = await _dio.post('/register', data: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassowrd
      });
      return response.data['message'] ?? 'Berhasil';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<String> logout() async {
    try {
      String? token = await pref.getString('token');
      final response = await _dio.post('/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      await pref.remove('token');
      await pref.remove('bankToken');
      return response.data['message'] ?? 'Berhasil';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<UserModel> getUserAccount() async {
    try {
      String? token = await pref.getString('token');
      final response = await _dio.get('/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      var data = response.data as List<dynamic>;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      String? token = await pref.getString('token');
      final response = await _dio.get('/user/orders',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      var data = response.data as List<dynamic>;
      return data.map((e) => OrderModel.fromJson(e)).toList();
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<String> postOrders(List<ProductModel> products) async {
    try {
      String? token = await pref.getString('token');
      List<Map<String, dynamic>> data = [];
      products.forEach((e) {
        if (e.quantity != null) data.add(e.toJson());
      });
      var mapProducts = {
        'products': data
      };
      log(mapProducts.toString(), name: 'mapProducts');
      final response = await _dio.post('/orders',
          data: mapProducts,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      return response.data['message'] ?? 'Berhasil';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<String> requestBind(String email, String password) async {
    try {
      String? token = await pref.getString('token');
      final response = await _dio.post('/user/request-bind',
          data: {"email": email, "password": password},
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      String? bankToken = response.data['token'];
      await pref.setString('bankToken', bankToken ?? '');
      return 'Berhasil Bind Acount';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<String> requestPayment(int orderId) async {
    try {
      String? token = await pref.getString('token');
      String? bankToken = await pref.getString('bankToken');
      final response = await _dio.post('/user/request-payment',
          data: {"order_id": orderId},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'BankToken': bankToken,
            },
          ));
      return response.data['message'] ?? 'Berhasil';
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }

  Future<BankUserModel> requestBankAccount() async {
    try {
      String? token = await pref.getString('token');
      String? bankToken = await pref.getString('bankToken');
      final response = await _dio.get('/user/request-bankaccount',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'BankToken': bankToken,
            },
          ));
      return BankUserModel.fromJson(response.data);
    } on DioException catch (e) {
      return Future.error(
          Exception(e.response?.data['message'] ?? 'message error null'));
    } catch (e) {
      return Future.error(Exception('Something when wrong $e'));
    }
  }
}
