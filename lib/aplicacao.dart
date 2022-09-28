import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:login_example/cardss.dart';
import 'package:login_example/cultivar.dart';
import 'package:login_example/dashboard_screen.dart';
import 'package:login_example/plantio.dart';
import 'package:login_example/safra.dart';
import 'package:login_example/talhao.dart';
import 'package:login_example/insumo.dart';
import 'package:login_example/propriedade.dart';
import 'package:provider/provider.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

class InsumoAplicacao {
  var dosagem = 0.0;
  var totalGasto = 0.0;
  String codInsumo;
  String nome;

  InsumoAplicacao({
    required this.totalGasto,
    required this.nome,
    required this.dosagem,
    required this.codInsumo,
  });
}

Future<void> updateAplicacao(String nome, DateTime data, String? id) async {
  final conn = await mysqlconnector;

  var dataFormatada = intl.DateFormat('yyyy-MM-dd').format(data);

  var update = await conn.query(
      'update aplicacao set nome=?, data=? WHERE cod_aplicacao = ?',
      [nome, dataFormatada, id]);
}

Future<void> addInsumoAplicacaoList(
    String dosagem, String codAplicacao, String codInsumo) async {
  final conn = await mysqlconnector;

  var insert = await conn.query(
      // 'insert into plantio_x_insumo  set nome=?, area=? WHERE cod_Plantio = ?',
      'insert into aplicacao_x_insumo (dosagem, cod_aplicacao, cod_insumo) values (?, ?, ?)',
      [dosagem, codAplicacao, codInsumo]);
}

Future<void> updateInsumoAplicacaoList(
    String dosagem, String codAplicacao, String codInsumo) async {
  final conn = await mysqlconnector;

  var update = await conn.query(
      'update aplicacao_x_insumo  set dosagem=? WHERE cod_aplicacao = ? AND cod_insumo=?',
      [dosagem, codAplicacao, codInsumo]);
}

Future<void> deleteInsumoAplicacaoList(
    String? codAplicacao, String codInsumo) async {
  final conn = await mysqlconnector;

  var insert = await conn.query(
      // 'insert into plantio_x_insumo  set nome=?, area=? WHERE cod_Plantio = ?',
      'DELETE FROM aplicacao_x_insumo WHERE cod_aplicacao=? AND cod_insumo=?',
      [codAplicacao, codInsumo]);
}

Future<List<InsumoAplicacao>> getInsumosAplicacao(
    {String aplicacao = ''}) async {
  List<InsumoAplicacao> insumos = [];
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));

  var results = await conn.query(
      '''select dosagem,insumo.nome,aplicacao_x_insumo.cod_insumo,(dosagem*talhao.area) from aplicacao_x_insumo 
      JOIN aplicacao ON aplicacao_x_insumo.cod_aplicacao = aplicacao.cod_aplicacao
      JOIN plantio ON aplicacao.cod_plantio=plantio.cod_plantio
      JOIN talhao ON plantio.cod_talhao=talhao.cod_talhao
      JOIN insumo ON insumo.cod_insumo=aplicacao_x_insumo.cod_insumo
      WHERE aplicacao.cod_aplicacao=?''', [aplicacao]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]}');
    insumos.add(InsumoAplicacao(
      dosagem: row[0],
      codInsumo: '${row[2]}',
      nome: '${row[1]}',
      totalGasto: row[3],
    ));
  }

  return insumos;
}

// void main() => runApp(const MyHomePage());

Future<void> insertaplicacoes(
    String? nome, String? codPlantio, DateTime data) async {
  // List<Aplicacao> aplicacoes = [];
  final conn = await mysqlconnector;
  var dataFormatada = intl.DateFormat('yyyy-MM-dd').format(data);
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query(
      'insert into Aplicacao (nome, cod_plantio, data) values (?, ?, ?)',
      [nome, codPlantio, dataFormatada]);
}

