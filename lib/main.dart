import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:salon_soft/models/appointment.dart';
import 'package:salon_soft/models/client.dart';
import 'package:salon_soft/models/service.dart';
import 'package:salon_soft/models/worker.dart';

import 'package:salon_soft/screens/home_screen.dart';
import 'package:salon_soft/screens/professionals_screen.dart';
import 'package:salon_soft/utils/routes.dart';
import 'package:desktop_window/desktop_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AppointmentAdapter());
  Hive.registerAdapter(ClientAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(WorkerAdapter());

  await Hive.openBox<Appointment>("appointments");
  await Hive.openBox<Client>("clients");
  await Hive.openBox<Service>("services");
  await Hive.openBox<Worker>("workers");
  runApp(const MyApp());
  await DesktopWindow.setMaxWindowSize(Size(3840, 2160));
  await DesktopWindow.setMinWindowSize(Size(854, 480));
  await DesktopWindow.setFullScreen(true);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
