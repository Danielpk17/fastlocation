import 'package:hive/hive.dart';

import '../../../shared/storage/hive_config.dart';
import '../model/address_model.dart';

class AddressLocalRepository {
  Box<AddressModel> get _box => Hive.box<AddressModel>(HiveConfig.addressBox);

  AddressModel? findByCep(String cep) => _box.get(cep);

  List<AddressModel> findAll() {
    final addresses = _box.values.toList();
    addresses.sort((a, b) => b.consultedAt.compareTo(a.consultedAt));
    return addresses;
  }

  AddressModel? findLast() {
    final addresses = findAll();
    return addresses.isEmpty ? null : addresses.first;
  }

  Future<void> save(AddressModel address) {
    return _box.put(address.cepDigits, address);
  }

  Future<void> clear() => _box.clear();
}
