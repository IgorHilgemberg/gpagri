import 'package:flutter/material.dart';
import 'package:login_example/cardss.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

// void main() => runApp(const MyHomePage());

Future<void> insertCulturas(String? nome) async {
  // List<Cultura> Culturas = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var insert =
      await conn.query('insert into cultura (nome) values (?)', [nome]);
  // for (var row in results) {
  //   // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  //   // Culturas.add(
  //   //   Cultura(
  //   //       name: '${row[2]}',
  //   //       area: '${row[0]}',
  //   //       cod_propriedade: '${row[3]}',
  //   //       cod_Cultura: '${row[1]}'),
  //   // );

  //   // print(Culturas[0]);
  // }
  // await conn.close();
  // print(Culturas);
}

// //GET all the farm fields
Future<List<Cultura>> getCulturas() async {
  List<Cultura> culturas = [];
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));

  var results = await conn.query('select * from cultura');
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]}');
    culturas.add(Cultura(
      nome: '${row[1]}',
      codCultura: '${row[0]}',
    ));
  }

  return culturas;
}

Future<void> deleteCultura(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM cultura WHERE cod_cultura = ?', [id]);
  } catch (e) {
    print(e);
  }
}

Future<void> updateCultura(String nome, String id) async {
  final conn = await mysqlconnector;

  var update = await conn
      .query('update cultura  set nome=? WHERE cod_cultura = ?', [nome, id]);
}

class DialogUpdateCultura extends StatefulWidget {
  const DialogUpdateCultura(
      {Key? key, required this.codCultura, required this.nomeCultura})
      : super(key: key);

  final String codCultura;
  final String nomeCultura;

  @override
  State<DialogUpdateCultura> createState() => _DialogUpdateCulturaState();
}

class _DialogUpdateCulturaState extends State<DialogUpdateCultura> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();
  // final _Cultura = Cultura();
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Editar cultura "' + widget.nomeCultura + '"'),
        content: SizedBox(
          width: 750,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                            updateCultura(nome!, widget.codCultura);
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

class TelaCulturas extends StatefulWidget {
  static const routeName = '/cultura';
  const TelaCulturas({Key? key}) : super(key: key);

  @override
  State<TelaCulturas> createState() => _TelaCulturasState();
}

class _TelaCulturasState extends State<TelaCulturas> {
  late Future<List<Cultura>> futureCultura;
  // late Future<List<Propriedade>> futurePropriedade;
  // Propriedade? _selectedPropriedade;
  String dropdownValue = 'One';
  String holder = '';
  bool _update = false;

  @override
  void initState() {
    super.initState();
    futureCultura = getCulturas();
  }

  void _handleUpdate() {
    futureCultura = getCulturas();
    setState(() {});
  }

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Culturas'),
      ),
      body: Center(
        child: FutureBuilder<List<Cultura>>(
            future: futureCultura,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Column(
                      children: [
                        ...?snapshot.data?.map((d) =>
                            CulturaCard(cultura: d, onChanged: _handleUpdate)),
                      ],
                    ),
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
          await showDialog(
            context: context,
            builder: (context) => DialogAddCultura(
              onChanged: _handleUpdate,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
    // );
  }
}

class Cultura {
  String nome;
  String codCultura;

  Cultura({
    required this.nome,
    required this.codCultura,
  });
}

class CulturaCard extends StatelessWidget {
  final Cultura? cultura;
  // final String onChanded;

  final Function onChanged;

  const CulturaCard({this.cultura, required this.onChanged, Key? key})
      : super(key: key);

//   @override
//   State<CulturaCard> createState() => _CulturaCardState();
// }

// class _CulturaCardState extends State<CulturaCard> {
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
            // leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(cultura!.nome),
            // subtitle: Text(
            //   'Cod ' + (cultura!.codCultura.toString()),
            //   style: TextStyle(color: Colors.black.withOpacity(0.6)),
            // ),
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
                    builder: (context) => DialogUpdateCultura(
                      codCultura: cultura!.codCultura,
                      nomeCultura: cultura!.nome,
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
                  await deleteCultura(cultura!.codCultura);

                  // print('Voce esta aqui');
                  onChanged();

                  // _TelaCulturasState().futureCultura =
                  //     getCulturas(codPropriedade: Cultura!.cod_propriedade);
                  // Navigator.pop(context);
                  // Navigator.pushNamed(context, '/Cultura');
                  // Perform some action
                },
                label: const Text('Excluir'),
                icon: const Icon(Icons.delete),
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

class DialogAddCultura extends StatefulWidget {
  const DialogAddCultura({Key? key, required this.onChanged}) : super(key: key);

  final Function onChanged;
  @override
  State<DialogAddCultura> createState() => _DialogAddCulturaState();
}

class _DialogAddCulturaState extends State<DialogAddCultura> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? codCultura;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Cadastrar nova cultura'),
        content: SizedBox(
          width: 750,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...[
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com o nome da cultura...',
                        labelText: 'Nome',
                      ),
                      onChanged: (value) {
                        setState(() {
                          nome = value;
                        });
                      },
                    ),
                    TextButton(
                      // color: Color(0xFF6200EE),
                      onPressed: () {
                        insertCulturas(nome).then((_) {
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
