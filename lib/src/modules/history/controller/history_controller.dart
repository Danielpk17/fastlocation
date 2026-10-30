import 'package:mobx/mobx.dart';

import '../../home/model/address_model.dart';
import '../../home/repositories/address_local_repository.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryControllerBase with _$HistoryController;

abstract class _HistoryControllerBase with Store {
  _HistoryControllerBase(this._localRepository);

  final AddressLocalRepository _localRepository;

  @observable
  ObservableList<AddressModel> addresses = ObservableList<AddressModel>();

  @computed
  bool get isEmpty => addresses.isEmpty;

  @action
  void load() {
    addresses = ObservableList.of(_localRepository.findAll());
  }

  @action
  Future<void> clear() async {
    await _localRepository.clear();
    addresses.clear();
  }
}