// //GET all the farm fields
Future<List<Aplicacao>> getaplicacoes(
    {String? codSafra, String? codTalhao, String? codCultivar}) async {
  List<Aplicacao> aplicacoes = [];
  final conn = await mysqlconnector;

  if (codSafra == null) {
    return aplicacoes = [];
  }

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  // var results = await conn.query('select * from Aplicacao');
  // var results = await conn.query(
  //     """SELECT plantio.cod_plantio,plantio.nome,safra.nome,cultivar.nome,propriedade.nome,campo.nome,
  //       talhao.nome,plantio.data_inicio,plantio.data_fim,talhao.area FROM plantio
  //                       JOIN safra ON plantio.cod_safra = safra.cod_safra
  //                       JOIN cultivar ON plantio.cod_cultivar = cultivar.cod_cultivar
  //                       JOIN talhao on plantio.cod_talhao = talhao.cod_talhao
  //                       JOIN campo ON campo.cod_campo = talhao.cod_campo
  //                       JOIN propriedade ON propriedade.cod_propriedade = campo.cod_propriedade""");

  var results = await conn.query(
      """SELECT talhao.area,aplicacao.nome,campo.nome,propriedade.nome,aplicacao.cod_aplicacao,
      cultivar.nome,safra.nome,talhao.nome,aplicacao.data, plantio.nome FROM aplicacao
      JOIN plantio ON plantio.cod_plantio=aplicacao.cod_plantio
      JOIN safra ON plantio.cod_safra=safra.cod_safra
      JOIN talhao ON plantio.cod_talhao=talhao.cod_talhao
      JOIN campo ON talhao.cod_campo=campo.cod_campo
      JOIN propriedade ON propriedade.cod_propriedade=campo.cod_propriedade
      JOIN cultivar ON plantio.cod_cultivar=cultivar.cod_cultivar
      WHERE plantio.cod_safra=?""", [codSafra]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    aplicacoes.add(
      Aplicacao(
        area: row[0],
        nomePlantio: '${row[9]}',
        name: '${row[1]}',
        nomeCampo: '${row[2]}',
        nomePropriedade: '${row[3]}',
        codAplicacao: '${row[4]}',
        codCultivar: '${row[5]}',
        codSafra: '${row[6]}',
        codTalhao: '${row[7]}',
        data: '${row[8]}',
      ),
    );

    // print(aplicacoes[0]);
  }

  // print(aplicacoes);
  return aplicacoes;
}

// GET all the property fields
Future<List<Propriedade>> getPropriedades() async {
  List<Propriedade> propriedades = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var results = await conn.query('select * from propriedade');
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    propriedades.add(
      Propriedade(
          nome: '${row[2]}', codPropriedade: '${row[1]}', area: '${row[0]}'),
    );
  }
  // await conn.close();
  return propriedades;
}

Future<void> deleteAplicacao(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM Aplicacao WHERE cod_Aplicacao = ?', [id]);
  } catch (e) {
    // print(e);
  }
}

// class DialogUpdateAplicacao extends StatefulWidget {
//   const DialogUpdateAplicacao(
//       {Key? key, required this.codAplicacao, required this.nomeAplicacao})
//       : super(key: key);

//   final String codAplicacao;
//   final String nomeAplicacao;

//   @override
//   State<DialogUpdateAplicacao> createState() => _DialogUpdateaplicacoestate();
// }

// class _DialogUpdateaplicacoestate extends State<DialogUpdateAplicacao> {
//   final _formKey = GlobalKey<FormState>();
//   String? nome;
//   String? area;
//   DateTime date = DateTime.now();
//   // final _Aplicacao = Aplicacao();
//   @override
//   Widget build(BuildContext context) {
//     // DateTime date = DateTime.now();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF6200EE),
//         title: Text('Editar Aplicacao "' + widget.nomeAplicacao + '"'),
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
//                             updateAplicacao(nome!, area!, widget.codAplicacao);
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

class TelaAplicacoes extends StatefulWidget {
  static const routeName = '/aplicacao';
  const TelaAplicacoes({Key? key}) : super(key: key);

  @override
  State<TelaAplicacoes> createState() => _TelaAplicacoesState();
}

