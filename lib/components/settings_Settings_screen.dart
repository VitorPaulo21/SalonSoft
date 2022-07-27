import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:salon_soft/components/profile_image_round.dart';
import 'package:salon_soft/models/settings.dart';
import 'package:salon_soft/models/time.dart';
import 'package:salon_soft/providers/settings_provider.dart';

class SettingsComponentScreen extends StatefulWidget {
  const SettingsComponentScreen({Key? key}) : super(key: key);

  @override
  State<SettingsComponentScreen> createState() =>
      _SettingsComponentScreenState();
}

class _SettingsComponentScreenState extends State<SettingsComponentScreen> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              child: ProfileImageRound(
                withText: true,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 28,
                      ),
                      Text(
                        "Configurações",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 30),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 28,
                              ),
                              const SizedBox(
                                width: 223,
                                child: Text(
                                  "Dias de Funcionamento",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: ["S", "T", "Q", "Q", "S", "S", "D"]
                                    .map<Widget>((day) {
                                  bool workDay = true;
                                  if (day == "D") {
                                    workDay = false;
                                  }
                                  return Container(
                                    alignment: Alignment.center,
                                    width: 25,
                                    height: 25,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                          color: workDay
                                              ? Colors.white
                                              : Colors.grey),
                                    ),
                                    decoration: BoxDecoration(
                                        color: workDay
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : null,
                                        shape: BoxShape.circle,
                                        border: !workDay
                                            ? Border.all(color: Colors.grey)
                                            : null),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              timeFieldPicker(settingsProvider,
                                  time: Time(
                                      settingsProvider.objectPrivate.openHour,
                                      settingsProvider
                                          .objectPrivate.openMinute),
                                  title: "Horário de abertura"),
                              const Divider(
                                height: 30,
                              ),
                              timeFieldPicker(settingsProvider,
                                  time: Time(
                                      settingsProvider.objectPrivate.closeHour,
                                      settingsProvider
                                          .objectPrivate.closeMinute),
                                  title: "Horário de Fechamento"),
                              const Divider(
                                height: 30,
                              ),
                              intervalFieldPicker(
                                  title: "Intervalo de Tempo do relógio",
                                  interval: settingsProvider
                                      .objectPrivate.intervalOfMinutes)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column timeFieldPicker(SettingsProvider settingsProvider,
      {Time? time, required String title}) {
    TextEditingController hourController = TextEditingController();
    TextEditingController minuteController = TextEditingController();
    if (time != null) {
      hourController.text = time.hour.toString().padLeft(2, "0");
      minuteController.text = time.min.toString().padLeft(2, "0");
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              child: TypeAheadFormField<int>(
                suggestionsCallback: (query) {
                  return List<int>.generate(24, (index) => index).where(
                      (element) =>
                          element.toString().padLeft(2, "0").contains(query));
                  ;
                },
                itemBuilder: (context, itemData) {
                  return Text(
                    itemData.toString().padLeft(2, "0"),
                    textAlign: TextAlign.center,
                  );
                },
                onSuggestionSelected: (value) {},
                textFieldConfiguration: TextFieldConfiguration(
                    controller: hourController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      label: Text("Hor: "),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(":"),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 100,
              child: TypeAheadFormField<int>(
                suggestionsCallback: (query) {
                  return List<int>.generate(
                      60 ~/ settingsProvider.objectPrivate.intervalOfMinutes,
                      (index) =>
                          index *
                          settingsProvider.objectPrivate
                              .intervalOfMinutes).where((element) =>
                      element.toString().padLeft(2, "0").contains(query));
                },
                itemBuilder: (context, itemData) {
                  return Text(
                    itemData.toString().padLeft(2, "0"),
                    textAlign: TextAlign.center,
                  );
                },
                onSuggestionSelected: (value) {},
                textFieldConfiguration: TextFieldConfiguration(
                    controller: minuteController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      label: Text("Min: "),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget intervalFieldPicker({int? interval, required String title}) {
    TextEditingController intervalController = TextEditingController();
    if (interval != null) {
      intervalController.text = interval.toString().padLeft(2, "0");
    }
    return SizedBox(
      width: 222,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: TypeAheadFormField<int>(
                  suggestionsCallback: (query) {
                    return [15, 30].where((element) =>
                        element.toString().padLeft(2, "0").contains(query));
                    ;
                  },
                  itemBuilder: (context, itemData) {
                    return Text(
                      itemData.toString().padLeft(2, "0"),
                      textAlign: TextAlign.center,
                    );
                  },
                  onSuggestionSelected: (value) {},
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: intervalController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        label: Text("Min: "),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
