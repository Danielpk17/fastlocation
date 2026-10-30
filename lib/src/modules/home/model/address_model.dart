import 'package:hive/hive.dart';

part 'address_model.g.dart';

@HiveType(typeId: 0)
class AddressModel {
  AddressModel({
    required this.cep,
    required this.street,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.consultedAt,
  });

  factory AddressModel.fromViaCep(Map<String, dynamic> json) {
    return AddressModel(
      cep: json['cep'] as String? ?? '',
      street: json['logradouro'] as String? ?? '',
      complement: json['complemento'] as String? ?? '',
      neighborhood: json['bairro'] as String? ?? '',
      city: json['localidade'] as String? ?? '',
      state: json['uf'] as String? ?? '',
      consultedAt: DateTime.now(),
    );
  }

  @HiveField(0)
  final String cep;

  @HiveField(1)
  final String street;

  @HiveField(2)
  final String complement;

  @HiveField(3)
  final String neighborhood;

  @HiveField(4)
  final String city;

  @HiveField(5)
  final String state;

  @HiveField(6)
  final DateTime consultedAt;

  String get cepDigits => cep.replaceAll(RegExp(r'\D'), '');

  String get cityAndState => state.isEmpty ? city : '$city - $state';

  String get fullAddress {
    final parts = [street, neighborhood, cityAndState];
    return parts.where((part) => part.trim().isNotEmpty).join(', ');
  }

  AddressModel copyWith({DateTime? consultedAt}) {
    return AddressModel(
      cep: cep,
      street: street,
      complement: complement,
      neighborhood: neighborhood,
      city: city,
      state: state,
      consultedAt: consultedAt ?? this.consultedAt,
    );
  }
}
