import 'package:dio/dio.dart';

import '../model/address_model.dart';

class ViaCepRepository {
  ViaCepRepository(this._dio);

  final Dio _dio;

  Future<AddressModel?> findByCep(String cep) async {
    final response = await _dio.get<Map<String, dynamic>>('/$cep/json/');
    final data = response.data;
    if (data == null || data.containsKey('erro')) {
      return null;
    }
    return AddressModel.fromViaCep(data);
  }

  Future<List<AddressModel>> findByAddress({
    required String state,
    required String city,
    required String street,
  }) async {
    final path = [state, city, street].map(Uri.encodeComponent).join('/');
    final response = await _dio.get<List<dynamic>>('/$path/json/');
    final data = response.data ?? const [];
    return data
        .cast<Map<String, dynamic>>()
        .map(AddressModel.fromViaCep)
        .toList();
  }
}
