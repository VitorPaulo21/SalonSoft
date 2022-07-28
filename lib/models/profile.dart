import 'package:hive_flutter/hive_flutter.dart';

part 'profile.g.dart';

@HiveType(typeId: 6)
class Profile extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String logoPath;
  @HiveField(2)
  String cnpj;
  @HiveField(3)
  String cpf;
  @HiveField(4)
  String email;
  @HiveField(5)
  String phoneNumber;
  @HiveField(6)
  String endereco;
  @HiveField(7)
  String numero;
  @HiveField(8)
  String bairro;
  @HiveField(9)
  String cidade;
  @HiveField(10)
  String estado;

  Profile({
    required this.bairro,
    required this.cidade,
    required this.cnpj,
    required this.cpf,
    required this.email,
    required this.endereco,
    required this.estado,
    required this.logoPath,
    required this.name,
    required this.numero,
    required this.phoneNumber,
  });

  bool areAllFilled() {
    return name.isNotEmpty &&
        cnpj.isNotEmpty &&
        cpf.isNotEmpty &&
        email.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        endereco.isNotEmpty &&
        numero.isNotEmpty &&
        bairro.isNotEmpty &&
        cidade.isNotEmpty &&
        estado.isNotEmpty;
  }
}
