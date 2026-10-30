import 'package:dio/dio.dart';
import 'package:fastlocation/src/modules/home/service/address_exception.dart';
import 'package:fastlocation/src/modules/home/service/address_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  late FakeAddressLocalRepository local;

  setUp(() => local = FakeAddressLocalRepository());

  group('busca por CEP', () {
    test('rejeita CEP com menos de 8 números sem chamar a API', () {
      final api = FakeViaCepRepository();
      final service = AddressService(api, local);

      expect(
        () => service.searchByCep('8801'),
        throwsA(isA<AddressException>()),
      );
      expect(api.calls, 0);
    });

    test('aceita CEP com máscara e grava o resultado no histórico', () async {
      final api = FakeViaCepRepository(address: sampleAddress());
      final service = AddressService(api, local);

      final address = await service.searchByCep('88010-000');

      expect(address?.city, 'Florianópolis');
      expect(local.stored.keys, ['88010000']);
    });

    test('responde consultas repetidas pelo armazenamento local', () async {
      await local.save(sampleAddress());
      final api = FakeViaCepRepository();
      final service = AddressService(api, local);

      final address = await service.searchByCep('88010000');

      expect(address?.street, 'Rua Felipe Schmidt');
      expect(api.calls, 0);
    });

    test('devolve null quando o ViaCEP não conhece o CEP', () async {
      final service = AddressService(FakeViaCepRepository(), local);

      final address = await service.searchByCep('99999999');

      expect(address, isNull);
      expect(local.stored, isEmpty);
    });

    test('troca falha de rede por mensagem para o usuário', () {
      final api = FakeViaCepRepository(
        error: DioError(
          requestOptions: RequestOptions(path: '/88010000/json/'),
          type: DioErrorType.connectTimeout,
        ),
      );
      final service = AddressService(api, local);

      expect(
        () => service.searchByCep('88010000'),
        throwsA(
          isA<AddressException>().having(
            (error) => error.message,
            'message',
            contains('conexão'),
          ),
        ),
      );
    });
  });

  group('busca por endereço', () {
    test('exige UF com 2 letras', () {
      final service = AddressService(FakeViaCepRepository(), local);

      expect(
        () => service.searchByAddress(
          state: 'Santa Catarina',
          city: 'Florianópolis',
          street: 'Felipe',
        ),
        throwsA(isA<AddressException>()),
      );
    });

    test('aceita parte do logradouro e devolve a lista do ViaCEP', () async {
      final api = FakeViaCepRepository(
        addresses: [
          sampleAddress(),
          sampleAddress(cep: '88015-000', street: 'Rua Felipe Neves'),
        ],
      );
      final service = AddressService(api, local);

      final addresses = await service.searchByAddress(
        state: 'sc',
        city: 'Florianópolis',
        street: 'Felipe',
      );

      expect(addresses, hasLength(2));
      expect(local.stored, isEmpty);
    });
  });

  test('o último consultado é o mais recente do histórico', () async {
    await local.save(sampleAddress(consultedAt: DateTime(2026, 1, 1)));
    await local.save(
      sampleAddress(
        cep: '01001-000',
        street: 'Praça da Sé',
        consultedAt: DateTime(2026, 6, 1),
      ),
    );
    final service = AddressService(FakeViaCepRepository(), local);

    expect(service.lastConsulted()?.cep, '01001-000');
  });
}
