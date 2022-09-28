import 'package:flutter/material.dart';
import 'package:login_example/cardss.dart';
import 'package:login_example/propriedade.dart';
import 'package:provider/provider.dart';
import 'package:login_example/talhao.dart';
import 'package:login_example/propriedade.dart';
import 'package:login_example/dashboard_screen.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

// void main() => runApp(const MyHomePage());

Future<void> insertCampos(
    String? nome, String? area, String codPropriedade) async {
  // List<Campo> campos = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query(
      'insert into campo (nome, area, cod_propriedade) values (?, ?, ?)',
      [nome, area, codPropriedade]);
}

// //GET all the farm fields
Future<List<Campo>> getCampos({String? codPropriedade = ''}) async {
  List<Campo> campos = [];
  final conn = await mysqlconnector;
  if (codPropriedade == null) {
    return campos;
  }

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(milliseconds: 400));
  if (codPropriedade == '') {
    var results = await conn.query('select * from campo');
    for (var row in results) {
      // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
      campos.add(
        Campo(
            nome: '${row[2]}',
            area: '${row[0]}',
            codPropriedade: '${row[3]}',
            codCampo: '${row[1]}'),
      );

      // print(campos[0]);
    }
  } else {
    var results = await conn
        .query('select * from campo where cod_propriedade=?', [codPropriedade]);
    for (var row in results) {
      // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
      campos.add(
        Campo(
            nome: '${row[2]}',
            area: '${row[0]}',
            codPropriedade: '${row[3]}',
            codCampo: '${row[1]}'),
      );

      // print(campos[0]);
    }
  }
  // for (var row in results) {
  //   print('nome: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  //   campos.add(
  //     Campo(
  //         nome: '${row[2]}',
  //         area: '${row[0]}',
  //         codPropriedade: '${row[3]}',
  //         codCampo: '${row[1]}'),
  //   );

  // print(campos[0]);

  // await conn.close();
  // print(campos);
  return campos;
}

// GET all the property fields
// Future<List<Propriedade>> getPropriedades() async {
//   List<Propriedade> propriedades = [];
//   final conn = await mysqlconnector;
//   // print('Você está aqui!!');

//   //var conn = await MySqlConnection.connect(settings);
//   await Future.delayed(const Duration(seconds: 1));
//   var results = await conn.query('select * from propriedade');
//   for (var row in results) {
//     // print('nome: ${row[0]}, email: ${row[1]} age: ${row[2]}');
//     propriedades.add(
//       Propriedade(
//           nome: '${row[2]}', codPropriedade: '${row[1]}', area: '${row[0]}'),
//     );
//   }
//   // await conn.close();
//   return propriedades;
// }

Future<void> deleteCampo(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM campo WHERE cod_campo = ?', [id]);
  } catch (e) {
    print(e);
  }
}

Future<void> updateCampo(String nome, String area, String id) async {
  final conn = await mysqlconnector;

  var update = await conn.query(
      'update campo  set nome=?, area=? WHERE cod_campo = ?', [nome, area, id]);
}

class DialogUpdateCampo extends StatefulWidget {
  const DialogUpdateCampo(
      {Key? key, required this.codCampo, required this.nomeCampo})
      : super(key: key);

  // final Function onChanged;
  final String codCampo;
  final String nomeCampo;

  @override
  State<DialogUpdateCampo> createState() => _DialogUpdateCampoState();
}

class _DialogUpdateCampoState extends State<DialogUpdateCampo> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();
  // final _campo = Campo();
  @override
  Widget build(BuildContext context)
      // DateTime date = DateTime.now();

      =>
      AlertDialog(
        title: Text('Editar campo "' + widget.nomeCampo + '"'),
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
                      onPressed: () {
                        updateCampo(nome!, area!, widget.codCampo);
                        Navigator.pop(context);
                        // setState(() {});
                      },
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
      );
}

class TelaCampos extends StatefulWidget {
  static const routeName = '/campo';
  const TelaCampos({Key? key}) : super(key: key);

  @override
  State<TelaCampos> createState() => _TelaCamposState();
}

class _TelaCamposState extends State<TelaCampos> {
  late Future<List<Campo>> futureCampo;
  late Future<List<Propriedade>> futurePropriedade;
  Propriedade? _selectedPropriedade;
  String dropdownValue = 'One';
  String holder = '';
  bool _update = false;

