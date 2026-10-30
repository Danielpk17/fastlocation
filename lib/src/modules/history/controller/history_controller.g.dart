// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HistoryController on _HistoryControllerBase, Store {
  Computed<bool>? _$isEmptyComputed;

  @override
  bool get isEmpty => (_$isEmptyComputed ??= Computed<bool>(
    () => super.isEmpty,
    name: '_HistoryControllerBase.isEmpty',
  )).value;

  late final _$addressesAtom = Atom(
    name: '_HistoryControllerBase.addresses',
    context: context,
  );

  @override
  ObservableList<AddressModel> get addresses {
    _$addressesAtom.reportRead();
    return super.addresses;
  }

  @override
  set addresses(ObservableList<AddressModel> value) {
    _$addressesAtom.reportWrite(value, super.addresses, () {
      super.addresses = value;
    });
  }

  late final _$clearAsyncAction = AsyncAction(
    '_HistoryControllerBase.clear',
    context: context,
  );

  @override
  Future<void> clear() {
    return _$clearAsyncAction.run(() => super.clear());
  }

  late final _$_HistoryControllerBaseActionController = ActionController(
    name: '_HistoryControllerBase',
    context: context,
  );

  @override
  void load() {
    final _$actionInfo = _$_HistoryControllerBaseActionController.startAction(
      name: '_HistoryControllerBase.load',
    );
    try {
      return super.load();
    } finally {
      _$_HistoryControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
addresses: ${addresses},
isEmpty: ${isEmpty}
    ''';
  }
}
