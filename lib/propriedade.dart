import 'package:flutter/material.dart';
import 'package:login_example/cardss.dart';
// import 'package:intl/date_symbol_data_local.dart';
import 'package:login_example/campo.dart';
import 'package:login_example/talhao.dart';
import 'package:provider/provider.dart';
import 'package:login_example/dashboard_screen.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

// initializedDateFormatting('pt_BR',null).then((_)=>runMyCode());
// void main() => runApp(const MyHomePage());

Future<void> insertPropriedade(String? nome, String? area) async {
  // List<Campo> campos = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(milliseconds: 400));
  var insert = await conn.query(
      'insert into propriedade (nome, area) values (?, ?)', [nome, area]);
  // for (var row in results) {
  //   // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  //   // campos.add(
  //   //   Campo(
  //   //       name: '${row[2]}',
  //   //       area: '${row[0]}',
  //   //       cod_propriedade: '${row[3]}',
  //   //       cod_campo: '${row[1]}'),
  //   // );

  //   // print(campos[0]);
  // }
  // await conn.close();
  // print(campos);
}

Future<List<Propriedade>> getPropriedadeById(String nome) async {
  List<Propriedade> propriedades = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(milliseconds: 100));
  var results =
      await conn.query('select * from propriedade where nome=?', [nome]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    propriedades.add(
      Propriedade(
        nome: '${row[2]}',
        area: '${row[0]}',
        codPropriedade: '${row[1]}',
        // cod_campo: '${row[1]}'),
      ),
    );

    // print(campos[0]);
  }
  // await conn.close();
  // print(campos);
  return propriedades;
}

// //GET all the farm fields
Future<List<Propriedade>> getPropriedades() async {
  List<Propriedade> propriedades = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(milliseconds: 500));
  var results = await conn.query('select * from propriedade');
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    propriedades.add(
      Propriedade(
        nome: '${row[2]}',
        area: '${row[0]}',
        codPropriedade: '${row[1]}',
        // cod_campo: '${row[1]}'),
      ),
    );

    // print(campos[0]);
  }
  // await conn.close();
  // print(campos);
  return propriedades;
}

// // GET all the property fields
// Future<List<Propriedade>> getPropriedades() async {
//   List<Propriedade> propriedades = [];
//   final conn = await mysqlconnector;
//   // print('Você está aqui!!');

//   //var conn = await MySqlConnection.connect(settings);
//   await Future.delayed(const Duration(seconds: 1));
//   var results = await conn.query('select * from propriedade');
//   for (var row in results) {
//     // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
//     propriedades.add(
//       Propriedade(
//         name: '${row[2]}',
//         codPropriedade: '${row[1]}',
//       ),
//     );
//   }
//   // await conn.close();
//   return propriedades;
// }

Future<void> deletePropriedade(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete = await conn
        .query('DELETE FROM propriedade WHERE cod_propriedade = ?', [id]);
  } catch (e) {
    print(e);
  }
}

Future<void> updatePropriedade(String nome, String area, String id) async {
  final conn = await mysqlconnector;

  var update = await conn.query(
      'update propriedade  set nome=?, area=? WHERE cod_propriedade = ?',
      [nome, area, id]);
}

// class DialogUpdadeCampo extends StatefulWidget {
//   const DialogUpdadeCampo({Key? key, this.codPropriedade, this.nomePropriedade})
//       : super(key: key);

//   final String? codPropriedade;
//   final String? nomePropriedade;

//   @override
//   State<DialogUpdadeCampo> createState() => _DialogUpdateCampoState();
// }

// class _DialogUpdateCampoState extends State<DialogUpdadeCampo> {
//   final _formKey = GlobalKey<FormState>();
//   String? nome;
//   String? area;
//   DateTime date = DateTime.now();
//   // final _campo = Campo();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF6200EE),
//         title: Text('Editar propriedade "' + widget.nomePropriedade! + '"'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Scrollbar(
//           child: Align(
//             alignment: Alignment.center,
//             child: Card(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ...[
//                         TextFormField(
//                           decoration: const InputDecoration(
//                             filled: true,
//                             hintText: 'Entre com um nome...',
//                             labelText: 'Nome',
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               nome = value;
//                             });
//                           },
//                         ),
//                         TextFormField(
//                           decoration: const InputDecoration(
//                             filled: true,
//                             hintText: 'Entre com a área...',
//                             labelText: 'Área',
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               area = value;
//                             });
//                           },
//                         ),
//                         _FormDatePicker(
//                           date: date,
//                           onChanged: (value) {
//                             // setState(() {
//                             //   date = value;
//                             // });
//                           },
//                         ),
//                         TextButton(
//                           // color: Color(0xFF6200EE),
//                           onPressed: () {
//                             updatePropriedade(
//                                 nome!, area!, widget.codPropriedade!);
//                             Navigator.pop(context, nome);
//                           },
//                           child: const Text('Salvar'),
//                         ),
//                       ].expand(
//                         (widget) => [
//                           widget,
//                           const SizedBox(
//                             height: 24,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class TelaPropriedades extends StatefulWidget {
  static const routeName = '/propriedade';
  const TelaPropriedades({Key? key}) : super(key: key);

  @override
  State<TelaPropriedades> createState() => _TelaPropriedadesState();
}

