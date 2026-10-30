import 'package:dio/dio.dart';

import '../model/address_model.dart';
import '../repositories/address_local_repository.dart';
import '../repositories/via_cep_repository.dart';
import 'address_exception.dart';

class AddressService {
  AddressService(this._apiRepository, this._localRepository);

  static const cepLength = 8;
  static const stateLength = 2;
  static const minSearchLength = 3;

  final ViaCepRepository _apiRepository;
  final AddressLocalRepository _localRepository;

  Future<AddressModel?> searchByCep(String rawCep) async {
    final cep = rawCep.replaceAll(RegExp(r'\D'), '');
    if (cep.length != cepLength) {
      throw const AddressException('Informe um CEP com 8 números.');
    }

    final cached = _localRepository.findByCep(cep);
    if (cached != null) {
      return register(cached);
    }

    final address = await _request(() => _apiRepository.findByCep(cep));
    if (address == null) {
      return null;
    }
    return register(address);
  }

  Future<List<AddressModel>> searchByAddress({
    required String state,
    required String city,
    required String street,
  }) {
    final uf = state.trim().toUpperCase();
    final cityName = city.trim();
    final streetName = street.trim();

    if (!RegExp(r'^[A-Z]{2}$').hasMatch(uf)) {
      throw const AddressException(
        'Informe a UF com 2 letras, por exemplo SC.',
      );
    }
    if (cityName.length < minSearchLength) {
      throw const AddressException('A cidade precisa ter pelo menos 3 letras.');
    }
    if (streetName.length < minSearchLength) {
      throw const AddressException(
        'O logradouro precisa ter pelo menos 3 letras.',
      );
    }

    return _request(
      () => _apiRepository.findByAddress(
        state: uf,
        city: cityName,
        street: streetName,
      ),
    );
  }

  Future<AddressModel> register(AddressModel address) async {
    final consulted = address.copyWith(consultedAt: DateTime.now());
    await _localRepository.save(consulted);
    return consulted;
  }

  AddressModel? lastConsulted() => _localRepository.findLast();

  Future<T> _request<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioError catch (error) {
      if (error.response?.statusCode == 400) {
        throw const AddressException('Dados inválidos para a consulta.');
      }
      throw const AddressException(
        'Não foi possível acessar o ViaCEP. Verifique sua conexão.',
      );
    }
  }
}
