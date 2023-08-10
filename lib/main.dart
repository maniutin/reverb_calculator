import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reverb & Delay Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Reverb & Delay Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tempo:',
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            _TempoSelector(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _TempoSelector extends StatefulWidget {
  @override
  __TempoSelectorState createState() => __TempoSelectorState();
}

class __TempoSelectorState extends State<_TempoSelector> {
  int _currentValue = 120;

  String calculateReverbTime(String type, double multiplier) {
    switch (type) {
      case 'predelay':
        return (((60000 / _currentValue) * multiplier) / 64).toStringAsFixed(2);
      case 'decay':
        return (((60000 / _currentValue) * multiplier) -
                (((60000 / _currentValue) * multiplier) / 64))
            .toStringAsFixed(2);
      case 'total':
        return ((60000 / _currentValue) * multiplier).toStringAsFixed(2);
      default:
        return ('Error');
    }
  }

  String calculateDelayTime(String type, double multiplier) {
    switch (type) {
      case 'note':
        return (((60000 / _currentValue) * multiplier)).toStringAsFixed(2);
      case 'dotted':
        return (((60000 / _currentValue) * multiplier) * 1.5)
            .toStringAsFixed(2);
      case 'triplet':
        return ((60000 / _currentValue) * multiplier * 0.667)
            .toStringAsFixed(2);
      default:
        return ('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ← Add this.

    return Column(
      children: <Widget>[
        NumberPicker(
          value: _currentValue,
          minValue: 1,
          maxValue: 999,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
        // Text('Current value: $_currentValue'),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: TabBar(
                tabs: [
                  Text(
                    'Reverb',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  Text(
                    'Delay',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
              ),
              body: TabBarView(
                children: [
                  DataTable(
                    // datatable widget
                    columns: [
                      DataColumn(
                        label: Text('Size'),
                      ),
                      DataColumn(
                        label: Text('Pre-Delay'),
                      ),
                      DataColumn(
                        label: Text('Decay'),
                      ),
                      DataColumn(
                        label: Text('Total'),
                      ),
                    ],
                    rows: [
                      // 1/16 Note
                      DataRow(cells: [
                        const DataCell(Text('1/16 Note')),
                        DataCell(Text(calculateReverbTime('predelay', 0.25))),
                        DataCell(Text(calculateReverbTime('decay', 0.25))),
                        DataCell(Text(calculateReverbTime('total', 0.25))),
                      ]),
                      // 1/8 Note
                      DataRow(cells: [
                        DataCell(Text('1/8 Note')),
                        DataCell(Text(calculateReverbTime('predelay', 0.5))),
                        DataCell(Text(calculateReverbTime('decay', 0.5))),
                        DataCell(Text(calculateReverbTime('total', 0.5))),
                      ]),
                      // 1/4 Note
                      DataRow(cells: [
                        DataCell(Text('1/4 Note')),
                        DataCell(Text(calculateReverbTime('predelay', 1))),
                        DataCell(Text(calculateReverbTime('decay', 1))),
                        DataCell(Text(calculateReverbTime('total', 1))),
                      ]),
                      // 1/2 Note
                      DataRow(cells: [
                        DataCell(Text('1/2 Note')),
                        DataCell(Text(calculateReverbTime('predelay', 2))),
                        DataCell(Text(calculateReverbTime('decay', 2))),
                        DataCell(Text(calculateReverbTime('total', 2))),
                      ]),
                      // 1 bar
                      DataRow(cells: [
                        DataCell(Text('1 Bar')),
                        DataCell(Text(calculateReverbTime('predelay', 4))),
                        DataCell(Text(calculateReverbTime('decay', 4))),
                        DataCell(Text(calculateReverbTime('total', 4))),
                      ]),
                      // 2 bars
                      DataRow(cells: [
                        DataCell(Text('2 Bars')),
                        DataCell(Text(calculateReverbTime('predelay', 8))),
                        DataCell(Text(calculateReverbTime('decay', 8))),
                        DataCell(Text(calculateReverbTime('total', 8))),
                      ]),
                      // 4 bars
                      DataRow(cells: [
                        DataCell(Text('4 Bars')),
                        DataCell(Text(calculateReverbTime('predelay', 16))),
                        DataCell(Text(calculateReverbTime('decay', 16))),
                        DataCell(Text(calculateReverbTime('total', 16))),
                      ]),
                      // 8 bars
                      DataRow(cells: [
                        DataCell(Text('8 Bars')),
                        DataCell(Text(calculateReverbTime('predelay', 32))),
                        DataCell(Text(calculateReverbTime('decay', 32))),
                        DataCell(Text(calculateReverbTime('total', 32))),
                      ]),
                    ],
                  ),
                  DataTable(
                    // datatable widget
                    columns: [
                      DataColumn(
                        label: Text('Size'),
                      ),
                      DataColumn(
                        label: Text('Note'),
                      ),
                      DataColumn(
                        label: Text('Dotted'),
                      ),
                      DataColumn(
                        label: Text('Tiplet'),
                      ),
                    ],
                    rows: [
                      // 1/16 Note
                      DataRow(cells: [
                        const DataCell(Text('1/16 Note')),
                        DataCell(Text(calculateDelayTime('note', 0.25))),
                        DataCell(Text(calculateDelayTime('dotted', 0.25))),
                        DataCell(Text(calculateDelayTime('triplet', 0.25))),
                      ]),
                      // 1/8 Note
                      DataRow(cells: [
                        DataCell(Text('1/8 Note')),
                        DataCell(Text(calculateDelayTime('note', 0.5))),
                        DataCell(Text(calculateDelayTime('dotted', 0.5))),
                        DataCell(Text(calculateDelayTime('triplet', 0.5))),
                      ]),
                      // 1/4 Note
                      DataRow(cells: [
                        DataCell(Text('1/4 Note')),
                        DataCell(Text(calculateDelayTime('note', 1))),
                        DataCell(Text(calculateDelayTime('dotted', 1))),
                        DataCell(Text(calculateDelayTime('triplet', 1))),
                      ]),
                      // 1/2 Note
                      DataRow(cells: [
                        DataCell(Text('1/2 Note')),
                        DataCell(Text(calculateDelayTime('note', 2))),
                        DataCell(Text(calculateDelayTime('dotted', 2))),
                        DataCell(Text(calculateDelayTime('triplet', 2))),
                      ]),
                      // 1 bar
                      DataRow(cells: [
                        DataCell(Text('1 Bar')),
                        DataCell(Text(calculateDelayTime('note', 4))),
                        DataCell(Text(calculateDelayTime('dotted', 4))),
                        DataCell(Text(calculateDelayTime('triplet', 4))),
                      ]),
                      // 2 bars
                      DataRow(cells: [
                        DataCell(Text('2 Bars')),
                        DataCell(Text(calculateDelayTime('note', 8))),
                        DataCell(Text(calculateDelayTime('dotted', 8))),
                        DataCell(Text(calculateDelayTime('triplet', 8))),
                      ]),
                      // 4 bars
                      DataRow(cells: [
                        DataCell(Text('4 Bars')),
                        DataCell(Text(calculateDelayTime('note', 16))),
                        DataCell(Text(calculateDelayTime('dotted', 16))),
                        DataCell(Text(calculateDelayTime('triplet', 16))),
                      ]),
                      // 8 bars
                      DataRow(cells: [
                        DataCell(Text('8 Bars')),
                        DataCell(Text(calculateDelayTime('note', 32))),
                        DataCell(Text(calculateDelayTime('dotted', 32))),
                        DataCell(Text(calculateDelayTime('triplet', 32))),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class ValuesTable extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context); // ← Add this.

//     return Column(
//       children: <Widget>[
//         NumberPicker(
//           value: _currentValue,
//           minValue: 1,
//           maxValue: 999,
//           onChanged: (value) => setState(() => _currentValue = value),
//         ),
//         // Text('Current value: $_currentValue'),
//         SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: DefaultTabController(
//             length: 2,
//             child: Scaffold(
//               appBar: TabBar(
//                 tabs: [
//                   Text(
//                     'Reverb',
//                     style: TextStyle(color: theme.colorScheme.primary),
//                   ),
//                   Text(
//                     'Delay',
//                     style: TextStyle(color: theme.colorScheme.primary),
//                   ),
//                 ],
//               ),
//               body: TabBarView(
//                 children: [
//                   DataTable(
//                     // datatable widget
//                     columns: [
//                       DataColumn(
//                         label: Text('Size'),
//                       ),
//                       DataColumn(
//                         label: Text('Pre-Delay'),
//                       ),
//                       DataColumn(
//                         label: Text('Decay'),
//                       ),
//                       DataColumn(
//                         label: Text('Total'),
//                       ),
//                     ],
//                     rows: [
//                       // 1/16 Note
//                       DataRow(cells: [
//                         const DataCell(Text('1/16 Note')),
//                         DataCell(Text(calculateReverbTime('predelay', 0.25))),
//                         DataCell(Text(calculateReverbTime('decay', 0.25))),
//                         DataCell(Text(calculateReverbTime('total', 0.25))),
//                       ]),
//                       // 1/8 Note
//                       DataRow(cells: [
//                         DataCell(Text('1/8 Note')),
//                         DataCell(Text(calculateReverbTime('predelay', 0.5))),
//                         DataCell(Text(calculateReverbTime('decay', 0.5))),
//                         DataCell(Text(calculateReverbTime('total', 0.5))),
//                       ]),
//                       // 1/4 Note
//                       DataRow(cells: [
//                         DataCell(Text('1/4 Note')),
//                         DataCell(Text(calculateReverbTime('predelay', 1))),
//                         DataCell(Text(calculateReverbTime('decay', 1))),
//                         DataCell(Text(calculateReverbTime('total', 1))),
//                       ]),
//                       // 1/2 Note
//                       DataRow(cells: [
//                         DataCell(Text('1/2 Note')),
//                         DataCell(Text(calculateReverbTime('predelay', 2))),
//                         DataCell(Text(calculateReverbTime('decay', 2))),
//                         DataCell(Text(calculateReverbTime('total', 2))),
//                       ]),
//                       // 1 bar
//                       DataRow(cells: [
//                         DataCell(Text('1 Bar')),
//                         DataCell(Text(calculateReverbTime('predelay', 4))),
//                         DataCell(Text(calculateReverbTime('decay', 4))),
//                         DataCell(Text(calculateReverbTime('total', 4))),
//                       ]),
//                       // 2 bars
//                       DataRow(cells: [
//                         DataCell(Text('2 Bars')),
//                         DataCell(Text(calculateReverbTime('predelay', 8))),
//                         DataCell(Text(calculateReverbTime('decay', 8))),
//                         DataCell(Text(calculateReverbTime('total', 8))),
//                       ]),
//                       // 4 bars
//                       DataRow(cells: [
//                         DataCell(Text('4 Bars')),
//                         DataCell(Text(calculateReverbTime('predelay', 16))),
//                         DataCell(Text(calculateReverbTime('decay', 16))),
//                         DataCell(Text(calculateReverbTime('total', 16))),
//                       ]),
//                       // 8 bars
//                       DataRow(cells: [
//                         DataCell(Text('8 Bars')),
//                         DataCell(Text(calculateReverbTime('predelay', 32))),
//                         DataCell(Text(calculateReverbTime('decay', 32))),
//                         DataCell(Text(calculateReverbTime('total', 32))),
//                       ]),
//                     ],
//                   ),
//                   DataTable(
//                     // datatable widget
//                     columns: [
//                       DataColumn(
//                         label: Text('Size'),
//                       ),
//                       DataColumn(
//                         label: Text('Note'),
//                       ),
//                       DataColumn(
//                         label: Text('Dotted'),
//                       ),
//                       DataColumn(
//                         label: Text('Tiplet'),
//                       ),
//                     ],
//                     rows: [
//                       // 1/16 Note
//                       DataRow(cells: [
//                         const DataCell(Text('1/16 Note')),
//                         DataCell(Text(calculateDelayTime('note', 0.25))),
//                         DataCell(Text(calculateDelayTime('dotted', 0.25))),
//                         DataCell(Text(calculateDelayTime('triplet', 0.25))),
//                       ]),
//                       // 1/8 Note
//                       DataRow(cells: [
//                         DataCell(Text('1/8 Note')),
//                         DataCell(Text(calculateDelayTime('note', 0.5))),
//                         DataCell(Text(calculateDelayTime('dotted', 0.5))),
//                         DataCell(Text(calculateDelayTime('triplet', 0.5))),
//                       ]),
//                       // 1/4 Note
//                       DataRow(cells: [
//                         DataCell(Text('1/4 Note')),
//                         DataCell(Text(calculateDelayTime('note', 1))),
//                         DataCell(Text(calculateDelayTime('dotted', 1))),
//                         DataCell(Text(calculateDelayTime('triplet', 1))),
//                       ]),
//                       // 1/2 Note
//                       DataRow(cells: [
//                         DataCell(Text('1/2 Note')),
//                         DataCell(Text(calculateDelayTime('note', 2))),
//                         DataCell(Text(calculateDelayTime('dotted', 2))),
//                         DataCell(Text(calculateDelayTime('triplet', 2))),
//                       ]),
//                       // 1 bar
//                       DataRow(cells: [
//                         DataCell(Text('1 Bar')),
//                         DataCell(Text(calculateDelayTime('note', 4))),
//                         DataCell(Text(calculateDelayTime('dotted', 4))),
//                         DataCell(Text(calculateDelayTime('triplet', 4))),
//                       ]),
//                       // 2 bars
//                       DataRow(cells: [
//                         DataCell(Text('2 Bars')),
//                         DataCell(Text(calculateDelayTime('note', 8))),
//                         DataCell(Text(calculateDelayTime('dotted', 8))),
//                         DataCell(Text(calculateDelayTime('triplet', 8))),
//                       ]),
//                       // 4 bars
//                       DataRow(cells: [
//                         DataCell(Text('4 Bars')),
//                         DataCell(Text(calculateDelayTime('note', 16))),
//                         DataCell(Text(calculateDelayTime('dotted', 16))),
//                         DataCell(Text(calculateDelayTime('triplet', 16))),
//                       ]),
//                       // 8 bars
//                       DataRow(cells: [
//                         DataCell(Text('8 Bars')),
//                         DataCell(Text(calculateDelayTime('note', 32))),
//                         DataCell(Text(calculateDelayTime('dotted', 32))),
//                         DataCell(Text(calculateDelayTime('triplet', 32))),
//                       ]),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
