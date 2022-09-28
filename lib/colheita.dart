import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_example/campo.dart';
// import 'package:login_example/cardss.dart';
import 'package:login_example/dashboard_screen.dart';
import 'package:login_example/plantio.dart';
import 'package:provider/provider.dart';
import 'package:login_example/cultivar.dart';
import 'package:login_example/propriedade.dart';
import 'package:login_example/safra.dart';
import 'package:login_example/talhao.dart';
import 'package:login_example/insumo.dart';
import 'package:login_example/dashboard_screen.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

Future<void> insertCarga(String nome, String peso, String umidade,
    String impurezas, DateTime dia, String colheita) async {
  // List<Campo> campos = [];
  final conn = await mysqlconnector;
  var dataFormatada = intl.DateFormat('yyyy-MM-dd').format(dia);

  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query(
      'insert into carga (nome, peso, umidade, impurezas, dia, cod_colheita) values (?, ?, ?, ?, ?, ?)',
      [nome, peso, umidade, impurezas, dataFormatada, colheita]);
}

Future<List<Carga>> getCargasRelatorioSafra({String safra = ''}) async {
  List<Carga> cargas = [];
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(milliseconds: 500));

  var results = await conn.query(
      '''SELECT carga.dia, talhao.nome,carga.peso,carga.impurezas,carga.umidade,cultivar.nome,carga.nome,
      carga.cod_carga,campo.nome,propriedade.nome,safra.nome FROM carga JOIN colheita ON colheita.cod_colheita=carga.cod_colheita
JOIN plantio ON plantio.cod_plantio=colheita.cod_plantio
JOIN safra ON safra.cod_safra=plantio.cod_safra
JOIN cultivar ON plantio.cod_cultivar=cultivar.cod_cultivar
JOIN talhao ON plantio.cod_talhao=talhao.cod_talhao
JOIN campo ON talhao.cod_campo=campo.cod_campo
JOIN propriedade ON campo.cod_propriedade=propriedade.cod_propriedade
WHERE safra.cod_safra=?''', [safra]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]}');
    cargas.add(
      Carga(
        name: '${row[6]}',
        peso: row[2],
        umidade: row[4],
        impureza: row[3],
        codCarga: '${row[7]}',
        nomeTalhao: '${row[1]}',
        cultivar: '${row[5]}',
        campoNome: '${row[8]}',
        propriedadeNome: '${row[9]}',
        safraNome: '${row[10]}',
        // String codColheita;
        // String codTalhao;
        // String codSafra;
        data: '${row[0]}',
      ),
    );
  }

  return cargas;
}

Future<List<Carga>> getColheitaRelatorioSafra({String safra = ''}) async {
  List<Carga> cargas = [];
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(milliseconds: 500));

  var results = await conn.query(
      '''SELECT carga.dia, talhao.nome,carga.peso,carga.impurezas,carga.umidade,cultivar.nome,carga.nome,
      carga.cod_carga,campo.nome FROM carga JOIN colheita ON colheita.cod_colheita=carga.cod_colheita
JOIN plantio ON plantio.cod_plantio=colheita.cod_plantio
JOIN safra ON safra.cod_safra=plantio.cod_safra
JOIN cultivar ON plantio.cod_cultivar=cultivar.cod_cultivar
JOIN talhao ON plantio.cod_talhao=talhao.cod_talhao
JOIN campo ON talhao.cod_campo=campo.cod_campo
WHERE safra.cod_safra=?''', [safra]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]}');
    cargas.add(
      Carga(
        name: '${row[6]}',
        peso: row[2],
        umidade: row[4],
        impureza: row[3],
        codCarga: '${row[7]}',
        nomeTalhao: '${row[1]}',
        cultivar: '${row[5]}',
        campoNome: '${row[8]}',
        data: '${row[0]}',
      ),
    );
  }

  return cargas;
}

