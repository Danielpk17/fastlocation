import 'package:dio/dio.dart';
import 'package:fastlocation/src/modules/home/model/address_model.dart';
import 'package:fastlocation/src/modules/home/repositories/address_local_repository.dart';
import 'package:fastlocation/src/modules/home/repositories/via_cep_repository.dart';

AddressModel sampleAddress({
  String cep = '88010-000',
  String street = 'Rua Felipe Schmidt',
  DateTime? consultedAt,
}) {
  return AddressModel(
    cep: cep,
    street: street,
    complement: '',
    neighborhood: 'Centro',
    city: 'Florianópolis',
    state: 'SC',
    consultedAt: consultedAt ?? DateTime(2026, 10, 29, 10),
  );
}

class FakeViaCepRepository implements ViaCepRepository {
  FakeViaCepRepository({this.address, this.addresses = const [], this.error});

  final AddressModel? address;
  final List<AddressModel> addresses;
  final DioError? error;
  int calls = 0;

  @override
  Future<AddressModel?> findByCep(String cep) async {
    calls++;
    final failure = error;
    if (failure != null) {
      throw failure;
    }
    return address;
  }

  @override
  Future<List<AddressModel>> findByAddress({
    required String state,
    required String city,
    required String street,
  }) async {
    calls++;
    final failure = error;
    if (failure != null) {
      throw failure;
    }
    return addresses;
  }
}

class FakeAddressLocalRepository implements AddressLocalRepository {
  final Map<String, AddressModel> stored = {};

  @override
  AddressModel? findByCep(String cep) => stored[cep];

  @override
  List<AddressModel> findAll() {
    final addresses = stored.values.toList();
    addresses.sort((a, b) => b.consultedAt.compareTo(a.consultedAt));
    return addresses;
  }

  @override
  AddressModel? findLast() {
    final addresses = findAll();
    return addresses.isEmpty ? null : addresses.first;
  }

  @override
  Future<void> save(AddressModel address) async {
    stored[address.cepDigits] = address;
  }

  @override
  Future<void> clear() async => stored.clear();
}
