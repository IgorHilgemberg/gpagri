import 'package:flutter/material.dart';
import 'package:login_example/cardss.dart';
import 'package:login_example/campo.dart';
import 'package:login_example/talhao.dart';
import 'package:provider/provider.dart';
import 'package:login_example/dashboard_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

// void main() => runApp(const MyHomePage());

Future<void> insertCampos() async {
  // List<Campo> campos = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query(
      'insert into campos (nome, area, cod_propriedade) values (?, ?, ?)');
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

// //GET all the farm fields
Future<List<Relatorio>> getRelatorios() async {
  List<Relatorio> Relatorios = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var results = await conn.query('select * from propriedade');
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    Relatorios.add(
      Relatorio(
        nome: '${row[2]}',
        area: '${row[0]}',
        codRelatorio: '${row[1]}',
        // cod_campo: '${row[1]}'),
      ),
    );

    // print(campos[0]);
  }
  // await conn.close();
  // print(campos);
  return Relatorios;
}

// // GET all the property fields
// Future<List<Relatorio>> getRelatorios() async {
//   List<Relatorio> Relatorios = [];
//   final conn = await mysqlconnector;
//   // print('Você está aqui!!');

//   //var conn = await MySqlConnection.connect(settings);
//   await Future.delayed(const Duration(seconds: 1));
//   var results = await conn.query('select * from Relatorio');
//   for (var row in results) {
//     // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
//     Relatorios.add(
//       Relatorio(
//         name: '${row[2]}',
//         codRelatorio: '${row[1]}',
//       ),
//     );
//   }
//   // await conn.close();
//   return Relatorios;
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

class DialogUpdadeCampo extends StatefulWidget {
  const DialogUpdadeCampo({Key? key, this.codCampo}) : super(key: key);

  final String? codCampo;

  @override
  State<DialogUpdadeCampo> createState() => _DialogUpdateCampoState();
}

class _DialogUpdateCampoState extends State<DialogUpdadeCampo> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  // final _campo = Campo();
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6200EE),
        title: const Text('Editar campo'),
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
                            // updateCampo(nome!, area!, cod_campo!);
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
          ),
        ),
      ),
    );
  }
}

class TelaRelatorios extends StatefulWidget {
  static const routeName = '/relatorio';
  const TelaRelatorios({Key? key}) : super(key: key);

  @override
  State<TelaRelatorios> createState() => _TelaRelatoriosState();
}

class _TelaRelatoriosState extends State<TelaRelatorios> {
  // late Future<List<Campo>> futureCampo;
  late Future<List<Relatorio>> futureRelatorio;
  // Relatorio? _selectedRelatorio;
  String dropdownValue = 'One';

  @override
  void initState() {
    super.initState();
    futureRelatorio = getRelatorios();
  }

  @override
  Widget build(BuildContext context) {
    // final List<Campo> campos;
    // campos = getCampos() as List<Campo>;
    // final Campo? campo1;
    // campo1 =
    //     const Campo(name: "name", area: "25", codRelatorio: 3, cod_campo: 4);
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
        title: const Text('Relatórios'),
      ),
      body: ListView(
        // scrollDirection: Axis.v,
        padding: const EdgeInsets.all(20.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Expanded(child: Center(child: Text('Propriedade'))),
              Icon(Icons.arrow_right),
              Expanded(child: Center(child: Text('Safra'))),
              Icon(Icons.arrow_right),
              Expanded(child: Center(child: Text('Campo'))),
              Icon(Icons.arrow_right),
              Expanded(child: Center(child: Text('Talhão'))),
            ],
          ),
          const Divider(
            height: 8,
          ),
          Row(
            children: const [
              DropDownPropriedades(),
              Icon(Icons.arrow_right),
              DropDownSafras(),
              Icon(Icons.arrow_right),
              DemoT(),
              Icon(Icons.arrow_right),
              DropDownTalhoes(),
            ],
          ),
          // Center(
          //   child: SizedBox(
          //     // width: 300,
          //     height: 100,
          //     child: InkWell(
          //       onTap: () => {},
          //       child: Card(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10), // if you need this
          //           side: BorderSide(
          //             color: Colors.grey.withOpacity(0.2),
          //             width: 4,
          //           ),
          //         ),
          //         child: Column(children: const [
          //           ListTile(
          //             title: Text('Relatório de safras'),
          //           ),
          //         ]),
          //       ),
          //     ),
          //   ),
          // ),
          Center(
            child: SizedBox(
              // width: 300,

              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 4,
                  ),
                ),
                child: Column(children: [
                  const ListTile(
                    title: Text('Plantios'),
                    subtitle: Text('Registros de plantios'),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.save),
                        label: const Text('Gerar relatório'),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 4,
                  ),
                ),
                child: Column(children: [
                  const ListTile(
                    title: Text('Aplicações'),
                    subtitle: Text('Registros de aplicações'),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.save),
                        label: const Text('Gerar relatório'),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 4,
                  ),
                ),
                child: Column(children: [
                  const ListTile(
                    title: Text('Colheitas'),
                    subtitle: Text('Relatório de colheitas'),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.save),
                        label: const Text('Gerar relatório'),
                      ),
                    ],
                  ),
                ]
                    // child: const Center(
                    //   child: Text(
                    //     'Relatório de colheitas',
                    //   ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
    // );
  }
}

class Relatorio {
  String nome;
  String area;
  String codRelatorio;

  Relatorio(
      {required this.nome, required this.area, required this.codRelatorio});

  // String toString() {
  //   return 'Campo: {nome: $name, area: $area, cod_campo: $cod_campo, codRelatorio: $codRelatorio}';
  // }
}

class RelatorioCard extends StatelessWidget {
  final Relatorio? relatorio;
  const RelatorioCard({this.relatorio, Key? key}) : super(key: key);

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
            onTap: () {},
            leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(relatorio!.nome),
            subtitle: Text(
              'Cod ' +
                  (relatorio!.codRelatorio.toString()) +
                  '  ' +
                  relatorio!.area +
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
          //       // getCampos(codRelatorio: Relatorio!.codRelatorio);
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
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const DialogUpdadeCampo(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: const Icon(Icons.edit),
              ),
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () {
                  deleteCampo(relatorio!.codRelatorio);
                  // Perform some action
                },
                child: const Icon(Icons.delete),
              ),
            ],
          ),
          //Image.asset('assets/card-sample-image.jpg'),
        ],
      ),
    );
  }
}

class FullScreenDialog extends StatefulWidget {
  const FullScreenDialog({Key? key}) : super(key: key);

  @override
  State<FullScreenDialog> createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
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
        title: const Text('Cadastrar novo campo'),
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
