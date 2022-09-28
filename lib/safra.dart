import 'package:flutter/material.dart';
import 'package:login_example/campo.dart';
import 'package:login_example/cardss.dart';
import 'package:login_example/propriedade.dart';
import 'package:login_example/dashboard_screen.dart';
import 'package:login_example/talhao.dart';
import 'package:provider/provider.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

// void main() => runApp(const MyHomePage());

Future<void> insertSafras(String? nome, String codPropriedade,
    DateTime dataInicio, DateTime dataFim) async {
  // List<Campo> Safras = [];
  var dataInicioFormatada = intl.DateFormat('yyyy-MM-dd').format(dataInicio);
  var dataFimFormatada = intl.DateFormat('yyyy-MM-dd').format(dataFim);
  final conn = await mysqlconnector;

  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query(
      'insert into safra (cod_propriedade,nome, data_inicio, data_fim) values (?, ?, ?, ?)',
      [codPropriedade, nome, dataInicioFormatada, dataFimFormatada]);
}

Future<void> updateSafra(
    String nome, DateTime dataInicio, DateTime dataFim, String codSafra) async {
  final conn = await mysqlconnector;
  var dataInicioFormatada = intl.DateFormat('yyyy-MM-dd').format(dataInicio);
  var dataFimFormatada = intl.DateFormat('yyyy-MM-dd').format(dataFim);
  var update = await conn.query(
      'update safra  set nome=?, data_inicio=?, data_fim=? WHERE cod_safra = ?',
      [nome, dataInicioFormatada, dataFimFormatada, codSafra]);
}

// //GET all the farm fields
Future<List<Safra>> getSafras({String? codPropriedade = ''}) async {
  List<Safra> safras = [];
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  // if (codPropriedade == '') {
  //   var results = await conn.query(
  //       '''select safra.data_fim,safra.data_inicio,safra.nome,
  //                   safra.cod_safra,safra.cod_propriedade,propriedade.nome from safra
  //                   JOIN propriedade ON propriedade.cod_propriedade=?''',
  //       [codPropriedade]);
  //   for (var row in results) {
  //     print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  //     safras.add(
  //       Safra(
  //         nome: '${row[2]}',
  //         codSafra: '${row[3]}',
  //         nomePropriedade: '${row[5]}',
  //         codPropriedade: '${row[4]}',
  //         dataInicio: '${row[1]}',
  //         dataFim: '${row[0]}',
  //       ),
  //     );
  //     // print(Safras[0]);
  //   }
  // } else {
  var results =
      await conn.query('''select safra.data_fim,safra.data_inicio,safra.nome,
                    safra.cod_safra,safra.cod_propriedade,propriedade.nome from safra 
                    JOIN propriedade ON safra.cod_propriedade=propriedade.cod_propriedade
                    where safra.cod_propriedade=?''', [codPropriedade]);
  for (var row in results) {
    print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    safras.add(
      Safra(
        nome: '${row[2]}',
        codSafra: '${row[3]}',
        nomePropriedade: '${row[5]}',
        dataInicio: '${row[1]}',
        dataFim: '${row[0]}',
      ),
    );
  }

  print(safras);
  return safras;
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
//         cod_propriedade: '${row[1]}',
//       ),
//     );
//   }
//   // await conn.close();
//   return propriedades;
// }

Future<void> deleteSafra(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM safra WHERE cod_safra = ?', [id]);
  } catch (e) {
    print(e);
  }
}

Future<void> updateCampo(String nome, String area, String id) async {
  final conn = await mysqlconnector;

  var update = await conn.query(
      'update campo  set nome=?, area=? WHERE cod_campo = ?', [nome, area, id]);
}

class DialogUpdateSafra extends StatefulWidget {
  const DialogUpdateSafra(
      {Key? key, required this.codSafra, required this.nomeSafra})
      : super(key: key);

  final String codSafra;
  final String nomeSafra;

  @override
  State<DialogUpdateSafra> createState() => _DialogUpdateSafrastate();
}

