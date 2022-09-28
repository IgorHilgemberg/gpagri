// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class FormWidgetsDemo extends StatefulWidget {
  static const routeName = '/form_widgets';

  const FormWidgetsDemo({Key? key}) : super(key: key);

  @override
  _FormWidgetsDemoState createState() => _FormWidgetsDemoState();
}

class _FormWidgetsDemoState extends State<FormWidgetsDemo> {
  // final _formKey = GlobalKey<FormState>();
  // String title = '';
  // String description = '';
  // DateTime date = DateTime.now();
  // double maxValue = 0;
  // bool? brushedTeeth = false;
  // bool enableFeature = false;

  @override
  Widget build(BuildContext context) {
    const SimpleDialog dialog = SimpleDialog();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propriedades'),
      ),
      body: SizedBox(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...[
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: "btn1",
                      backgroundColor: const Color(0xff03dac6),
                      foregroundColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const MyApp(),
                            // fullscreenDialog: true,
                          ),
                        );
                      },
                      child: const Icon(Icons.search),
                    ),
                  ],
                ),
                const MyStatelessWidget(),
              ].expand((widget) => [
                    widget,
                    const SizedBox(
                      height: 24,
                    )
                  ])
            ],
          ),
        ),
      ),

      // body: Form(
      //   key: _formKey,
      //   child: Scrollbar(
      //     child: Align(
      //       alignment: Alignment.topCenter,
      //       child: Card(
      //         child: SingleChildScrollView(
      //           padding: const EdgeInsets.all(16),
      //           child: ConstrainedBox(
      //             constraints: const BoxConstraints(maxWidth: 400),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 ...[
      //                   TextFormField(
      //                     decoration: const InputDecoration(
      //                       filled: true,
      //                       hintText: 'Enter a title...',
      //                       labelText: 'Title',
      //                     ),
      //                     onChanged: (value) {
      //                       setState(() {
      //                         title = value;
      //                       });
      //                     },
      //                   ),
      //                   TextFormField(
      //                     decoration: const InputDecoration(
      //                       border: OutlineInputBorder(),
      //                       filled: true,
      //                       hintText: 'Enter a description...',
      //                       labelText: 'Description',
      //                     ),
      //                     onChanged: (value) {
      //                       description = value;
      //                     },
      //                     maxLines: 5,
      //                   ),
      //                   _FormDatePicker(
      //                     date: date,
      //                     onChanged: (value) {
      //                       setState(() {
      //                         date = value;
      //                       });
      //                     },
      //                   ),
      //                   Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           Text(
      //                             'Estimated value',
      //                             style: Theme.of(context).textTheme.bodyText1,
      //                           ),
      //                         ],
      //                       ),
      //                       Text(
      //                         intl.NumberFormat.currency(
      //                             symbol: "\$", decimalDigits: 0)
      //                             .format(maxValue),
      //                         style: Theme.of(context).textTheme.subtitle1,
      //                       ),
      //                       Slider(
      //                         min: 0,
      //                         max: 500,
      //                         divisions: 500,
      //                         value: maxValue,
      //                         onChanged: (value) {
      //                           setState(() {
      //                             maxValue = value;
      //                           });
      //                         },
      //                       ),
      //                     ],
      //                   ),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       Checkbox(
      //                         value: brushedTeeth,
      //                         onChanged: (checked) {
      //                           setState(() {
      //                             brushedTeeth = checked;
      //                           });
      //                         },
      //                       ),
      //                       Text('Brushed Teeth',
      //                           style: Theme.of(context).textTheme.subtitle1),
      //                     ],
      //                   ),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       Text('Enable feature',
      //                           style: Theme.of(context).textTheme.bodyText1),
      //                       Switch(
      //                         value: enableFeature,
      //                         onChanged: (enabled) {
      //                           setState(() {
      //                             enableFeature = enabled;
      //                           });
      //                         },
      //                       ),
      //                     ],
      //                   ),
      //                 ].expand(
      //                       (widget) => [
      //                     widget,
      //                     const SizedBox(
      //                       height: 24,
      //                     )
      //                   ],
      //                 )
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          showDialog<void>(context: context, builder: (context) => dialog);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute<void>(
          //     builder: (BuildContext context) => const SimpleDialog(),
          //     // fullscreenDialog: true,
          //   ),
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FullScreenDialog extends StatelessWidget {
  const FullScreenDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    String description = '';
    DateTime date = DateTime.now();
    double maxValue = 0;
    bool? brushedTeeth = false;
    bool enableFeature = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6200EE),
        title: const Text('Cadastrar nova propriedade'),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.center,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        TextFormField(
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Entre com um nome...',
                            labelText: 'Nome',
                          ),
                          onChanged: (value) {
                            // setState(() {
                            //   title = value;
                            // });
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Entre com a área...',
                            labelText: 'Área',
                          ),
                          onChanged: (value) {
                            // setState(() {
                            //   title = value;
                            // });
                          },
                        ),
                        _FormDatePicker(
                          date: date,
                          onChanged: (value) {
                            // setState(() {
                            //   date = value;
                            // });
                          },
                        ),
                        TextButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Salvar'),
                        ),
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Data',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   static const String _title = 'Flutter Code Sample';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(title: const Text(_title)),
//         body: const MyStatelessWidget(),
//       ),
//     );
//   }
// }

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Age',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Role',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            '',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            '',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
            DataCell(Icon(Icons.delete)),
            DataCell(Icon(Icons.edit)),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Janine')),
            DataCell(Text('43')),
            DataCell(Text('Professor')),
            DataCell(Icon(Icons.delete)),
            DataCell(Icon(Icons.edit)),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('27')),
            DataCell(Text('Associate Professor')),
            DataCell(Icon(Icons.delete)),
            DataCell(Icon(Icons.edit)),
          ],
        ),
      ],
    );
  }
}

class SimpleDialog extends StatefulWidget {
  const SimpleDialog({Key? key}) : super(key: key);

  @override
  State<SimpleDialog> createState() => _SimpleDialogState();
}

class _SimpleDialogState extends State<SimpleDialog> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    String description = '';
    DateTime date = DateTime.now();
    double maxValue = 0;
    bool? brushedTeeth = false;
    bool enableFeature = false;

    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Card(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter a title...',
                          labelText: 'Title',
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          hintText: 'Enter a description...',
                          labelText: 'Description',
                        ),
                        onChanged: (value) {
                          description = value;
                        },
                        maxLines: 5,
                      ),
                      _FormDatePicker(
                        date: date,
                        onChanged: (value) {
                          setState(() {
                            date = value;
                          });
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimated value',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                          Text(
                            intl.NumberFormat.currency(
                                    symbol: "\$", decimalDigits: 0)
                                .format(maxValue),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Slider(
                            min: 0,
                            max: 500,
                            divisions: 500,
                            value: maxValue,
                            onChanged: (value) {
                              setState(() {
                                maxValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: brushedTeeth,
                            onChanged: (checked) {
                              setState(() {
                                brushedTeeth = checked;
                              });
                            },
                          ),
                          Text('Brushed Teeth',
                              style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Enable feature',
                              style: Theme.of(context).textTheme.bodyText1),
                          Switch(
                            value: enableFeature,
                            onChanged: (enabled) {
                              setState(() {
                                enableFeature = enabled;
                              });
                            },
                          ),
                        ],
                      ),
                      TextButton(
                        // color: Color(0xFF6200EE),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Salvar'),
                      ),
                    ].expand(
                      (widget) => [
                        widget,
                        const SizedBox(
                          height: 24,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: Text("Submit"),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState?.save();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Text("Open Popup"),
        ),
      ),
    );
  }
}
