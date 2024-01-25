import 'package:flutter/material.dart';

import 'package:ffigen_app/ffigen_app.dart' as ffigen_app;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ffigen_app.A genResult1, genResult2;
  late ffigen_app.A_Container container;

  @override
  void initState() {
    super.initState();
    genResult1 = ffigen_app.A.generate();
    genResult1.setValue(24);
    genResult2 = ffigen_app.A.generate();
    genResult2.setValue(42);
    container = ffigen_app.A_Container.generate();
    container.storeObject(container, genResult1);
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'Generate A => $genResult1',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'A\'s value is : ${genResult1.getValue()}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'A\'s handle is : ${genResult1.handle}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'Generate A => $genResult2',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'A\'s value is : ${genResult2.getValue()}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'A\'s handle is : ${genResult2.handle}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'A Container for A : $container',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'The Container has an object with value #${container.getObject(container, 0).getValue()} in index #0',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'and its address is ${container.getObject(container, 0).handle}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'Now the reference count for both object is ${genResult1.getUseCount()}, ${genResult2.getUseCount()}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