class _TelaPropriedadesState extends State<TelaPropriedades> {
  // late Future<List<Campo>> futureCampo;
  late Future<List<Propriedade>> futurePropriedade;
  // Propriedade? _selectedPropriedade;
  String dropdownValue = 'One';

  @override
  void initState() {
    super.initState();
    futurePropriedade = getPropriedades();
  }

  void _handleUpdate() {
    futurePropriedade = getPropriedades();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final List<Campo> campos;
    // campos = getCampos() as List<Campo>;
    // final Campo? campo1;
    // campo1 =
    //     const Campo(name: "name", area: "25", codPropriedade: 3, cod_campo: 4);
    // var campocard = CampoCard(campo: campo1);
    return
        // MaterialApp(
        //   title: 'Cardss',
        //   theme: ThemeData(
        //     primarySwatch: Colors.blue,
        //   ),
        // home:
        Scaffold(
      appBar: AppBar(
        title: const Text('Propriedades'),
      ),
      body: Center(
        child: FutureBuilder<List<Propriedade>>(
            future: futurePropriedade,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            // FutureBuilder<List<Propriedade>>(
                            //     future: futurePropriedade,
                            //     builder: (context, propr) {
                            //       if (propr.hasData) {
                            //         return DropdownButton<Propriedade>(
                            //           hint: const Text('Escolha a propriedade'),
                            //           value: _selectedPropriedade,
                            //           icon: const Icon(Icons.arrow_downward),
                            //           elevation: 16,
                            //           style: const TextStyle(
                            //               color: Colors.deepPurple),
                            //           underline: Container(
                            //             height: 2,
                            //             color: Colors.deepPurpleAccent,
                            //           ),
                            //           onChanged: (Propriedade? newValue) {
                            //             setState(() {
                            //               _selectedPropriedade = newValue!;
                            //             });
                            //           },
                            //           items: propr.data
                            //               ?.map<DropdownMenuItem<Propriedade>>(
                            //                   (Propriedade value) {
                            //             return DropdownMenuItem<Propriedade>(
                            //               value: value,
                            //               child: Text(value.codPropriedade +
                            //                   ' ' +
                            //                   value.name),
                            //             );
                            //           }).toList(),
                            //         );
                            //       } else if (propr.hasError) {
                            //         return Text('${propr.error}');
                            //       }
                            //       return const CircularProgressIndicator();
                            //     }),
                            // DropdownButton<String>(
                            //   value: dropdownValue,
                            //   icon: const Icon(Icons.arrow_downward),
                            //   elevation: 16,
                            //   style: const TextStyle(color: Colors.deepPurple),
                            //   underline: Container(
                            //     height: 2,
                            //     color: Colors.deepPurpleAccent,
                            //   ),
                            //   onChanged: (String? newValue) {
                            //     setState(() {
                            //       dropdownValue = newValue!;
                            //     });
                            //   },
                            //   items: <String>[
                            //     'One',
                            //     'Two',
                            //     'Free',
                            //     'Four'
                            //   ].map<DropdownMenuItem<String>>((String value) {
                            //     return DropdownMenuItem<String>(
                            //       value: value,
                            //       child: Text(value),
                            //     );
                            //   }).toList(),
                            // ),
                          ],
                        ),
                        ...?snapshot.data?.map((d) => PropriedadeCard(
                            propriedade: d, onChanged: _handleUpdate)),
                      ],
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
        // child: ListView(
        //   children: [
        //     // Column(
        //     //   children: [
        //     //     ...campos.map((d) => CampoCard(campo: d)),
        //     //     // campocard,
        //     //   ],
        //     // ),
        //   ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: const Color(0xff03dac6),
      //   foregroundColor: Colors.black,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute<void>(
      //         builder: (BuildContext context) => const FullScreenDialog(),
      //         fullscreenDialog: true,
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
    // );
  }
}

