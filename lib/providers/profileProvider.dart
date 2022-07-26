import 'package:hive/src/object/hive_object.dart';
import 'package:salon_soft/Interfaces/crud_hive_single_provider_interface.dart';
import 'package:salon_soft/models/profile.dart';

class ProfileProvider extends CrudHiveSingleProviderInterface<Profile> {
  ProfileProvider()
      : super(
            boxName: "profile",
            initialObjectValue: Profile(
                bairro: "",
                cidade: "Pará de Minas",
                cnpj: "",
                cpf: "",
                email: "",
                endereco: "",
                estado: "MG",
                logoPath: "",
                name: "Art Visual",
                numero: "",
                phoneNumber: ""));

  bool areAllFieldsEmpty() {
    return objectPrivate.bairro.isEmpty &&
        objectPrivate.cidade.isEmpty &&
        (objectPrivate.cnpj.isEmpty || objectPrivate.cpf.isEmpty) &&
        objectPrivate.email.isEmpty &&
        objectPrivate.endereco.isEmpty &&
        objectPrivate.endereco.isEmpty &&
        objectPrivate.estado.isEmpty &&
        objectPrivate.name.isEmpty &&
        objectPrivate.name.isEmpty &&
        objectPrivate.numero.isEmpty &&
        objectPrivate.phoneNumber.isEmpty;
  }
}