Future<List<Carga>> getCargas({String colheita = ''}) async {
  List<Carga> cargas = [];
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));

  var results =
      await conn.query('SELECT * FROM carga where cod_colheita=?', [colheita]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]}');
    cargas.add(
      Carga(
        name: '${row[1]}',
        peso: row[2],
        umidade: row[3],
        impureza: row[4],
        codCarga: '${row[0]}',
        // String codColheita;
        // String codTalhao;
        // String codSafra;
        data: '${row[5]}',
      ),
    );
  }

  return cargas;
}
// void main() => runApp(const MyHomePage());

Future<void> insertColheitas(
    String? nome, String? area, String codPropriedade) async {
  // List<Colheita> Colheitas = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query(
      'insert into Colheita (nome, area, cod_propriedade) values (?, ?, ?)',
      [nome, area, codPropriedade]);
}

class ListItem {
  double? total;
  int? count;
  double? produtividade;

  ListItem({
    this.total,
    this.count,
    this.produtividade,
  });
}

Future<List<ListItem>> getResumoColheita(String id) async {
  List<ListItem> resumo = [];

  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  // var results = await conn.query('select * from Colheita');
  var results = await conn.query(
      """ SELECT count(*),sum(carga.peso), (SUM(carga.peso)/talhao.area)/60 FROM gpagri.colheita JOIN
                carga ON colheita.cod_colheita=carga.cod_colheita
                JOIN plantio ON plantio.cod_plantio=colheita.cod_plantio
                JOIN talhao on talhao.cod_talhao=plantio.cod_talhao
                WHERE colheita.cod_colheita=?""", [id]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    resumo.add(ListItem(
      total: row[1],
      count: row[0],
      produtividade: row[2],
    ));

    // print(Colheitas[0]);
  }

  // print(Colheitas);
  return resumo;
}

// //GET all the farm fields
Future<List<Colheita>> getColheitas(
    {String? codSafra, String? codTalhao, String? codCultivar}) async {
  List<Colheita> colheitas = [];

  if (codSafra == null) {
    return colheitas = [];
  }

  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  // var results = await conn.query('select * from Colheita');
  var results = await conn.query(
      """ SELECT colheita.nome,plantio.data_inicio,plantio.data_fim,plantio.nome,safra.nome,FLOOR(colheita.producao/60),
        propriedade.nome,campo.nome,talhao.nome, colheita.cod_colheita,
        plantio.cod_plantio,cultivar.nome,FLOOR((colheita.producao/60)/talhao.area),talhao.area FROM gpagri.colheita
        JOIN plantio ON plantio.cod_plantio=colheita.cod_plantio
        JOIN cultivar ON cultivar.cod_cultivar=plantio.cod_cultivar
        JOIN talhao ON talhao.cod_talhao=plantio.cod_talhao
        JOIN campo ON campo.cod_campo=talhao.cod_campo
        JOIN propriedade ON propriedade.cod_propriedade=campo.cod_propriedade
        JOIN safra ON plantio.cod_safra=safra.cod_safra
        where safra.cod_safra=?
        """, [codSafra]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    colheitas.add(
      Colheita(
          name: '${row[0]}',
          codColheita: '${row[9]}',
          codPlantio: '${row[10]}',
          nomeCultivar: '${row[11]}',
          produtividade: row[12],
          area: row[13],
          // codPlantio: '${row[5]}',
          nomePlantio: '${row[3]}',
          nomeSafra: '${row[4]}',
          nomePropriedade: '${row[6]}',
          nomeCampo: '${row[7]}',
          nomeTalhao: '${row[8]}',
          producao: row[5],
          dataInicio: '${row[1]}',
          dataFim: '${row[2]}'),
    );

    // print(Colheitas[0]);
  }

  // print(Colheitas);
  return colheitas;
}

Future<void> deleteColheita(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM colheita WHERE cod_Colheita = ?', [id]);
  } catch (e) {
    // print(e);
  }
}

Future<void> deleteCarga(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM carga WHERE cod_carga = ?', [id]);
  } catch (e) {
    // print(e);
  }
}