class Propriedade {
  String nome;
  String area;
  String codPropriedade;

  Propriedade(
      {required this.nome, required this.area, required this.codPropriedade});

  // String toString() {
  //   return 'Campo: {nome: $name, area: $area, cod_campo: $cod_campo, codPropriedade: $codPropriedade}';
  // }
}

class PropriedadeCard extends StatelessWidget {
  final Propriedade? propriedade;
  final Function onChanged;
  const PropriedadeCard({this.propriedade, required this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // if you need this
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 4,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            // onTap: () {
            //   var counter = context.read<Counter>();
            //   var campo = context.read<CampoProvider>();
            //   var talhao = context.read<TalhaoProvider>();
            //   if (campo.nomeCampo == '') {
            //     counter.increment(
            //         propriedade!.nome, propriedade!.codPropriedade);
            //   } else if (propriedade!.nome != counter.nomePropriedade) {
            //     counter.increment(
            //         propriedade!.nome, propriedade!.codPropriedade);
            //     campo.increment('', '');
            //     talhao.increment('', '');
            //   }
            // },
            leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(propriedade!.nome),
            subtitle: Text(
              'Cod ' +
                  (propriedade!.codPropriedade.toString()) +
                  '  ' +
                  propriedade!.area +
                  ' ha',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
          //     style: TextStyle(color: Colors.black.withOpacity(0.6)),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(0.5),
          //   child: TextButton(
          //     //textColor: const Color(0xFF6200EE),
          //     onPressed: () {
          //       // Perform some action
          //       Navigator.pushNamed((context), '/campo');
          //       // getCampos(codPropriedade: propriedade!.codPropriedade);
          //     },
          //     child: const Text('Ver campos'),
          //   ),
          // ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              // TextButton(
              //   //textColor: const Color(0xFF6200EE),
              //   onPressed: () {
              //     // Perform some action
              //   },
              //   child: const Text('Ver talhões'),
              // ),
              TextButton.icon(
                //textColor: const Color(0xFF6200EE),
                onPressed: () async {
                  await showDialog<void>(
                      context: context,
                      builder: (context) => DialogUpdateTeste(
                          codPropriedade: propriedade!.codPropriedade,
                          nomePropriedade: propriedade!.nome)).then((_) {
                    var counter = context.read<PropriedadProvider>();
                    counter.onChangedFalse();
                    counter.increment();
                    counter.toList();
                    onChanged();
                    var index = counter.listPropriedade.indexWhere(
                        (_selecionada) =>
                            _selecionada.codPropriedade ==
                            counter.selectedPropriedade!.codPropriedade);
                    counter.findit(index);

                    // counter.getSelected(propriedade);
                    counter.onChangedTrue();
                  });
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
              ),

              TextButton.icon(
                //textColor: const Color(0xFF6200EE),
                onPressed: () async {
                  await deletePropriedade(propriedade!.codPropriedade)
                      .then((_) {
                    var counter = context.read<PropriedadProvider>();
                    counter.onChangedFalse();
                    counter.increment();
                    counter.toList();
                    var index = counter.listPropriedade.indexWhere(
                        (_selecionada) =>
                            _selecionada.codPropriedade ==
                            counter.selectedPropriedade!.codPropriedade);
                    if (counter.selectedPropriedade!.codPropriedade !=
                        propriedade!.codPropriedade) {
                      counter.findit(index);
                    } else {
                      counter.findit(index - 1);
                      counter.getSelected(counter.listPropriedade[index - 1]);
                    }
                    counter.onChangedTrue();
                    // if (counter.listPropriedade
                    //     .contains(counter.selectedPropriedade)) {
                    //   // final _selecionada = counter.selectedPropriedade;
                    //   print('Você está aqui 1');
                    //   final index = counter.listPropriedade.indexWhere(
                    //       (_selecionada) =>
                    //           _selecionada.nome ==
                    //           counter.selectedPropriedade!.nome);

                    // counter.getSelected(null);
                    //   print('Você está aqui 2' +
                    //       counter.listPropriedade[index].hashCode.toString());
                    //   counter.onChangedTrue();
                    // }
                    onChanged();
                  });
                },
                icon: const Icon(Icons.delete),
                label: const Text('Excluir'),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          //Image.asset('assets/card-sample-image.jpg'),
        ],
      ),
    );
  }
}

// class FullScreenDialog extends StatefulWidget {
//   const FullScreenDialog({Key? key}) : super(key: key);

//   @override
//   State<FullScreenDialog> createState() => _FullScreenDialogState();
// }

// class _FullScreenDialogState extends State<FullScreenDialog> {
//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();

//     String description = '';
//     DateTime date = DateTime.now();
//     double maxValue = 0;
//     bool? brushedTeeth = false;
//     bool enableFeature = false;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF6200EE),
//         title: const Text('Cadastrar novo campo'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Scrollbar(
//           child: Align(
//             alignment: Alignment.center,
//             child: Card(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ...[
//                         TextFormField(
//                           decoration: const InputDecoration(
//                             filled: true,
//                             hintText: 'Entre com um nome...',
//                             labelText: 'Nome',
//                           ),
//                           onChanged: (value) {
//                             // setState(() {
//                             //   title = value;
//                             // });
//                           },
//                         ),
//                         TextFormField(
//                           decoration: const InputDecoration(
//                             filled: true,
//                             hintText: 'Entre com a área...',
//                             labelText: 'Área',
//                           ),
//                           onChanged: (value) {
//                             // setState(() {
//                             //   title = value;
//                             // });
//                           },
//                         ),
//                         _FormDatePicker(
//                           date: date,
//                           onChanged: (value) {
//                             // setState(() {
//                             //   date = value;
//                             // });
//                           },
//                         ),
//                         TextButton(
//                           // color: Color(0xFF6200EE),
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Salvar'),
//                         ),
//                       ].expand(
//                         (widget) => [
//                           widget,
//                           const SizedBox(
//                             height: 24,
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _FormDatePicker extends StatefulWidget {
//   final DateTime date;
//   final ValueChanged<DateTime> onChanged;

//   const _FormDatePicker({
//     required this.date,
//     required this.onChanged,
//   });

//   @override
//   _FormDatePickerState createState() => _FormDatePickerState();
// }

// class _FormDatePickerState extends State<_FormDatePicker> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               'Data',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//             Text(
//               intl.DateFormat('dd/MM/yyyy').format(widget.date),
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ],
//         ),
//         TextButton(
//           child: const Icon(Icons.edit_outlined),
//           onPressed: () async {
//             var newDate = await showDatePicker(
//               context: context,
//               initialDate: widget.date,
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );

