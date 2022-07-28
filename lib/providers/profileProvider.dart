import 'package:hive/src/object/hive_object.dart';
import 'package:salon_soft/Interfaces/crud_hive_single_provider_interface.dart';
import 'package:salon_soft/models/profile.dart';

class ProfileProvider extends CrudHiveSingleProviderInterface<Profile> {
  ProfileProvider()
      : super(
            boxName: "profile",
            initialObjectValue: Profile(
                bairro: "",
                cidade: "",
                cnpj: "",
                cpf: "",
                email: "",
                endereco: "",
                estado: "",
                logoPath: "",
                name: "",
                numero: "",
                phoneNumber: ""));

  bool areAllFieldsFilled() {
    return objectPrivate.bairro.isNotEmpty &&
        objectPrivate.cidade.isNotEmpty &&
        (objectPrivate.cnpj.isNotEmpty || objectPrivate.cpf.isNotEmpty) &&
        objectPrivate.email.isNotEmpty &&
        objectPrivate.endereco.isNotEmpty &&
        objectPrivate.endereco.isNotEmpty &&
        objectPrivate.estado.isNotEmpty &&
        objectPrivate.name.isNotEmpty &&
        objectPrivate.name.isNotEmpty &&
        objectPrivate.numero.isNotEmpty &&
        objectPrivate.phoneNumber.isNotEmpty;
  }

  void changePhotoPath(String path) {
    objectPrivate.logoPath = path;
    notifyListeners();
    if (objectPrivate.isInBox) {
      objectPrivate.save();
    }
  }

  
}
