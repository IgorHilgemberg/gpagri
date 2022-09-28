import 'package:flutter/material.dart';
import 'package:login_example/cardss.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

// void main() => runApp(const MyHomePage());

Future<void> insertInsumos(String? nome) async {
  // List<Insumo> Insumos = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query('insert into insumo (nome) values (?)', [nome]);
  // for (var row in results) {
  //   // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  //   // Insumos.add(
  //   //   Insumo(
  //   //       name: '${row[2]}',
  //   //       area: '${row[0]}',
  //   //       cod_propriedade: '${row[3]}',
  //   //       cod_Insumo: '${row[1]}'),
  //   // );

  //   // print(Insumos[0]);
  // }
  // await conn.close();
  // print(Insumos);
}

// //GET all the farm fields
Future<List<Insumo>> getInsumos() async {
  List<Insumo> insumos = [];
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));

  var results = await conn.query('select * from Insumo');
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]}');
    insumos.add(Insumo(
      nome: '${row[1]}',
      codInsumo: '${row[0]}',
    ));
  }

  return insumos;
}

Future<void> deleteInsumo(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM Insumo WHERE cod_Insumo = ?', [id]);
  } catch (e) {
    print(e);
  }
}

Future<void> updateInsumo(String nome, String id) async {
  final conn = await mysqlconnector;

  var update = await conn
      .query('update Insumo  set nome=? WHERE cod_Insumo = ?', [nome, id]);
}

class DialogUpdateInsumo extends StatefulWidget {
  const DialogUpdateInsumo(
      {Key? key, required this.codInsumo, required this.nomeInsumo})
      : super(key: key);

  final String codInsumo;
  final String nomeInsumo;

  @override
  State<DialogUpdateInsumo> createState() => _DialogUpdateInsumoState();
}

class _DialogUpdateInsumoState extends State<DialogUpdateInsumo> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();
  // final _Insumo = Insumo();
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Editar insumo "' + widget.nomeInsumo + '"'),
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
                            // setState(() {});
                          },
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () {
                            updateInsumo(nome!, widget.codInsumo);
                            Navigator.pop(context);
                            // setState(() {});
                          },
                          child: const Text('Salvar alteração'),
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

class TelaInsumos extends StatefulWidget {
  static const routeName = '/insumo';
  const TelaInsumos({Key? key}) : super(key: key);

  @override
  State<TelaInsumos> createState() => _TelaInsumosState();
}

class _TelaInsumosState extends State<TelaInsumos> {
  late Future<List<Insumo>> futureInsumo;
  // late Future<List<Propriedade>> futurePropriedade;
  // Propriedade? _selectedPropriedade;
  String dropdownValue = 'One';
  String holder = '';
  bool _update = false;

  @override
  void initState() {
    super.initState();
    futureInsumo = getInsumos();
  }

  void _handleUpdate() {
    futureInsumo = getInsumos();
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
        title: const Text('Insumos'),
      ),
      body: Center(
        child: SizedBox(
          width: 750,
          child: Center(
            child: FutureBuilder<List<Insumo>>(
                future: futureInsumo,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      padding: const EdgeInsets.all(20.0),
                      children: [
                        Column(
                          children: [
                            ...?snapshot.data?.map((d) => InsumoCard(
                                insumo: d, onChanged: _handleUpdate)),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => DialogAddInsumo(
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

class Insumo {
  String nome;
  String codInsumo;

  Insumo({
    required this.nome,
    required this.codInsumo,
  });
}

class InsumoCard extends StatelessWidget {
  final Insumo? insumo;
  // final String onChanded;

  final onChanged;

  const InsumoCard({this.insumo, required this.onChanged, Key? key})
      : super(key: key);

//   @override
//   State<InsumoCard> createState() => _InsumoCardState();
// }

// class _InsumoCardState extends State<InsumoCard> {
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
            //leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(insumo!.nome),
            // subtitle: Text(
            //   'Cod ' + (Insumo!.codInsumo.toString()),
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
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => DialogUpdateInsumo(
                      codInsumo: insumo!.codInsumo,
                      nomeInsumo: insumo!.nome,
                    ),
                  ).then((_) {
                    // print('Voce esta aqui');
                    onChanged();
                  });
                },
                child: const Icon(Icons.edit),
              ),
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () async {
                  await deleteInsumo(insumo!.codInsumo);

                  // print('Voce esta aqui');
                  onChanged();

                  // _TelaInsumosState().futureInsumo =
                  //     getInsumos(codPropriedade: Insumo!.cod_propriedade);
                  // Navigator.pop(context);
                  // Navigator.pushNamed(context, '/Insumo');
                  // Perform some action
                },
                child: const Icon(Icons.delete),
              ),
              const SizedBox(width: 60),
            ],
          ),
          //Image.asset('assets/card-sample-image.jpg'),
        ],
      ),
    );
  }
}

class DialogAddInsumo extends StatefulWidget {
  const DialogAddInsumo({Key? key, required this.onChanged}) : super(key: key);
  final Function onChanged;

  @override
  State<DialogAddInsumo> createState() => _DialogAddInsumoState();
}

class _DialogAddInsumoState extends State<DialogAddInsumo> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? codInsumo;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Cadastrar novo insumo'),
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
                        hintText: 'Entre com o nome do insumo...',
                        labelText: 'Nome',
                      ),
                      onChanged: (value) {
                        setState(() {
                          nome = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      // color: Color(0xFF6200EE),
                      onPressed: () {
                        insertInsumos(nome).then((_) {
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
