import 'package:flutter/material.dart';
import 'package:login_example/campo.dart';
// import 'package:login_example/cardss.dart';
import 'package:login_example/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

// void main() => runApp(const MyHomePage());

Future<void> insertTalhoes(String? nome, String? area, String? codCampo) async {
  // List<Talhao> Talhoes = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query(
      'insert into Talhao (nome, area, cod_campo) values (?, ?, ?)',
      [nome, area, codCampo]);
  // for (var row in results) {
  //   // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  //   // Talhoes.add(
  //   //   Talhao(
  //   //       name: '${row[2]}',
  //   //       area: '${row[0]}',
  //   //       cod_Campo: '${row[3]}',
  //   //       codTalhao: '${row[1]}'),
  //   // );

  //   // print(Talhoes[0]);
  // }
  // await conn.close();
  // print(Talhoes);
}

// //GET all the farm fields
Future<List<Talhao>> getTalhoes({String? codCampo = ''}) async {
  List<Talhao> talhoes = [];
  final conn = await mysqlconnector;
  if (codCampo == null) {
    return talhoes = [];
  }

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(milliseconds: 400));
  if (codCampo == '') {
    var results = await conn.query('select * from Talhao');
    for (var row in results) {
      print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
      talhoes.add(
        Talhao(
            nome: '${row[1]}',
            area: '${row[0]}',
            codCampo: '${row[3]}',
            codTalhao: '${row[2]}'),
      );

      // print(Talhoes[0]);
    }
  } else {
    var results =
        await conn.query('select * from Talhao where cod_Campo=?', [codCampo]);
    for (var row in results) {
      print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
      talhoes.add(
        Talhao(
            nome: '${row[1]}',
            area: '${row[0]}',
            codCampo: '${row[3]}',
            codTalhao: '${row[2]}'),
      );

      // print(Talhoes[0]);
    }
  }
  // for (var row in results) {
  //   print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  //   Talhoes.add(
  //     Talhao(
  //         name: '${row[2]}',
  //         area: '${row[0]}',
  //         cod_Campo: '${row[3]}',
  //         codTalhao: '${row[1]}'),
  //   );

  // print(Talhoes[0]);

  // await conn.close();
  // print(Talhoes);
  return talhoes;
}

// GET all the property fields
// Future<List<Campo>> getCampos() async {
//   List<Campo> campos = [];
//   final conn = await mysqlconnector;
//   // print('Você está aqui!!');

//   //var conn = await MySqlConnection.connect(settings);
//   await Future.delayed(const Duration(seconds: 1));
//   var results = await conn.query('select * from Campo');
//   for (var row in results) {
//     // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
//     campos.add(
//       Campo(
//         nome: '${row[2]}',
//         codCampo: '${row[1]}',
//       ),
//     );
//   }
//   // await conn.close();
//   return campos;
// }

Future<void> deleteTalhao(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM Talhao WHERE cod_Talhao = ?', [id]);
  } catch (e) {
    print(e);
  }
}

Future<void> updateTalhao(String nome, String area, String id) async {
  final conn = await mysqlconnector;

  var update = await conn.query(
      'update Talhao  set nome=?, area=? WHERE cod_Talhao = ?',
      [nome, area, id]);
}

class DialogUpdateTalhao extends StatefulWidget {
  const DialogUpdateTalhao(
      {Key? key, required this.codTalhao, required this.nomeTalhao})
      : super(key: key);

  final String codTalhao;
  final String nomeTalhao;

  @override
  State<DialogUpdateTalhao> createState() => _DialogUpdateTalhoestate();
}