Future<void> updateColheita(
    String? nome, DateTime? dataInicio, DateTime? dataFim, codColheita) async {
  final conn = await mysqlconnector;

  var dataInicioFormatada = intl.DateFormat('yyyy-MM-dd').format(dataInicio!);
  var dataFimFormatada = intl.DateFormat('yyyy-MM-dd').format(dataFim!);

  var update = await conn.query(
      'update colheita  set nome=?, data_inicio=?, data_fim=? WHERE cod_Colheita = ?',
      [nome, dataInicioFormatada, dataFimFormatada, codColheita]);
}

// class DialogUpdateColheita extends StatefulWidget {
//   const DialogUpdateColheita(
//       {Key? key, required this.codColheita, required this.nomeColheita})
//       : super(key: key);

//   final String codColheita;
//   final String nomeColheita;

//   @override
//   State<DialogUpdateColheita> createState() => _DialogUpdateColheitastate();
// }

// class _DialogUpdateColheitastate extends State<DialogUpdateColheita> {
//   final _formKey = GlobalKey<FormState>();
//   String? nome;
//   String? area;
//   DateTime date = DateTime.now();
//   // final _Colheita = Colheita();
//   @override
//   Widget build(BuildContext context) {
//     // DateTime date = DateTime.now();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF6200EE),
//         title: Text('Editar Colheita "' + widget.nomeColheita + '"'),
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
//                             updateColheita(nome!, area!, widget.codColheita);
//                             Navigator.pop(context, nome);
//                             // setState(() {});
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

class TelaColheitas extends StatefulWidget {
  static const routeName = '/colheita';
  const TelaColheitas({Key? key}) : super(key: key);

  @override
  State<TelaColheitas> createState() => _TelaColheitasState();
}

class _TelaColheitasState extends State<TelaColheitas> {
  late Future<List<Colheita>> futureColheita;
  late Future<List<Safra>> futureSafra;
  late Future<List<Talhao>> futureTalhao;
  late Future<List<Cultivar>> futureCultivar;
  late Future<List<Insumo>> futureInsumo;
  Safra? _selectedSafra;
  Talhao? _selectedTalhao;
  Cultivar? _selectedCultivar;

  String dropdownValue = 'One';
  String holder = '';

  @override
  void initState() {
    super.initState();
    futureColheita = getColheitas(
        codSafra: context.read<SafraProvider>().selectedSafra?.codSafra);
    futureSafra = getSafras();
    futureTalhao = getTalhoes();
    futureCultivar = getCultivares();
    futureInsumo = getInsumos();
  }

