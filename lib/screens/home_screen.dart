import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:salon_soft/components/titled_icon.dart';
import 'package:salon_soft/components/titled_icon_button.dart';
import 'package:salon_soft/utils/routes.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        elevation: 5,
        title: Text(
          "Salon Studio",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          TitledIconButton(
            onTap: () {},
            icon: Icon(
              Icons.calendar_month,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: "Agenda",
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          TitledIconButton(
            onTap: () {},
            icon: Icon(Icons.person_outline),
            title: "Clientes",
          ),
          TitledIconButton(
            onTap: () {},
            icon: Icon(Icons.storefront),
            title: "Serviços",
          ),
          TitledIconButton(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.PROFESSIONALS);
            },
            icon: const Icon(Icons.badge_outlined),
            title: "Profissionais",
          ),
          const SizedBox(
            width: 10,
          ),
          TitledIconButton(
            onTap: () {},
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: "Ajustes",
            textStyle: TextStyle(color: Colors.black),
            invert: true,
            centered: true,
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SingleChildScrollView(
              child: SideBarSelection(),
            ),
            Expanded(
                child: BoardView(
                  lists: [
                    BoardList(
                      header: [Text("oi")],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Column SideBarSelection() {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Container(
                 
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 1440 / 6,
                  child: ElevatedButton(
                    
                    onPressed: () {},
                    child:const TitledIcon(
                      title: "Adicionar",
                      icon: Icon(Icons.calendar_month_outlined),
                      centered: true,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: 1440 / 6,
                  height: 1440 / 6,
                  child: SfDateRangePicker(
                    enablePastDates: false,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 1440 / 6,
                  child: Text("Legenda"),
                ),
                const SizedBox(height: 10,),
                const TitledIcon(title: "Pendentes", icon: Icon(Icons.check_circle, color: Colors.amber,)),
                const SizedBox(height: 5,),
                const TitledIcon(title: "Atendendo", icon: Icon(Icons.check_circle, color: Colors.purple,)),
                const SizedBox(height: 5,),
                const TitledIcon(title: "Concluido", icon: Icon(Icons.check_circle, color: Colors.green,)),
                const SizedBox(height: 5,),
                const TitledIcon(title: "Horario Cancelado", icon: Icon(Icons.check_circle, color: Colors.red,),),
                const SizedBox(height: 5,),
                TitledIcon(title: "Horario Indisponivel", icon: Icon(Icons.check_circle, color: Colors.lightBlue[900],),),
                const SizedBox(height: 5,),
              ],
            );
  }
}
