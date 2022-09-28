import 'package:flutter/material.dart';
import 'package:login_example/cardss.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

// void main() => runApp(const MyHomePage());

Future<void> insertCultivares(String? nome, String codCultura) async {
  // List<Cultivar> Cultivares = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query(
      'insert into cultivar (nome, codCultura) values (?, ?)',
      [nome, codCultura]);
}

// //GET all the farm fields
Future<List<Cultivar>> getCultivares({String codCultura = ''}) async {
  List<Cultivar> cultivares = [];
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  if (codCultura == '') {
    var results = await conn.query(
        '''select cultivar.cod_cultivar,cultivar.nome,cultivar.cod_cultura
         , cultura.nome from Cultivar 
         JOIN cultura ON cultura.cod_cultura=cultivar.cod_cultura''');
    for (var row in results) {
      // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
      cultivares.add(
        Cultivar(
            nome: '${row[1]}',
            codCultura: '${row[2]}',
            codCultivar: '${row[0]}',
            nomeCultura: '${row[3]}'),
      );

      // print(Cultivares[0]);
    }
  } else {
    var results = await conn.query(
        '''select cultivar.cod_cultivar,cultivar.nome,cultivar.cod_cultura
         , cultura.nome from Cultivar 
         JOIN cultura ON cultura.cod_cultura=cultivar.cod_cultura
         where cultivar.cod_cultura=?''', [codCultura]);
    for (var row in results) {
      // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
      cultivares.add(
        Cultivar(
            nome: '${row[1]}',
            codCultura: '${row[2]}',
            codCultivar: '${row[0]}',
            nomeCultura: '${row[3]}'),
      );

      // print(Cultivares[0]);
    }
  }
  // print(cultivares);
  return cultivares;
}

// GET all the property fields
Future<List<Cultura>> getCulturas() async {
  List<Cultura> Culturas = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var results = await conn.query('select * from Cultura');
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    Culturas.add(
      Cultura(
        nome: '${row[1]}',
        codCultura: '${row[0]}',
      ),
    );
  }
  // await conn.close();
  return Culturas;
}

Future<void> deleteCultivar(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM cultivar WHERE cod_cultivar = ?', [id]);
  } catch (e) {
    print(e);
  }
}

Future<void> updateCultivar(String nome, String id) async {
  final conn = await mysqlconnector;

  var update = await conn
      .query('update cultivar set nome=? WHERE cod_cultivar = ?', [nome, id]);
}

class DialogUpdateCultivar extends StatefulWidget {
  const DialogUpdateCultivar(
      {Key? key, required this.codCultivar, required this.nomeCultivar})
      : super(key: key);

  final String codCultivar;
  final String nomeCultivar;

  @override
  State<DialogUpdateCultivar> createState() => _DialogUpdateCultivarestate();
}