class _DialogUpdateTalhoestate extends State<DialogUpdateTalhao> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();
  // final _Talhao = Talhao();
  @override
  Widget build(BuildContext context) =>
      // DateTime date = DateTime.now();

      AlertDialog(
        title: Text('Editar Talhao "' + widget.nomeTalhao + '"'),
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
                        updateTalhao(nome!, area!, widget.codTalhao);
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

class TelaTalhoes extends StatefulWidget {
  static const routeName = '/talhao';
  const TelaTalhoes({Key? key}) : super(key: key);

  @override
  State<TelaTalhoes> createState() => _TelaTalhoesState();
}

class _TelaTalhoesState extends State<TelaTalhoes> {
  late Future<List<Talhao>> futureTalhao;
  late Future<List<Campo>> futureCampo;
  Campo? _selectedCampo;
  String dropdownValue = 'One';
  String holder = '';
  bool _update = false;

  @override
  void initState() {
    super.initState();
    futureTalhao = getTalhoes(
        codCampo: context.read<CampoProvider>().selectedCampo?.codCampo);
    futureCampo = getCampos();
  }

  void _handleUpdate() {
    futureTalhao = getTalhoes(
        codCampo: context.read<CampoProvider>().selectedCampo?.codCampo);
    setState(() {});
  }

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final List<Talhao> Talhoes;
    // Talhoes = getTalhoes() as List<Talhao>;
    // final Talhao? Talhao1;
    // Talhao1 =
    //     const Talhao(name: "name", area: "25", cod_Campo: 3, cod_Talhao: 4);
    // var Talhaocard = TalhaoCard(Talhao: Talhao1);
    return
        // MaterialApp(
        //   title: 'Cardss',
        //   theme: ThemeData(
        //     primarySwatch: Colors.blue,
        //   ),
        // home:
        Scaffold(
      appBar: AppBar(
        title: const Text('Talhões'),
      ),
      body: Center(
        child: FutureBuilder<List<Talhao>>(
            future: futureTalhao,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Expanded(child: Center(child: Text('Propriedade'))),
                        Icon(Icons.arrow_right),
                        Expanded(child: Center(child: Text('Campo'))),
                      ],
                    ),
                    const Divider(
                      height: 8,
                    ),
                    Row(
                      children: const [
                        DropDownPropriedades(),
                        Icon(Icons.arrow_right),
                        DemoT(),
                      ],
                    ),
                    Row(
                      children: [
                        Consumer<Counter>(
                          builder: (context, counter, child) => Text(
                            counter.nomePropriedade,
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 1.5),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios),
                        Consumer<CampoProvider>(
                          builder: (context, counter, child) => Text(
                            counter.nomeCampo,
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 1.5),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios),
                        Consumer<TalhaoProvider>(
                          builder: (context, counter, child) => Text(
                            counter.nomeTalhao,
                            style: DefaultTextStyle.of(context)
                                .style
                                .apply(fontSizeFactor: 1.5),
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          //textColor: const Color(0xFF6200EE),
                          onPressed: () {
                            // Perform some action
                            Navigator.pushNamed((context), '/safra');
                            // getCampos(codPropriedade: propriedade!.Aplicacao);
                          },
                          label: const Text('Ver Safras'),
                          icon: const Icon(Icons.remove_red_eye),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     FutureBuilder<List<Campo>>(
                        //         future: futureCampo,
                        //         builder: (context, propr) {
                        //           if (propr.hasData) {
                        //             return DropdownButton<Campo>(
                        //               hint: const Text('Escolha a Campo'),
                        //               value: _selectedCampo,
                        //               icon: const Icon(Icons.arrow_downward),
                        //               elevation: 16,
                        //               style: const TextStyle(
                        //                   color: Colors.deepPurple),
                        //               underline: Container(
                        //                 height: 2,
                        //                 color: Colors.deepPurpleAccent,
                        //               ),
                        //               onChanged: (Campo? newValue) {
                        //                 setState(() {
                        //                   _selectedCampo = newValue!;
                        //                 });
                        //               },
                        //               items: propr.data
                        //                   ?.map<DropdownMenuItem<Campo>>(
                        //                       (Campo value) {
                        //                 return DropdownMenuItem<Campo>(
                        //                   value: value,
                        //                   child: Text(value.codCampo +
                        //                       ' ' +
                        //                       value.nome),
                        //                   onTap: () {
                        //                     futureTalhao = getTalhoes(
                        //                         codCampo: value.codCampo);
                        //                     print(value.codCampo);
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
                        ...?snapshot.data?.map((d) => snapshot.data != null
                            ? TalhaoCard(talhao: d, onChanged: _handleUpdate)
                            : const Center(
                                child: Text('Nenhum campo selecionado!'),
                              )),
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
        onPressed: () async {
          if (context.read<CampoProvider>().selectedCampo != null) {
            await showDialog(
              context: context,
              builder: (context) => DialogAddTalhao(
                onChanged: _handleUpdate,
                codCampo: context.read<CampoProvider>().selectedCampo?.codCampo,
                nome: context.read<CampoProvider>().selectedCampo?.nome,
                CampoSelecionada: context.read<CampoProvider>().selectedCampo,
              ),
              // fullscreenDialog: true,
            );
          } else {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Selecione uma Campo:'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('Você deve selecionar uma Campo no menu!'),
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

class Talhao {
  String nome;
  String area;
  String codCampo;
  String codTalhao;

  Talhao(
      {required this.nome,
      required this.area,
      required this.codCampo,
      required this.codTalhao});

  String getCodTalhao() {
    return codTalhao;
  }

  // String toString() {
  //   return 'Talhao: {nome: $nome, area: $area, cod_Talhao: $cod_Talhao, cod_Campo: $cod_Campo}';
  // }
}

// class Campo {
//   final String nome;
//   final String codCampo;

//   const Campo({required this.nome, required this.codCampo});

//   // String toString() {
//   //   return 'Talhao: {nome: $name, area: $area, cod_Talhao: $cod_Talhao, cod_Campo: $cod_Campo}';
//   // }
// }

class TalhaoCard extends StatelessWidget {
  final Talhao? talhao;
  // final String onChanded;

  final Function onChanged;

  const TalhaoCard({this.talhao, required this.onChanged, Key? key})
      : super(key: key);

//   @override
//   State<TalhaoCard> createState() => _TalhaoCardState();
// }

// class _TalhaoCardState extends State<TalhaoCard> {
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
            //   var counter = context.read<TalhaoProvider>();
            //   counter.increment(talhao!.nome, talhao!.codTalhao);
            // },
            leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(talhao!.nome),
            subtitle: Text(
              'Cod ' +
                  (talhao!.codTalhao.toString()) +
                  '  ' +
                  talhao!.area +
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
                    builder: (context) => DialogUpdateTalhao(
                      codTalhao: talhao!.codTalhao,
                      nomeTalhao: talhao!.nome,
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
                  await deleteTalhao(talhao!.codTalhao);

                  // print('Voce esta aqui');
                  onChanged();

                  // _TelaTalhoesState().futureTalhao =
                  //     getTalhoes(codCampo: Talhao!.cod_Campo);
                  // Navigator.pop(context);
                  // Navigator.pushNamed(context, '/Talhao');
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

class DialogAddTalhao extends StatefulWidget {
  const DialogAddTalhao(
      {Key? key,
      required this.codCampo,
      required this.nome,
      required this.CampoSelecionada,
      required this.onChanged})
      : super(key: key);

  final Function onChanged;
  final String? codCampo;
  final String? nome;
  final Campo? CampoSelecionada;

  @override
  State<DialogAddTalhao> createState() => _DialogAddTalhaoState();
}

class _DialogAddTalhaoState extends State<DialogAddTalhao> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) =>
      // final _formKey = GlobalKey<FormState>();
      AlertDialog(
        title: Text('Cadastrar novo talhao em "' + widget.nome! + '"'),
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
                      onPressed: () async {
                        await insertTalhoes(nome, area, widget.codCampo)
                            .then((_) {
                          widget.onChanged();
                        });

                        Navigator.pop(context);
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

class TalhaoProvider with ChangeNotifier {
  // late Future<List<Talhao>> futureTalhao;
  // List<Talhao> listTalhao = [];
  String codTalhao = '';
  String nomeTalhao = '';
  bool emptyField = false;
  Talhao? selectedTalhao;

  // void toList() async {
  //   listTalhao = await futureTalhao;
  //   notifyListeners();
  // }

  void getSelected(Talhao? talhao) {
    selectedTalhao = talhao;
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
    nomeTalhao = nome;
    codTalhao = cod;
    notifyListeners();
  }
}