//             // Don't change the date if the date picker returns null.
//             if (newDate == null) {
//               return;
//             }

//             widget.onChanged(newDate);
//           },
//         )
//       ],
//     );
//   }
// }

class DialogUpdateTeste extends StatefulWidget {
  const DialogUpdateTeste({Key? key, this.codPropriedade, this.nomePropriedade})
      : super(key: key);

  // final Function onChanged;
  final String? codPropriedade;
  final String? nomePropriedade;

  @override
  State<DialogUpdateTeste> createState() => _DialogUpdateTesteState();
}

class _DialogUpdateTesteState extends State<DialogUpdateTeste> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();
  // final _campo = Campo();
  @override
  Widget build(BuildContext context) =>
      // return Scaffold(
      //   appBar: AppBar(
      //     backgroundColor: const Color(0xFF6200EE),
      //     title: Text('Editar propriedade "' + widget.nomePropriedade! + '"'),
      //   ),
      // body:
      AlertDialog(
        title: Text('Editar propriedade "' + widget.nomePropriedade! + '"'),
        content: SizedBox(
          width: 750,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              // padding: const EdgeInsets.all(16),
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
                        setState(() {
                          nome = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com a área...',
                        labelText: 'Área',
                      ),
                      onChanged: (value) {
                        setState(() {
                          area = value;
                        });
                      },
                    ),
                    // _FormDatePicker(
                    //   date: date,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       date = value;
                    //     });
                    //   },
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () async {
                            await updatePropriedade(
                                    nome!, area!, widget.codPropriedade!)
                                .then((_) {
                              var counter = context.read<PropriedadProvider>();
                              var index = counter.listPropriedade.indexWhere(
                                  (_selecionada) =>
                                      _selecionada.codPropriedade ==
                                      counter
                                          .selectedPropriedade!.codPropriedade);

                              counter.selectedPropriedade!.nome = nome!;
                            });
                            // var counter = context.read<PropriedadProvider>();
                            // counter.onChangedFalse();
                            // counter.increment();
                            // counter.toList();
                            Navigator.pop(context);
                          },
                          child: const Text('Confirmar'),
                        ),
                      ],
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
      );
}