class _DialogUpdateSafrastate extends State<DialogUpdateSafra> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();
  // final _campo = Campo();
  @override
  Widget build(BuildContext context) =>
      // DateTime date = DateTime.now();

      AlertDialog(
        title: Text('Editar safra "' + widget.nomeSafra + '"'),
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
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //     filled: true,
                    //     hintText: 'Entre com a área...',
                    //     labelText: 'Área',
                    //   ),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       area = value;
                    //     });
                    //   },
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FormDatePicker(
                          date: date,
                          epoca: 'início',
                          onChanged: (value) {
                            setState(() {
                              date = value;
                            });
                          },
                        ),
                        _FormDatePicker(
                          date: date,
                          epoca: 'fim',
                          onChanged: (value) {
                            setState(() {
                              date = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () {
                            updateSafra(nome!, date, date, widget.codSafra);
                            Navigator.pop(context);
                            // setState(() {});
                          },
                          child: const Text('Salvar alterações'),
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

class TelaSafras extends StatefulWidget {
  static const routeName = '/safra';
  const TelaSafras({Key? key}) : super(key: key);

  @override
  State<TelaSafras> createState() => _TelaSafrasState();
}

class _TelaSafrasState extends State<TelaSafras> {
  late Future<List<Safra>> futureSafra;
  late Future<List<Propriedade>> futurePropriedade;
  Propriedade? _selectedPropriedade;
  String dropdownValue = 'One';
  String holder = '';
  bool _update = false;

  @override
  void initState() {
    super.initState();
    futureSafra = getSafras(
        codPropriedade: context
            .read<PropriedadProvider>()
            .selectedPropriedade
            ?.codPropriedade);
    futurePropriedade = getPropriedades();
  }

  void _handleUpdate() {
    futureSafra = getSafras(
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
    // final List<Campo> Safras;
    // Safras = getSafras() as List<Campo>;
    // final Campo? campo1;
    // campo1 =
    //     const Campo(name: "name", area: "25", cod_propriedade: 3, cod_campo: 4);
    // var SafraCard = SafraCard(campo: campo1);
    return
        // MaterialApp(
        //   title: 'Cardss',
        //   theme: ThemeData(
        //     primarySwatch: Colors.blue,
        //   ),
        // home:
        Scaffold(
      appBar: AppBar(
        title: const Text('Safras'),
      ),
      body: Center(
        child: FutureBuilder<List<Safra>>(
            future: futureSafra,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Row(
                      children: const [
                        DropDownPropriedades(),
                      ],
                    ),
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
                    //     const Icon(Icons.arrow_forward_ios),
                    //     Consumer<SafraProvider>(
                    //       builder: (context, counter, child) => Text(
                    //         counter.nomeSafra,
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
                    //         Navigator.pushNamed((context), '/safra');
                    //         // getCampos(codPropriedade: propriedade!.Aplicacao);
                    //       },
                    //       label: const Text('Ver Atividades'),
                    //       icon: const Icon(Icons.remove_red_eye),
                    //     )
                    //   ],
                    // ),
                    Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     FutureBuilder<List<Propriedade>>(
                        //         future: futurePropriedade,
                        //         builder: (context, propr) {
                        //           if (propr.hasData) {
                        //             return DropdownButton<Propriedade>(
                        //               hint: const Text('Escolha a propriedade'),
                        //               value: _selectedPropriedade,
                        //               icon: const Icon(Icons.arrow_downward),
                        //               elevation: 16,
                        //               style: const TextStyle(
                        //                   color: Colors.deepPurple),
                        //               underline: Container(
                        //                 height: 2,
                        //                 color: Colors.deepPurpleAccent,
                        //               ),
                        //               onChanged: (Propriedade? newValue) {
                        //                 setState(() {
                        //                   _selectedPropriedade = newValue!;
                        //                 });
                        //               },
                        //               items: propr.data
                        //                   ?.map<DropdownMenuItem<Propriedade>>(
                        //                       (Propriedade value) {
                        //                 return DropdownMenuItem<Propriedade>(
                        //                   value: value,
                        //                   child: Text(value.codPropriedade +
                        //                       ' ' +
                        //                       value.nome),
                        //                   onTap: () {
                        //                     futureSafra = getSafras(
                        //                         codPropriedade:
                        //                             value.codPropriedade);
                        //                     print(value.codPropriedade);
                        //                   },
                        //                 );
                        //               }).toList(),
                        //             );
                        //           } else if (propr.hasError) {
                        //             return Text('${propr.error}');
                        //           }
                        //           return const CircularProgressIndicator();
                        //         }),
                        //   ],
                        // ),
                        ...?snapshot.data?.map((d) =>
                            SafraCard(safra: d, onChanged: _handleUpdate)),
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
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        tooltip: 'Nova safra',
        onPressed: () async {
          if (context.read<PropriedadProvider>().selectedPropriedade != null) {
            await showDialog(
              context: context,
              builder: (context) => DialogAddSafra(
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
                propriedadeSelecionada:
                    context.read<PropriedadProvider>().selectedPropriedade,
              ),
            );
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

class Safra {
  String nome;
  String codSafra;
  String? codPropriedade;
  String? nomePropriedade;
  String? dataInicio;
  String? dataFim;

  Safra({
    required this.nome,
    required this.codSafra,
    this.codPropriedade,
    this.nomePropriedade,
    this.dataInicio,
    this.dataFim,
  });
}

// class Campo {
//   String name;
//   String area;
//   String cod_propriedade;
//   String cod_campo;

//   Campo(
//       {required this.name,
//       required this.area,
//       required this.cod_propriedade,
//       required this.cod_campo});

//   String getcodSafra() {
//     return cod_campo;
//   }

//   // String toString() {
//   //   return 'Campo: {nome: $name, area: $area, cod_campo: $cod_campo, cod_propriedade: $cod_propriedade}';
//   // }
// }

// class Propriedade {
//   final String name;
//   final String cod_propriedade;

//   const Propriedade({required this.name, required this.cod_propriedade});

//   // String toString() {
//   //   return 'Campo: {nome: $name, area: $area, cod_campo: $cod_campo, cod_propriedade: $cod_propriedade}';
//   // }
// }

class SafraCard extends StatelessWidget {
  final Safra? safra;
  // final String onChanded;

  final Function onChanged;

  const SafraCard({this.safra, required this.onChanged, Key? key})
      : super(key: key);

//   @override
//   State<SafraCard> createState() => _SafraCardState();
// }

// class _SafraCardState extends State<SafraCard> {
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
            //   var counter = context.read<SafraProvider>();
            //   counter.increment(safra!.nome, safra!.codSafra);
            // },
            leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(safra!.nome),
            subtitle: Text(
              'Cod ' + (safra!.codSafra.toString()),
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),

          Row(
            children: <Widget>[
              Expanded(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: const TextStyle(
                      // fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                          text: 'Propriedade: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: safra!.nomePropriedade,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            height: 8,
          ),
          Row(
            children: const <Widget>[
              Expanded(
                child: Text(
                  'Data de início',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Expanded(
              //   child:
              //       Text('Craft beautiful UIs', textAlign: TextAlign.center),
              // ),
              Expanded(
                child: Text(
                  'Data de término',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(safra!.dataInicio!, textAlign: TextAlign.center),
              ),
              // Expanded(
              //   child:
              //       Text('Craft beautiful UIs', textAlign: TextAlign.center),
              // ),
              Expanded(
                child: Text(safra!.dataFim!, textAlign: TextAlign.center),
              ),
            ],
          ),

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
                  await showDialog(
                    context: context,
                    builder: (context) => DialogUpdateSafra(
                      codSafra: safra!.codSafra,
                      nomeSafra: safra!.nome,
                    ),
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
                  await deleteSafra(safra!.codSafra);

                  // print('Voce esta aqui');
                  onChanged();

                  // _TelaSafrasState().futureCampo =
                  //     getSafras(codPropriedade: campo!.cod_propriedade);
                  // Navigator.pop(context);
                  // Navigator.pushNamed(context, '/campo');
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

class DialogAddSafra extends StatefulWidget {
  const DialogAddSafra(
      {Key? key,
      required this.codPropriedade,
      required this.nome,
      required this.onChanged,
      required this.propriedadeSelecionada})
      : super(key: key);

  final String codPropriedade;
  final String nome;
  final Propriedade? propriedadeSelecionada;
  final Function onChanged;

  @override
  State<DialogAddSafra> createState() => _DialogAddSafraState();
}

class _DialogAddSafraState extends State<DialogAddSafra> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) =>
      // final _formKey = GlobalKey<FormState>();
      AlertDialog(
        title: Text('Cadastrar nova safra em "' + widget.nome + '"'),
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
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //     filled: true,
                    //     hintText: 'Entre com a área...',
                    //     labelText: 'Área',
                    //   ),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       area = value;
                    //     });
                    //   },
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FormDatePicker(
                          date: date,
                          epoca: 'início',
                          onChanged: (value) {
                            setState(() {
                              date = value;
                            });
                          },
                        ),
                        _FormDatePicker(
                          date: date,
                          epoca: 'fim',
                          onChanged: (value) {
                            setState(() {
                              date = value;
                            });
                          },
                        ),
                      ],
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
                            await insertSafras(
                                    nome!, widget.codPropriedade, date, date)
                                .then((_) {
                              widget.onChanged();
                            });
                            // print(date.toString());
                            Navigator.pop(context);
                            // setState(() {});
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
  final String? epoca;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
    this.epoca = '',
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Data ' + widget.epoca!,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              intl.DateFormat('dd/MM/yyyy').format(widget.date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        TextButton(
          child: const Icon(Icons.edit_outlined),
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

class SafraProvider with ChangeNotifier {
  late Future<List<Safra>> futureSafra = getSafras();
  List<Safra> listSafra = [];
  bool emptyField = true;
  String codSafra = '';
  String nomeSafra = '';
  Safra? selectedSafra;

  // void toList() async {
  //   listTalhao = await futureTalhao;
  //   notifyListeners();
  // }
  void emptyList() {
    listSafra = [];
    notifyListeners();
  }

  void getSelected(Safra? safra) {
    selectedSafra = safra;
    notifyListeners();
  }

  void toList() async {
    listSafra = await futureSafra;
    notifyListeners();
  }

  void onChangedTrue() {
    emptyField = true;
    notifyListeners();
  }

  void onChangedFalse() {
    emptyField = false;
    notifyListeners();
  }

  void increment(String nome, String cod) {
    nomeSafra = nome;
    codSafra = cod;
    futureSafra = getSafras(codPropriedade: cod);
    notifyListeners();
  }
}
