import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';

import '../model/address_model.dart';
import 'address_exception.dart';

class RouteService {
  Future<void> traceRouteTo(AddressModel address) async {
    final destination = await _locate(address);

    final maps = await MapLauncher.installedMaps;
    if (maps.isEmpty) {
      throw const AddressException(
        'Nenhum aplicativo de mapas foi encontrado no aparelho.',
      );
    }

    final map = maps.firstWhere(
      (available) => available.mapType == MapType.google,
      orElse: () => maps.first,
    );
    await map.showDirections(
      destination: destination,
      destinationTitle: address.fullAddress,
    );
  }

  Future<Coords> _locate(AddressModel address) async {
    List<Location> locations;
    try {
      locations = await locationFromAddress('${address.fullAddress}, Brasil');
    } on Exception {
      locations = const [];
    }

    if (locations.isEmpty) {
      throw const AddressException(
        'Não foi possível localizar esse endereço no mapa.',
      );
    }
    return Coords(locations.first.latitude, locations.first.longitude);
  }
}