  void _handleUpdate() {
    futureColheita = getColheitas(
        codSafra: context.read<SafraProvider>().selectedSafra?.codSafra);
    setState(() {});
  }

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final List<Colheita> Colheitas;
    // Colheitas = getColheitas() as List<Colheita>;
    // final Colheita? Colheita1;
    // Colheita1 =
    //     const Colheita(name: "name", area: "25", cod_propriedade: 3, cod_Colheita: 4);
    // var Colheitacard = ColheitaCard(Colheita: Colheita1);
    return
        // MaterialApp(
        //   title: 'Cardss',
        //   theme: ThemeData(
        //     primarySwatch: Colors.blue,
        //   ),
        // home:
        Scaffold(
      appBar: AppBar(
        title: const Text('Colheitas'),
      ),
      body: Center(
        child: FutureBuilder<List<Colheita>>(
            future: futureColheita,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Column(
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
                        // Row(
                        //   children: [
                        //     Card(
                        //       child: Consumer<Counter>(
                        //         builder: (context, counter, child) => Text(
                        //           counter.nomePropriedade,
                        //           style: DefaultTextStyle.of(context)
                        //               .style
                        //               .apply(fontSizeFactor: 1.5),
                        //         ),
                        //       ),
                        //     ),
                        //     const Icon(Icons.arrow_forward_ios),
                        //     Card(
                        //       child: Consumer<CampoProvider>(
                        //         builder: (context, counter, child) => Text(
                        //           counter.nomeCampo,
                        //           style: DefaultTextStyle.of(context)
                        //               .style
                        //               .apply(fontSizeFactor: 1.5),
                        //         ),
                        //       ),
                        //     ),
                        //     const Icon(Icons.arrow_forward_ios),
                        //     Card(
                        //       child: Consumer<TalhaoProvider>(
                        //         builder: (context, counter, child) => Text(
                        //           counter.nomeTalhao,
                        //           style: DefaultTextStyle.of(context)
                        //               .style
                        //               .apply(fontSizeFactor: 1.5),
                        //         ),
                        //       ),
                        //     ),
                        //     const Icon(Icons.arrow_forward_ios),
                        //     Card(
                        //       child: Consumer<SafraProvider>(
                        //         builder: (context, counter, child) => Text(
                        //           counter.nomeSafra,
                        //           style: DefaultTextStyle.of(context)
                        //               .style
                        //               .apply(fontSizeFactor: 1.5),
                        //         ),
                        //       ),
                        //     ),
                        //     const Spacer(),
                        //     TextButton.icon(
                        //       //textColor: const Color(0xFF6200EE),
                        //       onPressed: () {
                        //         // Perform some action
                        //         Navigator.pushNamed((context), '/campo');
                        //         // getCampos(codPropriedade: propriedade!.Aplicacao);
                        //       },
                        //       label: const Text('Ver campos'),
                        //       icon: const Icon(Icons.remove_red_eye),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     FutureBuilder<List<Safra>>(
                        //         future: futureSafra,
                        //         builder: (context, propr) {
                        //           if (propr.hasData) {
                        //             return DropdownButton<Safra>(
                        //               hint: const Text('Safra'),
                        //               value: _selectedSafra,
                        //               icon: const Icon(Icons.arrow_downward),
                        //               elevation: 16,
                        //               style: const TextStyle(
                        //                   color: Colors.deepPurple),
                        //               underline: Container(
                        //                 height: 2,
                        //                 color: Colors.deepPurpleAccent,
                        //               ),
                        //               onChanged: (Safra? newValue) {
                        //                 setState(() {
                        //                   _selectedSafra = newValue!;
                        //                 });
                        //               },
                        //               items: propr.data
                        //                   ?.map<DropdownMenuItem<Safra>>(
                        //                       (Safra value) {
                        //                 return DropdownMenuItem<Safra>(
                        //                   value: value,
                        //                   child: Text(value.codSafra +
                        //                       ' ' +
                        //                       value.nome),
                        //                   onTap: () {
                        //                     futureColheita = getColheitas();
                        //                     //print(value.cod_propriedade);
                        //                   },
                        //                 );
                        //               }).toList(),
                        //             );
                        //           } else if (propr.hasError) {
                        //             return Text('${propr.error}');
                        //           }
                        //           return const CircularProgressIndicator();
                        //         }),
                        //     const Padding(
                        //       padding: EdgeInsets.all(8),
                        //     ),
                        //     FutureBuilder<List<Talhao>>(
                        //         future: futureTalhao,
                        //         builder: (context, propr) {
                        //           if (propr.hasData) {
                        //             return DropdownButton<Talhao>(
                        //               hint: const Text('Talhão'),
                        //               value: _selectedTalhao,
                        //               icon: const Icon(Icons.arrow_downward),
                        //               elevation: 16,
                        //               style: const TextStyle(
                        //                   color: Colors.deepPurple),
                        //               underline: Container(
                        //                 height: 2,
                        //                 color: Colors.deepPurpleAccent,
                        //               ),
                        //               onChanged: (Talhao? newValue) {
                        //                 setState(() {
                        //                   _selectedTalhao = newValue!;
                        //                 });
                        //               },
                        //               items: propr.data
                        //                   ?.map<DropdownMenuItem<Talhao>>(
                        //                       (Talhao value) {
                        //                 return DropdownMenuItem<Talhao>(
                        //                   value: value,
                        //                   child: Text(value.codTalhao +
                        //                       ' ' +
                        //                       value.nome),
                        //                   onTap: () {
                        //                     futureColheita = getColheitas();
                        //                     // print(value.cod_propriedade);
                        //                   },
                        //                 );
                        //               }).toList(),
                        //             );
                        //           } else if (propr.hasError) {
                        //             return Text('${propr.error}');
                        //           }
                        //           return const CircularProgressIndicator();
                        //         }),
                        //     const Padding(
                        //       padding: EdgeInsets.all(8),
                        //     ),
                        //     FutureBuilder<List<Cultivar>>(
                        //         future: futureCultivar,
                        //         builder: (context, propr) {
                        //           if (propr.hasData) {
                        //             return DropdownButton<Cultivar>(
                        //               hint: const Text('Cultivar'),
                        //               value: _selectedCultivar,
                        //               icon: const Icon(Icons.arrow_downward),
                        //               elevation: 16,
                        //               style: const TextStyle(
                        //                   color: Colors.deepPurple),
                        //               underline: Container(
                        //                 height: 2,
                        //                 color: Colors.deepPurpleAccent,
                        //               ),
                        //               onChanged: (Cultivar? newValue) {
                        //                 setState(() {
                        //                   _selectedCultivar = newValue!;
                        //                 });
                        //               },
                        //               items: propr.data
                        //                   ?.map<DropdownMenuItem<Cultivar>>(
                        //                       (Cultivar value) {
                        //                 return DropdownMenuItem<Cultivar>(
                        //                   value: value,
                        //                   child: Text(value.codCultivar +
                        //                       ' ' +
                        //                       value.nome),
                        //                   onTap: () {
                        //                     futureColheita = getColheitas();
                        //                     // print(value.cod_propriedade);
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
                        ...?snapshot.data?.map((d) => ColheitaCard(
                              colheita: d,
                              onChanged: _handleUpdate,
                              // futureInsumo: getInsumos(),
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
        tooltip: 'Nova colheita',
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () async {
          if (context.read<PropriedadProvider>().selectedPropriedade != null) {
            await showDialog(
              context: context,
              builder: (context) => DialogAddColheita(
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

// class ListInsumo extends StatelessWidget {
//   // final Future<List<Insumo>> futureInsumo = getInsumos();
//   final Insumo? insumo;

//   const ListInsumo({Key? key, this.insumo}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: ListView.builder(
//         padding: const EdgeInsets.all(8.0),
//         reverse: true,
//         itemBuilder: (_, index) => listaInsumo[index],
//         itemCount: listaInsumo.length,
//       ),
//     );
//   }
// }

class Colheita {
  String name;
  double? produtividade;
  String? nomePlantio;
  String? nomePropriedade;
  String? nomeCampo;
  String? nomeSafra;
  String? nomeTalhao;
  String? nomeCultivar;
  String codColheita;
  String? codPlantio;
  String? codCultivar;
  String? codTalhao;
  String? codSafra;
  String dataInicio;
  double? area;
  String dataFim;
  double? producao;

  Colheita({
    this.area,
    this.codPlantio,
    this.nomeCultivar,
    required this.name,
    required this.codColheita,
    this.nomePropriedade,
    this.produtividade,
    this.nomeCampo,
    this.codCultivar,
    this.codTalhao,
    this.codSafra,
    this.nomePlantio,
    this.nomeSafra,
    this.nomeTalhao,
    required this.dataInicio,
    required this.dataFim,
    this.producao,
  });

  String getCodColheita() {
    return codColheita;
  }

  // String toString() {
  //   return 'Colheita: {nome: $name, area: $area, codColheita: $codColheita, cod_propriedade: $cod_propriedade}';
  // }
}

class Carga {
  String name;
  double? peso;
  double? umidade;
  double? impureza;
  String codCarga;
  // String codColheita;
  // String codTalhao;
  // String codSafra;
  String data;

  String? cultivar;

  String? nomeTalhao;

  String? campoNome;

  String? propriedadeNome;

  String? safraNome;

  Carga({
    required this.name,
    this.peso,
    this.umidade,
    this.impureza,
    required this.codCarga,
    // required this.codColheita,
    // required this.codTalhao,
    // required this.codSafra,
    required this.data,
    this.cultivar,
    this.nomeTalhao,
    this.campoNome,
    this.propriedadeNome,
    this.safraNome,
  });

  // String toString() {
  //   return 'Colheita: {nome: $name, area: $area, codColheita: $codColheita, cod_propriedade: $cod_propriedade}';
  // }
}

class ColheitaCard extends StatelessWidget {
  final Colheita? colheita;
  // final Future<List<Insumo>> futureInsumo;
  // final String onChanded;
  // final Future<List<InsumoColheita>> futureInsumo = getInsumosColheita();
  final Future<List<Carga>> futureInsumo = getCargas();

  final Function onChanged;

  ColheitaCard({
    this.colheita,
    required this.onChanged,
    Key? key,
    // this.insumo,
    // required this.futureInsumo,
    // required this.futureInsumo
  }) : super(key: key);

//   @override
//   State<ColheitaCard> createState() => _ColheitaCardState();
// }

// class _ColheitaCardState extends State<ColheitaCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40), // if you need this
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 4,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_drop_down_circle),
              title: Text(colheita!.name),
              subtitle: Text(
                'Cod ' + (colheita!.codColheita.toString()),
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Área(ha): ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: colheita!.area!.toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Produtividade(sc 60kg/ha): ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: colheita!.produtividade!.toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Produção(sc 60kg): ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: colheita!.producao!.toStringAsFixed(2),
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
              children: <Widget>[
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Safra: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: colheita!.nomeSafra,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Propriedade: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: colheita!.nomePropriedade,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Campo: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: colheita!.nomeCampo,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Talhão: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: colheita!.nomeTalhao,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Plantio: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: colheita!.nomePlantio,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Cultivar: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: colheita!.nomeCultivar,
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded(
                //   child: Text(
                //     'Safra: ' + plantio!.codSafra,
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Expanded(
                //   child: Text('Talhão: ' + plantio!.codTalhao,
                //       textAlign: TextAlign.center),
                // ),
                // Expanded(
                //   child: Text('Cultivar: ' + plantio!.codCultivar,
                //       textAlign: TextAlign.center),
                // ),
              ],
            ),

            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: Text('Safra: ' + colheita!.codSafra,
            //           textAlign: TextAlign.center),
            //     ),
            //     Expanded(
            //       child: Text('Talhão: ' + colheita!.codTalhao,
            //           textAlign: TextAlign.center),
            //     ),
            //     Expanded(
            //       child: Text('Cultivar: ' + colheita!.codCultivar,
            //           textAlign: TextAlign.center),
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
            //     style: TextStyle(color: Colors.black.withOpacity(0.6)),
            //   ),
            // ),
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
                  child:
                      Text(colheita!.dataInicio, textAlign: TextAlign.center),
                ),
                // Expanded(
                //   child:
                //       Text('Craft beautiful UIs', textAlign: TextAlign.center),
                // ),
                Expanded(
                  child: Text(colheita!.dataFim, textAlign: TextAlign.center),
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
                    'Cargas:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Nome:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Peso(Kg):',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Umidade(%):',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Impurezas(%):',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Data:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            FutureBuilder<List<Carga>>(
                future: getCargas(colheita: colheita!.codColheita),
                builder: (context, propr) {
                  if (propr.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: propr.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(propr.data![index].codCarga,
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text(propr.data![index].name,
                                    // .toStringAsFixed(2),
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text(
                                    propr.data![index].peso!.toStringAsFixed(2),
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text(
                                    propr.data![index].umidade!
                                        .toStringAsFixed(2),
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text(
                                    propr.data![index].impureza!
                                        .toStringAsFixed(2),
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text(propr.data![index].data,
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: IconButton(
                                  focusColor: Colors.white,
                                  icon: const Icon(Icons.edit_outlined),
                                  alignment: Alignment.center,
                                  onPressed: () async {
                                    await showDialog<void>(
                                        context: context,
                                        builder: (context) => DialogUpdateCarga(
                                            codPropriedade:
                                                propr.data![index].codCarga,
                                            nomePropriedade: propr.data![index]
                                                .codCarga)).then((_) {
                                      onChanged();
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  alignment: Alignment.center,
                                  onPressed: () {
                                    deleteCarga(propr.data![index].codCarga)
                                        .then((_) {
                                      onChanged();
                                    });
                                  },
                                ),
                              ),
                              // Text(propr.data![index].nome +
                              //     "    Dosagem:" +
                              //     propr.data![index].dosagem),
                            ],
                          );
                        });
                  } else if (propr.hasError) {
                    return Text('${propr.error}');
                  }
                  return const CircularProgressIndicator();
                }),

            Row(
              children: [
                TextButton.icon(
                  //textColor: const Color(0xFF6200EE),
                  onPressed: () async {
                    await showDialog<void>(
                        context: context,
                        builder: (context) => DialogAddCarga(
                            codColheita: colheita!.codColheita)).then((_) {
                      onChanged();
                    });
                  },
                  label: const Text('Nova carga'),
                  icon: const Icon(Icons.add),
                )
              ],
            ),

            // Flexible(
            //   child: ListView.builder(
            //     padding: const EdgeInsets.all(8.0),
            //     reverse: true,
            //     itemBuilder: (_, index) => futureInsumo[index],
            //     itemCount: futureInsumo.length,
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
                        builder: (context) => DialogUpdateColheita(
                              codPropriedade: colheita!.codColheita,
                              nomePropriedade: colheita!.name,
                              nomeColheita: colheita!.name,
                            )).then((_) {
                      onChanged();
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                TextButton.icon(
                  //textColor: const Color(0xFF6200EE),
                  onPressed: () async {
                    await deleteColheita(colheita!.codColheita).then((_) {
                      onChanged();
                    });

                    // print('Voce esta aqui');
                    // onChanged(Colheita!.cod_propriedade);

                    // _TelaColheitasState().futureColheita =
                    //     getColheitas(codPropriedade: Colheita!.cod_propriedade);
                    // Navigator.pop(context);
                    // Navigator.pushNamed(context, '/Colheita');
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
          ],
        ),
      ),
    );
  }
}

class DialogAddColheita extends StatefulWidget {
  const DialogAddColheita(
      {Key? key,
      required this.codPropriedade,
      required this.nome,
      required this.propriedadeSelecionada,
      this.codSafra,
      required this.onChanged})
      : super(key: key);

  final String codPropriedade;
  final String nome;
  final Propriedade? propriedadeSelecionada;
  final String? codSafra;
  final Function onChanged;

  @override
  State<DialogAddColheita> createState() => _DialogAddColheitaState();
}

class _DialogAddColheitaState extends State<DialogAddColheita> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  Plantio? _selectedPlantio;
  late Future<List<Plantio>> futurePlantio;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    futurePlantio = getPlantios(
        codSafra: context.read<SafraProvider>().selectedSafra?.codSafra);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text('Cadastrar nova colheita na safra "' +
            context.read<SafraProvider>().selectedSafra!.codSafra +
            '"'),
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
                  Row(
                    children: [
                      Expanded(
                        child: FutureBuilder<List<Plantio>>(
                            future: futurePlantio,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButton<Plantio>(
                                  hint: const Text('Selecionar plantio'),
                                  value: _selectedPlantio,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  isExpanded: true,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (Plantio? newValue) {
                                    setState(() {
                                      _selectedPlantio = newValue!;
                                    });
                                  },
                                  items: snapshot.data
                                      ?.map<DropdownMenuItem<Plantio>>(
                                          (Plantio value) {
                                    return DropdownMenuItem<Plantio>(
                                      value: value,
                                      child: Text(value.name),
                                    );
                                  }).toList(),
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const CircularProgressIndicator();
                            }),
                      ),
                    ],
                  ),
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
                      children: [
                        _FormDatePicker(
                          date: date,
                          epoca: 'de início',
                          onChanged: (value) {
                            // setState(() {
                            //   date = value;
                            // });
                          },
                        ),
                        _FormDatePicker(
                          date: date,
                          epoca: 'de término',
                          onChanged: (value) {
                            // setState(() {
                            //   date = value;
                            // });
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
                            await insertColheitas(
                                    nome, area, widget.codPropriedade)
                                .then((_) {
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

class DialogAddCarga extends StatefulWidget {
  const DialogAddCarga({
    Key? key,
    this.codPropriedade,
    this.nomePropriedade,
    this.codColheita,
    // required this.onChanged
  }) : super(key: key);
  // final ValueChanged onChanged;
  final String? codPropriedade;
  final String? nomePropriedade;
  final String? codColheita;

  @override
  State<DialogAddCarga> createState() => _DialogAddCargaState();
}

class _DialogAddCargaState extends State<DialogAddCarga> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  String? peso;
  String? umidade;
  String? impureza;
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
        title: const Text('Nova carga'),
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
                      // keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com o peso...',
                        labelText: 'Peso(Kg)',
                      ),
                      onChanged: (value) {
                        setState(() {
                          peso = value;
                        });
                      },
                    ),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com a umidade...',
                        labelText: 'Umidade(%)',
                      ),
                      onChanged: (value) {
                        setState(() {
                          umidade = value;
                        });
                      },
                    ),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com as impurezas...',
                        labelText: 'Impurezas(%)',
                      ),
                      onChanged: (value) {
                        setState(() {
                          impureza = value;
                        });
                      },
                    ),
                    _FormDatePicker(
                      date: date,
                      onChanged: (value) {
                        setState(() {
                          date = value;
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
                            insertCarga(nome!, peso!, umidade!, impureza!, date,
                                widget.codColheita!);
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

class DialogUpdateCarga extends StatefulWidget {
  const DialogUpdateCarga({
    Key? key,
    this.codPropriedade,
    this.nomePropriedade,
    // required this.onChanged
  }) : super(key: key);
  // final ValueChanged onChanged;
  final String? codPropriedade;
  final String? nomePropriedade;

  @override
  State<DialogUpdateCarga> createState() => _DialogUpdateCargaState();
}

class _DialogUpdateCargaState extends State<DialogUpdateCarga> {
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
        title: Text('Editar carga "' + widget.codPropriedade! + '"'),
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
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com o peso...',
                        labelText: 'Peso(Kg)',
                      ),
                      onChanged: (value) {
                        setState(() {
                          nome = value;
                        });
                      },
                    ),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com a umidade...',
                        labelText: 'Umidade(%)',
                      ),
                      onChanged: (value) {
                        setState(() {
                          nome = value;
                        });
                      },
                    ),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com as impurezas...',
                        labelText: 'Impurezas(%)',
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
                        setState(() {
                          date = value;
                        });
                      },
                    ),
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
                          onPressed: () {
                            Navigator.pop(context, nome);
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

class DialogUpdateColheita extends StatefulWidget {
  const DialogUpdateColheita(
      {Key? key,
      this.codPropriedade,
      this.nomePropriedade,
      this.nomeColheita,
      this.codColheita
      // required this.onChanged
      })
      : super(key: key);
  // final ValueChanged onChanged;
  final String? codPropriedade;
  final String? nomePropriedade;
  final String? nomeColheita;
  final String? codColheita;

  @override
  State<DialogUpdateColheita> createState() => _DialogUpdateColheitaState();
}

class _DialogUpdateColheitaState extends State<DialogUpdateColheita> {
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
        title: Text('Editar colheita "' + widget.nomeColheita! + '"'),
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
                        TextButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          // color: Color(0xFF6200EE),
                          onPressed: () {
                            updateColheita(
                                nome, date, date, widget.codPropriedade);
                            Navigator.pop(context, nome);
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

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  String? epoca;

  _FormDatePicker({
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
