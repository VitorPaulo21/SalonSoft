import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/models/account.dart';
import 'package:salon_soft/models/appointments.dart';
import 'package:salon_soft/models/client.dart';
import 'package:salon_soft/models/profile.dart';
import 'package:salon_soft/models/service.dart';
import 'package:salon_soft/models/settings.dart';
import 'package:salon_soft/models/worker.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/clients_provider.dart';
import 'package:salon_soft/providers/date_time_provider.dart';
import 'package:salon_soft/providers/keys_provider.dart';
import 'package:salon_soft/providers/profileProvider.dart';
import 'package:salon_soft/providers/services_provider.dart';
import 'package:salon_soft/providers/settings_provider.dart';
import 'package:salon_soft/providers/worker_provider.dart';
import 'dart:convert';

import 'package:salon_soft/screens/home_screen.dart';
import 'package:salon_soft/screens/professionals_screen.dart';
import 'package:salon_soft/screens/settings_screen.dart';
import 'package:salon_soft/utils/global_paths.dart';
import 'package:salon_soft/utils/routes.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(GlobalPaths.DATABASE_PATH);
  const secureStorage = FlutterSecureStorage();
  // if key not exists return null
  final encryprionKey = await secureStorage.read(key: 'key');
  if (encryprionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64UrlEncode(key),
    );
  }
  final key = await secureStorage.read(key: 'key');
  final encryptionKey = base64Url.decode(key!);
  print('Encryption key: $encryptionKey');
  Hive.registerAdapter(AppointmentsAdapter());
  Hive.registerAdapter(ClientAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(WorkerAdapter());
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(ProfileAdapter());
  // Hive.registerAdapter(ProfileAdapter());

  await Hive.openBox<Appointments>("appointments");
  await Hive.openBox<Client>("clients");
  await Hive.openBox<Service>("services");
  await Hive.openBox<Worker>("workers");
  await Hive.openBox<Settings>("settings");
  await Hive.openBox<Profile>("profile");
  await Hive.openBox<Account>('vaultBox',
      encryptionCipher: HiveAesCipher(encryptionKey));
  
  runApp(const MyApp());
  await DesktopWindow.setMaxWindowSize(Size(3840, 2160));
  await DesktopWindow.setMinWindowSize(Size(854, 480));
  await DesktopWindow.setFullScreen(true);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() async {
    await Hive.close();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        ChangeNotifierProvider<ProfileProvider>(
          // lazy: false,
          create: (ctx) {
            return ProfileProvider();
          },
        ),
        ChangeNotifierProvider<KeysProvider>(
          // lazy: false,
          create: (ctx) {
            return KeysProvider();
          },
        ),
       
        
        ChangeNotifierProvider<DateTimeProvider>(
          create: (ctx) {
            return DateTimeProvider();
          },
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (ctx) {
            return SettingsProvider();
          },
        ),
        ChangeNotifierProxyProvider<SettingsProvider, AppointmentProvider>(
          lazy: false,
          create: (ctx) {
            return AppointmentProvider(null);
          },
          update: (ctx, settings, appointment) => AppointmentProvider(settings),
        ),
        ChangeNotifierProxyProvider<AppointmentProvider, WorkerProvider>(
          // lazy: false,
          create: (ctx) {
            return WorkerProvider(null);
          },
          update: (ctx, appoint, _worker) {
            return WorkerProvider(appoint);
          },
        ),
        ChangeNotifierProxyProvider<AppointmentProvider, ServicesProvider>(
          // lazy: false,
          create: (ctx) {
            return ServicesProvider(null);
          },
          update: (ctx, appoint, _service) {
            return ServicesProvider(appoint);
          },
        ),
        ChangeNotifierProxyProvider<AppointmentProvider, ClientsProvider>(
          create: (ctx) {
            return ClientsProvider(null);
          },
          update: (ctx, appoint, _client) {
            return ClientsProvider(appoint);
          },
        ),
      ],
      child: MaterialApp(
        
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.pink[600],
                  secondary: Colors.amber,
                  onPrimary: Colors.white,
                  onSecondary: Colors.black,
                )),
        routes: {
          AppRoutes.HOME: (ctx) => HomeScreen(),
          AppRoutes.PROFESSIONALS: (ctx) => ProfessionalsScreen(),
          AppRoutes.SETTINGS: (ctx) => SettingsScreen(),
        },
      ),
    );
  }
}
