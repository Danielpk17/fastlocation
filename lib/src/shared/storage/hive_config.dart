import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../modules/home/model/address_model.dart';

class HiveConfig {
  HiveConfig._();

  static const storageFolder = 'fastlocation';
  static const addressBox = 'address_history';

  static Future<void> init() async {
    final documents = await getApplicationDocumentsDirectory();
    Hive.init(p.join(documents.path, storageFolder));
    Hive.registerAdapter(AddressModelAdapter());
    await Hive.openBox<AddressModel>(addressBox);
  }
}
