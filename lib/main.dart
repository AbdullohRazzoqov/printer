import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:wise_bluetooth_print/classes/paired_device.dart';
import 'package:wise_bluetooth_print/wise_bluetooth_print.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //qurulmalar ro'yxati
  late List<PairedDevice> _devices;

  @override
  void initState() {
    super.initState();
   // PairedDevice typeda bo'sh list tenglab oldik
    _devices = <PairedDevice>[];
    initPlatformState();
  }

  Future<void> initPlatformState() async {

    List<PairedDevice> devices = <PairedDevice>[];

    try {
      //Biz  oldindan bluetooth orqali ulangan qurulmalarni topadi
      devices = await WiseBluetoothPrint.getPairedDevices();
    } on PlatformException {
      devices = <PairedDevice>[];
    }

    if (!mounted) return;

    setState(() {
      _devices = devices;
    });
  }
//printerga chiqarish
  void initPrint() async {
    String printTextZPL = "Hello\n\n"
        "1800\n\n";
    await WiseBluetoothPrint.print(device, printTextZPL);
  }

  String device = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(
            10,
          ),
          child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    device = _devices[index].socketId;
                  },
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_devices[index].name),
                                  Text(_devices[index].hardwareAddress)
                                ]),
                            subtitle: Text(_devices[index].socketId))
                      ],
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          initPrint();
        },
      ),
    ));
  }
}