  @override
  void initState() {
    super.initState();
    futureCampo = getCampos(
        codPropriedade: context
            .read<PropriedadProvider>()
            .selectedPropriedade
            ?.codPropriedade);
    futurePropriedade = getPropriedades();
  }

  void _handleUpdate() {
    futureCampo = getCampos(
        codPropriedade: context
            .read<PropriedadProvider>()
            .selectedPropriedade
            ?.codPropriedade);
    setState(() {});
  }

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final List<Campo> campos;
    // campos = getCampos() as List<Campo>;
    // final Campo? campo1;
    // campo1 =
    //     const Campo(name: "name", area: "25", codPropriedade: 3, codCampo: 4);
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
        title: const Text('Campos'),
      ),
      body: Center(
        child: FutureBuilder<List<Campo>>(
            future: futureCampo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    // Row(
                    //   children: [
                    //     Text('Campos pertencentes à "' +
                    //         context.read<PropriedadProvider>().nomePropriedade +
                    //         '"'),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Consumer<Counter>(
                    //       builder: (context, counter, child) => Text(
                    //         counter.nomePropriedade,
                    //         style: DefaultTextStyle.of(context)
                    //             .style
                    //             .apply(fontSizeFactor: 1.5),
                    //       ),
                    //     ),
                    //     const Icon(Icons.arrow_forward_ios),
                    //     Consumer<CampoProvider>(
                    //       builder: (context, counter, child) => Text(
                    //         counter.nomeCampo,
                    //         style: DefaultTextStyle.of(context)
                    //             .style
                    //             .apply(fontSizeFactor: 1.5),
                    //       ),
                    //     ),
                    //     const Icon(Icons.arrow_forward_ios),
                    //     Consumer<TalhaoProvider>(
                    //       builder: (context, counter, child) => Text(
                    //         counter.nomeTalhao,
                    //         style: DefaultTextStyle.of(context)
                    //             .style
                    //             .apply(fontSizeFactor: 1.5),
                    //       ),
                    //     ),
                    //     const Spacer(),
                    //     TextButton.icon(
                    //       //textColor: const Color(0xFF6200EE),
                    //       onPressed: () {
                    //         // Perform some action
                    //         Navigator.pushNamed((context), '/talhao');
                    //         // getCampos(codPropriedade: propriedade!.Aplicacao);
                    //       },
                    //       label: const Text('Ver talhões'),
                    //       icon: const Icon(Icons.remove_red_eye),
                    //     ),
                    //   ],
                    // ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            DropDownPropriedades(),
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
                            //                   value.nome),
                            //               onTap: () {
                            //                 futureCampo = getCampos(
                            //                     codPropriedade:
                            //                         value.codPropriedade);
                            //                 // print(value.codPropriedade);
                            //               },
                            //             );
                            //           }).toList(),
                            //         );
                            //       } else if (propr.hasError) {
                            //         return Text('${propr.error}');
                            //       }
                            //       return const CircularProgressIndicator();
                            //     }),
                          ],
                        ),
                        ...?snapshot.data?.map((d) =>
                            CampoCard(campo: d, onChanged: _handleUpdate)),
                      ],
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo campo',
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () async {
          if (context.read<PropriedadProvider>().selectedPropriedade != null) {
            await showDialog(
              context: context,
              builder: (context) => DialogAddCampo(
                // codPropriedade: ,
                onChanged: _handleUpdate,
                codPropriedade: context
                    .read<PropriedadProvider>()
                    .selectedPropriedade!
                    .codPropriedade,
                nome: context
                    .read<PropriedadProvider>()
                    .selectedPropriedade!
                    .nome,
                propriedadeSelecionada: _selectedPropriedade,
              ),
            );
            // .then((_) {
            //   setState(() {});
            // });
          } else {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Selecione uma propriedade:'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('Você deve selecionar uma propriedade no menu!'),
                        // Text('Would you like to approve of this message?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
    // );
  }
}

class Campo {
  String nome;
  String area;
  String codPropriedade;
  String codCampo;

  Campo(
      {required this.nome,
      required this.area,
      required this.codPropriedade,
      required this.codCampo});

  String getCodCampo() {
    return codCampo;
  }

  // String toString() {
  //   return 'Campo: {nome: $nome, area: $area, codCampo: $codCampo, codPropriedade: $codPropriedade}';
  // }
}

// class Propriedade {
//   final String nome;
//   final String codPropriedade;

//   const Propriedade({required this.nome, required this.codPropriedade});

