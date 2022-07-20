import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/models/appointments.dart';
import 'package:salon_soft/models/client.dart';
import 'package:salon_soft/models/service.dart';
import 'package:salon_soft/models/settings.dart';
import 'package:salon_soft/models/worker.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/clients_provider.dart';
import 'package:salon_soft/providers/date_time_provider.dart';
import 'package:salon_soft/providers/keys_provider.dart';
import 'package:salon_soft/providers/services_provider.dart';
import 'package:salon_soft/providers/settings_provider.dart';
import 'package:salon_soft/providers/worker_provider.dart';

import 'package:salon_soft/screens/home_screen.dart';
import 'package:salon_soft/screens/professionals_screen.dart';
import 'package:salon_soft/utils/routes.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(Platform.resolvedExecutable
          .substring(0, Platform.resolvedExecutable.lastIndexOf("\\")) +
      "\\DataBase");
  Hive.registerAdapter(AppointmentsAdapter());
  Hive.registerAdapter(ClientAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(WorkerAdapter());
  Hive.registerAdapter(SettingsAdapter());

  await Hive.openBox<Appointments>("appointments");
  await Hive.openBox<Client>("clients");
  await Hive.openBox<Service>("services");
  await Hive.openBox<Worker>("workers");
  await Hive.openBox<Settings>("settings");
  
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
        ChangeNotifierProvider<KeysProvider>(
          lazy: false,
          create: (ctx) {
            return KeysProvider();
          },
        ),
        ChangeNotifierProvider<WorkerProvider>(
          create: (ctx) {
            return WorkerProvider();
          },
        ),
        ChangeNotifierProvider<ServicesProvider>(
          create: (ctx) {
            return ServicesProvider();
          },
        ),
        ChangeNotifierProvider<ClientsProvider>(
          create: (ctx) {
            return ClientsProvider();
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
          create: (ctx) {
            return AppointmentProvider(null);
          },
          update: (ctx, settings, appointment) => AppointmentProvider(settings),
        ),
      ],
      child: MaterialApp(
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
        },
      ),
    );
  }
}
