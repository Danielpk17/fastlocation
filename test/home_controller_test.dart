import 'package:fastlocation/src/modules/home/controller/home_controller.dart';
import 'package:fastlocation/src/modules/home/service/address_service.dart';
import 'package:fastlocation/src/modules/home/service/route_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  late FakeAddressLocalRepository local;

  setUp(() => local = FakeAddressLocalRepository());

  HomeController buildController(FakeViaCepRepository api) {
    return HomeController(AddressService(api, local), RouteService());
  }

  test('CEP encontrado vira o último endereço consultado', () async {
    final controller = buildController(
      FakeViaCepRepository(address: sampleAddress()),
    );

    await controller.searchByCep('88010000');

    expect(controller.lastAddress?.cep, '88010-000');
    expect(controller.isLoading, isFalse);
    expect(controller.notFound, isFalse);
  });

  test('CEP inexistente marca a busca como vazia', () async {
    final controller = buildController(FakeViaCepRepository());

    await controller.searchByCep('99999999');

    expect(controller.notFound, isTrue);
    expect(controller.lastAddress, isNull);
  });

  test('erro de validação chega na tela pela errorMessage', () async {
    final controller = buildController(FakeViaCepRepository());

    await controller.searchByCep('123');

    expect(controller.errorMessage, 'Informe um CEP com 8 números.');
    expect(controller.isLoading, isFalse);
  });

  test(
    'escolher um resultado da busca por endereço salva no histórico',
    () async {
      final controller = buildController(
        FakeViaCepRepository(addresses: [sampleAddress()]),
      );

      await controller.searchByAddress(
        state: 'SC',
        city: 'Florianópolis',
        street: 'Felipe',
      );
      expect(controller.results, hasLength(1));

      await controller.selectResult(controller.results.first);

      expect(controller.results, isEmpty);
      expect(controller.lastAddress?.street, 'Rua Felipe Schmidt');
      expect(local.stored.keys, ['88010000']);
    },
  );

  test('nova consulta limpa resultado e erro', () async {
    final controller = buildController(FakeViaCepRepository());
    await controller.searchByCep('99999999');

    controller.newSearch();

    expect(controller.notFound, isFalse);
    expect(controller.errorMessage, isNull);
  });
}