//   // String toString() {
//   //   return 'Campo: {nome: $nome, area: $area, codCampo: $codCampo, codPropriedade: $codPropriedade}';
//   // }
// }

class CampoCard extends StatelessWidget {
  final Campo? campo;
  // final String onChanded;

  final Function onChanged;

  const CampoCard({this.campo, required this.onChanged, Key? key})
      : super(key: key);

//   @override
//   State<CampoCard> createState() => _CampoCardState();
// }

// class _CampoCardState extends State<CampoCard> {
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
            // onTap: ()
            //     // {
            //     //   var counter = context.read<CampoProvider>();
            //     //   counter.increment(campo!.nome, campo!.codCampo);
            //     // },
            //     {
            //   var campoProvider = context.read<CampoProvider>();
            //   var talhao = context.read<TalhaoProvider>();
            //   if (talhao.nomeTalhao == '') {
            //     campoProvider.increment(campo!.nome, campo!.codCampo);
            //   } else if (campo!.nome != campoProvider.nomeCampo) {
            //     campoProvider.increment(campo!.nome, campo!.codCampo);
            //     talhao.increment('', '');
            //   }
            // },
            leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(campo!.nome),
            subtitle: Text(
              'Cod ' +
                  (campo!.codCampo.toString()) +
                  '  ' +
                  campo!.area +
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
                    builder: (context) => DialogUpdateCampo(
                      codCampo: campo!.codCampo,
                      nomeCampo: campo!.nome,
                      // onChanged: _handleUpdate,
                    ),
                    // fullscreenDialog: true,
                  ).then((_) {
                    // print('Voce esta aqui');
                    onChanged();
                  });
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
              ),
              TextButton.icon(
                //textColor: const Color(0xFF6200EE),
                onPressed: () async {
                  await deleteCampo(campo!.codCampo);

                  // print('Voce esta aqui');
                  onChanged();

                  // _TelaCamposState().futureCampo =
                  //     getCampos(codPropriedade: campo!.codPropriedade);
                  // Navigator.pop(context);
                  // Navigator.pushnomed(context, '/campo');
                  // Perform some action
                },
                icon: const Icon(Icons.delete),
                label: const Text('Excluir'),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
          //Image.asset('assets/card-sample-image.jpg'),
        ],
      ),
    );
  }
}

class DialogAddCampo extends StatefulWidget {
  const DialogAddCampo(
      {Key? key,
      required this.codPropriedade,
      required this.onChanged,
      required this.nome,
      required this.propriedadeSelecionada})
      : super(key: key);

  final String codPropriedade;
  final Function onChanged;
  final String nome;
  final Propriedade? propriedadeSelecionada;

  @override
  State<DialogAddCampo> createState() => _DialogAddCampoState();
}

class _DialogAddCampoState extends State<DialogAddCampo> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) =>
      // final _formKey = GlobalKey<FormState>();
      AlertDialog(
        title: Text('Cadastrar novo campo em "' + widget.nome + '"'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Descartar'),
                        ),
                        ElevatedButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () async {
                            await insertCampos(
                                    nome, area, widget.codPropriedade)
                                .then((_) {
                              widget.onChanged();
                              // context.read<PropriedadProvider>().toListCampo();
                            });

                            Navigator.pop(context);
                          },

                          child: const Text('Salvar'),
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

class CampoProvider with ChangeNotifier {
  late Future<List<Talhao>> futureTalhao;
  List<Talhao> listTalhao = [];
  String codCampo = '';
  String nomeCampo = '';
  bool emptyField = false;
  Campo? selectedCampo;

  // void toList() async {
  //   listTalhao = await futureTalhao;
  //   notifyListeners();
  // }

  void emptyFieldFuntion() {
    selectedCampo = null;
    notifyListeners();
  }

  void getSelected(Campo? campo) {
    selectedCampo = campo;
    notifyListeners();
  }

  void toList() async {
    listTalhao = await futureTalhao;
    notifyListeners();
  }

  void emptyList() {
    listTalhao = [];
    notifyListeners();
  }

  void onChangedTrue() {
    emptyField = true;
    notifyListeners();
  }

  void onChangedFalse() {
    emptyField = false;
    // listTalhao = [];
    notifyListeners();
  }

  void increment(String nome, String cod) {
    nomeCampo = nome;
    codCampo = cod;
    futureTalhao = getTalhoes(codCampo: cod);
    notifyListeners();
  }
}