class _TelaAplicacoesState extends State<TelaAplicacoes> {
  late Future<List<Aplicacao>> futureAplicacao;
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
    futureAplicacao = getaplicacoes(
        codSafra: context.read<SafraProvider>().selectedSafra?.codSafra);
    futureSafra = getSafras();
    futureTalhao = getTalhoes();
    futureCultivar = getCultivares();
    futureInsumo = getInsumos();
  }

  void _handleUpdate() {
    futureAplicacao = getaplicacoes(
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
    // final List<Aplicacao> aplicacoes;
    // aplicacoes = getaplicacoes() as List<Aplicacao>;
    // final Aplicacao? Aplicacao1;
    // Aplicacao1 =
    //     const Aplicacao(name: "name", area: "25", cod_propriedade: 3, cod_Aplicacao: 4);
    // var Aplicacaocard = AplicacaoCard(Aplicacao: Aplicacao1);
    return
        // MaterialApp(
        //   title: 'Cardss',
        //   theme: ThemeData(
        //     primarySwatch: Colors.blue,
        //   ),
        // home:
        Scaffold(
      appBar: AppBar(
        title: const Text('Aplicações'),
      ),
      body: Center(
        child: FutureBuilder<List<Aplicacao>>(
            future: futureAplicacao,
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
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     FutureBuilder<List<Safra>>(
                        //         future: futureSafra,
                        //         builder: (context, propr) {
                        //           if (propr.hasData) {
                        //             return DropdownButton<Safra>(
                        //               hint: const Text('Safra'),
                        //               value: _selectedSafra,
                        //               icon: const Icon(Icons.arrow_drop_down),
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
                        //                     futureAplicacao = getaplicacoes();
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
                        //               icon: const Icon(Icons.arrow_drop_down),
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
                        //                     futureAplicacao = getaplicacoes();
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
                        //               icon: const Icon(Icons.arrow_drop_down),
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
                        //                     futureAplicacao = getaplicacoes();
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
                        ...?snapshot.data?.map((d) => AplicacaoCard(
                              aplicacao: d,
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
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () async {
          if (context.read<PropriedadProvider>().selectedPropriedade != null) {
            await showDialog(
              context: context,
              builder: (context) => DialogAddAplicacao(
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

class Aplicacao {
  String? name;
  double? area;
  String? nomePropriedade;
  String? nomeCampo;
  String? codAplicacao;
  String? codCultivar;
  String? codTalhao;
  String? codSafra;
  String? data;
  String? nomePlantio;

  Aplicacao({
    this.nomePlantio,
    this.area,
    this.nomeCampo,
    this.nomePropriedade,
    this.name,
    this.codAplicacao,
    this.codCultivar,
    this.codTalhao,
    this.codSafra,
    this.data,
  });
}

class AplicacaoCard extends StatelessWidget {
  final Aplicacao? aplicacao;
  // final Future<List<Insumo>> futureInsumo;
  // final String onChanded;
  final Future<List<InsumoAplicacao>> futureInsumo = getInsumosAplicacao();

  final Function onChanged;

  AplicacaoCard({
    this.aplicacao,
    required this.onChanged,
    Key? key,
    // this.insumo,
    // required this.futureInsumo,
    // required this.futureInsumo
  }) : super(key: key);

//   @override
//   State<AplicacaoCard> createState() => _AplicacaoCardState();
// }

// class _AplicacaoCardState extends State<AplicacaoCard> {
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
              title: Text(
                aplicacao!.name.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Id: ' + (aplicacao!.codAplicacao.toString()),
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
                            text: 'Área(ha): ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: aplicacao!.area!.toStringAsFixed(2),
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
                        // fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Data: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: aplicacao!.data,
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
                        // fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Safra: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: aplicacao!.codSafra,
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
                        // fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Propriedade: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: aplicacao!.nomePropriedade,
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
                        // fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Campo: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: aplicacao!.nomeCampo,
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
                          text: aplicacao!.codTalhao,
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
                          text: aplicacao!.codCultivar,
                        ),
                      ],
                    ),
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     'Safra: ' + Aplicacao!.codSafra,
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Expanded(
                //   child: Text('Talhão: ' + Aplicacao!.codTalhao,
                //       textAlign: TextAlign.center),
                // ),
                // Expanded(
                //   child: Text('Cultivar: ' + Aplicacao!.codCultivar,
                //       textAlign: TextAlign.center),
                // ),
              ],
            ),
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
                    'Lista de insumos:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Dosagem(L/ha):',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Total(L):',
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
            ////////////////////////////////////////////////////////////////////////////
            // FutureBuilder<List<Insumo>>(
            //     future: futureInsumo,
            //     builder: (context, propr) {
            //       if (propr.hasData) {
            //         return DropdownButton<Insumo>(
            //           hint: const Text('Insumo'),
            //           value: _selectedInsumo,
            //           icon: const Icon(Icons.arrow_downward),
            //           elevation: 16,
            //           style: const TextStyle(color: Colors.deepPurple),
            //           underline: Container(
            //             height: 2,
            //             color: Colors.deepPurpleAccent,
            //           ),
            //           onChanged: (Insumo? newValue) {
            //             setState(() {
            //               _selectedInsumo = newValue!;
            //             });
            //           },
            //           items: propr.data
            //               ?.map<DropdownMenuItem<Insumo>>((Insumo value) {
            //             return DropdownMenuItem<Insumo>(
            //               value: value,
            //               child: Text(value.nome),
            //               onTap: () {
            //                 // futureAplicacao = getaplicacoes();
            //                 //print(value.cod_propriedade);
            //               },
            //             );
            //           }).toList(),
            //         );
            //       } else if (propr.hasError) {
            //         return Text('${propr.error}');
            //       }
            //       return const CircularProgressIndicator();
            //     }),

            FutureBuilder<List<InsumoAplicacao>>(
                future: getInsumosAplicacao(
                    aplicacao: aplicacao!.codAplicacao.toString()),
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
                                child: Text(propr.data![index].nome,
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text(
                                    propr.data![index].dosagem
                                        .toStringAsFixed(2),
                                    textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text(
                                    propr.data![index].totalGasto
                                        .toStringAsFixed(2),
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
                                        builder: (context) =>
                                            DialogUpdateInsumoList(
                                              codPropriedade:
                                                  propr.data![index].nome,
                                              codAplicacao:
                                                  aplicacao!.codAplicacao,
                                              codInsumo:
                                                  propr.data![index].codInsumo,

                                              // nomeColheita: colheita!.name,
                                            )).then((_) {
                                      onChanged();
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  alignment: Alignment.center,
                                  onPressed: () async {
                                    await deleteInsumoAplicacaoList(
                                            aplicacao!.codAplicacao,
                                            propr.data![index].codInsumo)
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
                        builder: (context) => DialogAddInsumoList(
                              codAplicacao: aplicacao!.codAplicacao,
                            )).then((_) {
                      onChanged();
                    });
                  },
                  label: const Text('Adicionar insumo'),
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
                TextButton(
                  //textColor: const Color(0xFF6200EE),
                  onPressed: () async {
                    await showDialog<void>(
                        context: context,
                        builder: (context) => DialogUpdateAplicacao(
                              codAplicacao: aplicacao!.codAplicacao,
                              nomeAplicacao: aplicacao!.name,
                            )).then((_) {
                      onChanged();
                    });
                  },
                  child: const Icon(Icons.edit),
                ),
                TextButton(
                  //textColor: const Color(0xFF6200EE),
                  onPressed: () async {
                    await deleteAplicacao(aplicacao!.codAplicacao.toString())
                        .then((_) {
                      onChanged();
                    });

                    // print('Voce esta aqui');
                    // onChanged(Aplicacao!.cod_propriedade);

                    // _TelaaplicacoesState().futureAplicacao =
                    //     getaplicacoes(codPropriedade: Aplicacao!.cod_propriedade);
                    // Navigator.pop(context);
                    // Navigator.pushNamed(context, '/Aplicacao');
                    // Perform some action
                  },
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}

// class InsumoList extends StatelessWidget {
//   const InsumoList({Key? key, this.insumo}) : super(key: key);
//   final Insumo? insumo;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: const Icon(Icons.arrow_drop_down_circle),
//       title: Text(insumo!.nome),
//     );
//   }
// }

class DialogAddAplicacao extends StatefulWidget {
  const DialogAddAplicacao(
      {Key? key,
      required this.onChanged,
      required this.codPropriedade,
      required this.nome,
      required this.propriedadeSelecionada})
      : super(key: key);

  final String codPropriedade;
  final String nome;
  final Function onChanged;
  final Propriedade? propriedadeSelecionada;

  @override
  State<DialogAddAplicacao> createState() => _DialogAddAplicacaoState();
}

class _DialogAddAplicacaoState extends State<DialogAddAplicacao> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  DateTime date = DateTime.now();
  Plantio? _selectedPlantio;
  late Future<List<Plantio>> futurePlantio;

  @override
  void initState() {
    super.initState();
    futurePlantio = getPlantios(
        codSafra: context.read<SafraProvider>().selectedSafra?.codSafra);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
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
                    _FormDatePicker(
                      date: date,
                      onChanged: (value) {
                        // setState(() {
                        //   date = value;
                        // });
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
                            await insertaplicacoes(
                                    nome, _selectedPlantio!.codPlantio, date)
                                .then((_) => {widget.onChanged()});

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

class DialogAddInsumoList extends StatefulWidget {
  const DialogAddInsumoList({
    Key? key,
    this.codAplicacao,
    // required this.listInsumo,
    // required this.onChanged
  }) : super(key: key);
  // final ValueChanged onChanged;
  final String? codAplicacao;

  @override
  State<DialogAddInsumoList> createState() => _DialogAddInsumoListState();
}

class _DialogAddInsumoListState extends State<DialogAddInsumoList> {
  final _formKey = GlobalKey<FormState>();
  String? dosagem;
  Insumo? _selectedInsumo;
  late Future<List<Insumo>> futureInsumo;
  // final _campo = Campo();
  @override
  void initState() {
    super.initState();
    futureInsumo = getInsumos();
  }

  @override
  Widget build(BuildContext context) =>
      // return Scaffold(
      //   appBar: AppBar(
      //     backgroundColor: const Color(0xFF6200EE),
      //     title: Text('Editar propriedade "' + widget.nomePropriedade! + '"'),
      //   ),
      // body:
      AlertDialog(
        title: const Text('Adicionar insumo na aplicação'),
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
                        child: FutureBuilder<List<Insumo>>(
                            future: futureInsumo,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButton<Insumo>(
                                  isExpanded: true,
                                  hint: const Text('Insumo à adicionar'),
                                  value: _selectedInsumo,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (Insumo? newValue) {
                                    setState(() {
                                      _selectedInsumo = newValue!;
                                    });
                                  },
                                  items: snapshot.data
                                      ?.map<DropdownMenuItem<Insumo>>(
                                          (Insumo value) {
                                    return DropdownMenuItem<Insumo>(
                                      value: value,
                                      child: Text(value.nome),
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
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com a dosagem...',
                        labelText: 'Dosagem(L/ha)',
                      ),
                      onChanged: (value) {
                        setState(() {
                          dosagem = value;
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
                          onPressed: () async {
                            await addInsumoAplicacaoList(
                                dosagem!,
                                widget.codAplicacao!,
                                _selectedInsumo!.codInsumo);
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

class DialogUpdateInsumoList extends StatefulWidget {
  const DialogUpdateInsumoList({
    Key? key,
    this.codPropriedade,
    this.nomePropriedade,
    this.codInsumo,
    this.codAplicacao,
    // required this.onChanged
  }) : super(key: key);
  // final ValueChanged onChanged;
  final String? codPropriedade;
  final String? nomePropriedade;
  final String? codInsumo;
  final String? codAplicacao;

  @override
  State<DialogUpdateInsumoList> createState() => _DialogUpdateInsumoListState();
}

class _DialogUpdateInsumoListState extends State<DialogUpdateInsumoList> {
  final _formKey = GlobalKey<FormState>();
  String? dosagem;

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
        title: Text('Alterar quantidade de "' + widget.codPropriedade! + '"'),
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
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      ],
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Entre com a dosagem...',
                        labelText: 'Dosagem(L/ha)',
                      ),
                      onChanged: (value) {
                        setState(() {
                          dosagem = value;
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
                            updateInsumoAplicacaoList(dosagem!,
                                widget.codAplicacao!, widget.codInsumo!);
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

class DialogUpdateAplicacao extends StatefulWidget {
  const DialogUpdateAplicacao({
    Key? key,
    this.codAplicacao,
    this.nomeAplicacao,
    // required this.onChanged
  }) : super(key: key);
  // final ValueChanged onChanged;
  final String? codAplicacao;
  final String? nomeAplicacao;

  @override
  State<DialogUpdateAplicacao> createState() => _DialogUpdateAplicacaoState();
}

class _DialogUpdateAplicacaoState extends State<DialogUpdateAplicacao> {
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
        title: Text('Editar aplicação "' + widget.nomeAplicacao! + '"'),
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
                            updateAplicacao(nome!, date, widget.codAplicacao);
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
