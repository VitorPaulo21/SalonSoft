import 'dart:io';

import 'package:path_provider/path_provider.dart';

class GlobalPaths {
  static String APLICATION_PATH = Platform.resolvedExecutable
      .substring(0, Platform.resolvedExecutable.lastIndexOf("\\"));

  static String DATABASE_PATH = APLICATION_PATH + "\\DataBase";

  static String USER_PROFILE_IMAGE_DIRECTORY =
      APLICATION_PATH + "\\UserImages\\ProfileImages";

  static String USER_LOGO_IMAGE_PATH =
      APLICATION_PATH + "\\UserImages\\LogoImage";
}