class _DialogUpdateCultivarestate extends State<DialogUpdateCultivar> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  // String? area;
  // DateTime date = DateTime.now();
  // final _Cultivar = Cultivar();
  @override
  Widget build(BuildContext context) =>
      // DateTime date = DateTime.now();

      AlertDialog(
        title: Text('Editar cultivar "' + widget.nomeCultivar + '"'),
        content: SizedBox(
          width: 750,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...[
                    TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com um nome...',
                        labelText: 'Nome cultivar',
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
                            // print(widget.codCultivar);
                            updateCultivar(nome!, widget.codCultivar);
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

class TelaCultivares extends StatefulWidget {
  static const routeName = '/cultivar';
  const TelaCultivares({Key? key}) : super(key: key);

  @override
  State<TelaCultivares> createState() => _TelaCultivaresState();
}

class _TelaCultivaresState extends State<TelaCultivares> {
  late Future<List<Cultivar>> futureCultivar;
  late Future<List<Cultura>> futureCultura;
  Cultura? _selectedCultura;
  String dropdownValue = 'One';
  String holder = '';
  bool _update = false;

  @override
  void initState() {
    super.initState();
    futureCultivar = getCultivares();
    futureCultura = getCulturas();
  }

  void _handleUpdate() {
    futureCultivar = getCultivares();
    setState(() {});
  }

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final List<Cultivar> Cultivares;
    // Cultivares = getCultivares() as List<Cultivar>;
    // final Cultivar? Cultivar1;
    // Cultivar1 =
    //     const Cultivar(name: "name", area: "25", codCultura: 3, codCultivar: 4);
    // var Cultivarcard = CultivarCard(Cultivar: Cultivar1);
    return
        // MaterialApp(
        //   title: 'Cardss',
        //   theme: ThemeData(
        //     primarySwatch: Colors.blue,
        //   ),
        // home:
        Scaffold(
      appBar: AppBar(
        title: const Text('Cultivares'),
      ),
      body: Center(
        child: FutureBuilder<List<Cultivar>>(
            future: futureCultivar,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Cultura'),
                          ],
                        ),
                        const Divider(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: FutureBuilder<List<Cultura>>(
                                  future: futureCultura,
                                  builder: (context, propr) {
                                    if (propr.hasData) {
                                      return DropdownButton<Cultura>(
                                        isExpanded: true,
                                        hint: const Text('Selecionar cultura'),
                                        value: _selectedCultura,
                                        // icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (Cultura? newValue) {
                                          setState(() {
                                            _selectedCultura = newValue!;
                                          });
                                        },
                                        items: propr.data
                                            ?.map<DropdownMenuItem<Cultura>>(
                                                (Cultura value) {
                                          return DropdownMenuItem<Cultura>(
                                            value: value,
                                            child: Text(value.codCultura +
                                                ' ' +
                                                value.nome),
                                            onTap: () {
                                              futureCultivar = getCultivares(
                                                  codCultura: value.codCultura);
                                              // print(value.codCultura);
                                            },
                                          );
                                        }).toList(),
                                      );
                                    } else if (propr.hasError) {
                                      return Text('${propr.error}');
                                    }
                                    return const CircularProgressIndicator();
                                  }),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text('Suas cultivares'),
                            Padding(padding: EdgeInsets.all(20))
                          ],
                        ),
                        ...?snapshot.data?.map((d) => CultivarCard(
                            cultivar: d, onChanged: _handleUpdate)),
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
          if (_selectedCultura != null) {
            await showDialog(
              context: context,
              builder: (context) => DialogAddCultivar(
                // codCultura: ,
                onChanged: _handleUpdate,
                codCultura: _selectedCultura!.codCultura,
                nome: _selectedCultura!.nome,
                culturaSelecionada: _selectedCultura,
              ),
            );
          } else {
            showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Selecione uma Cultura:'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('Você deve selecionar uma Cultura no menu!'),
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

class Cultivar {
  String nome;
  String codCultura;
  String nomeCultura;
  String codCultivar;

  Cultivar(
      {required this.nome,
      required this.nomeCultura,
      required this.codCultura,
      required this.codCultivar});

  String getCodCultivar() {
    return codCultivar;
  }

  // String toString() {
  //   return 'Cultivar: {nome: $name, area: $area, codCultivar: $codCultivar, codCultura: $codCultura}';
  // }
}

class Cultura {
  final String nome;
  final String codCultura;

  const Cultura({required this.nome, required this.codCultura});

  // String toString() {
  //   return 'Cultivar: {nome: $name, area: $area, codCultivar: $codCultivar, codCultura: $codCultura}';
  // }
}

class CultivarCard extends StatelessWidget {
  final Cultivar? cultivar;
  // final String onChanded;

  final Function onChanged;

  const CultivarCard({this.cultivar, required this.onChanged, Key? key})
      : super(key: key);

//   @override
//   State<CultivarCard> createState() => _CultivarCardState();
// }

// class _CultivarCardState extends State<CultivarCard> {
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
            title: Text(cultivar!.nome),
            subtitle: Text(
              (cultivar!.nomeCultura),
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
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => DialogUpdateCultivar(
                      codCultivar: cultivar!.codCultivar,
                      nomeCultivar: cultivar!.nome,
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
                  await deleteCultivar(cultivar!.codCultivar);

                  // print('Voce esta aqui');
                  onChanged();

                  // _TelaCultivaresState().futureCultivar =
                  //     getCultivares(codCultura: Cultivar!.codCultura);
                  // Navigator.pop(context);
                  // Navigator.pushNamed(context, '/Cultivar');
                  // Perform some action
                },
                child: const Icon(Icons.delete),
              ),
              const SizedBox(
                width: 70,
              )
            ],
          ),
          //Image.asset('assets/card-sample-image.jpg'),
        ],
      ),
    );
  }
}

class DialogAddCultivar extends StatefulWidget {
  const DialogAddCultivar(
      {Key? key,
      required this.codCultura,
      required this.nome,
      required this.culturaSelecionada,
      required this.onChanged})
      : super(key: key);

  final Function onChanged;
  final String codCultura;
  final String nome;
  final Cultura? culturaSelecionada;

  @override
  State<DialogAddCultivar> createState() => _DialogAddCultivarState();
}

class _DialogAddCultivarState extends State<DialogAddCultivar> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Cadastrar nova cultivar de "' + widget.nome + '"'),
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
                          child: const Text('Descartar'),
                        ),
                        ElevatedButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () {
                            insertCultivares(nome, widget.codCultura).then((_) {
                              widget.onChanged();
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
