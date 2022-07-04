import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/models/appointments.dart';
import 'package:salon_soft/models/client.dart';
import 'package:salon_soft/models/service.dart';
import 'package:salon_soft/models/worker.dart';
import 'package:salon_soft/providers/appointment_provider.dart';
import 'package:salon_soft/providers/clients_provider.dart';
import 'package:salon_soft/providers/date_time_provider.dart';
import 'package:salon_soft/providers/services_provider.dart';
import 'package:salon_soft/providers/worker_provider.dart';

import 'package:salon_soft/screens/home_screen.dart';
import 'package:salon_soft/screens/professionals_screen.dart';
import 'package:salon_soft/utils/routes.dart';
import 'package:desktop_window/desktop_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AppointmentsAdapter());
  Hive.registerAdapter(ClientAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(WorkerAdapter());
  
  Hive.deleteFromDisk();
  await Hive.openBox<Appointments>("appointments");
  await Hive.openBox<Client>("clients");
  await Hive.openBox<Service>("services");
  await Hive.openBox<Worker>("workers");
  
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
        ChangeNotifierProvider<AppointmentProvider>(
          create: (ctx) {
            return AppointmentProvider();
          },
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
