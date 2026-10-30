import 'package:mobx/mobx.dart';

import '../model/address_model.dart';
import '../service/address_exception.dart';
import '../service/address_service.dart';
import '../service/route_service.dart';

part 'home_controller.g.dart';

enum SearchMode { cep, address }

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  _HomeControllerBase(this._addressService, this._routeService);

  final AddressService _addressService;
  final RouteService _routeService;

  @observable
  SearchMode mode = SearchMode.cep;

  @observable
  bool isLoading = false;

  @observable
  bool isTracingRoute = false;

  @observable
  bool notFound = false;

  @observable
  String? errorMessage;

  @observable
  AddressModel? lastAddress;

  @observable
  ObservableList<AddressModel> results = ObservableList<AddressModel>();

  @computed
  bool get hasResults => results.isNotEmpty;

  @computed
  bool get canTraceRoute => lastAddress != null && !isTracingRoute;

  @action
  void loadLastAddress() {
    lastAddress = _addressService.lastConsulted();
  }

  @action
  void changeMode(SearchMode value) {
    mode = value;
    newSearch();
  }

  @action
  void newSearch() {
    results.clear();
    notFound = false;
    errorMessage = null;
  }

  @action
  Future<void> searchByCep(String cep) async {
    await _search(() async {
      final address = await _addressService.searchByCep(cep);
      if (address == null) {
        notFound = true;
        return;
      }
      lastAddress = address;
    });
  }

  @action
  Future<void> searchByAddress({
    required String state,
    required String city,
    required String street,
  }) async {
    await _search(() async {
      final addresses = await _addressService.searchByAddress(
        state: state,
        city: city,
        street: street,
      );
      if (addresses.isEmpty) {
        notFound = true;
        return;
      }
      results = ObservableList.of(addresses);
    });
  }

  @action
  Future<void> selectResult(AddressModel address) async {
    lastAddress = await _addressService.register(address);
    results.clear();
  }

  @action
  Future<void> traceRoute() async {
    final address = lastAddress;
    if (address == null) {
      return;
    }
    errorMessage = null;
    isTracingRoute = true;
    try {
      await _routeService.traceRouteTo(address);
    } on AddressException catch (error) {
      errorMessage = error.message;
    } finally {
      isTracingRoute = false;
    }
  }

  Future<void> _search(Future<void> Function() request) async {
    newSearch();
    isLoading = true;
    try {
      await request();
    } on AddressException catch (error) {
      errorMessage = error.message;
    } finally {
      isLoading = false;
    }
  }
}
