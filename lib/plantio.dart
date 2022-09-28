import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:login_example/cardss.dart';
import 'package:login_example/cultivar.dart';
import 'package:provider/provider.dart';
import 'package:login_example/dashboard_screen.dart';
import 'package:login_example/safra.dart';
import 'package:login_example/talhao.dart';
import 'package:login_example/insumo.dart';
import 'package:login_example/propriedade.dart';
import 'conn.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';

class InsumoPlantio {
  var dosagem = 0.0;
  var totalGasto = 0.0;
  String codInsumo;
  String nome;

  InsumoPlantio({
    required this.totalGasto,
    required this.nome,
    required this.dosagem,
    required this.codInsumo,
  });
}

Future<List<InsumoPlantio>> getInsumosPlantio({String plantio = ''}) async {
  List<InsumoPlantio> insumos = [];
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));

  var results = await conn.query(
      '''select dosagem,insumo.nome,plantio_x_insumo.cod_insumo,(dosagem*talhao.area) from plantio_x_insumo 
      JOIN plantio ON plantio_x_insumo.cod_plantio = plantio.cod_plantio
      JOIN talhao ON plantio.cod_talhao=talhao.cod_talhao
                JOIN insumo ON insumo.cod_insumo=plantio_x_insumo.cod_insumo
                WHERE plantio.cod_plantio=?''', [plantio]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]}');
    insumos.add(InsumoPlantio(
      dosagem: row[0],
      codInsumo: '${row[2]}',
      nome: '${row[1]}',
      totalGasto: row[3],
    ));
  }

  return insumos;
}

// void main() => runApp(const MyHomePage());

Future<void> insertPlantios(
    String? nome,
    String? codTalhao,
    String? codCultivar,
    String? codSafra,
    DateTime? dataInicio,
    DateTime? dataFim) async {
  // List<Plantio> Plantios = [];
  final conn = await mysqlconnector;
  // print('Você está aqui!!');
  var dataInicioFormatada = intl.DateFormat('yyyy-MM-dd').format(dataInicio!);
  var dataFimFormatada = intl.DateFormat('yyyy-MM-dd').format(dataFim!);

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));
  var insert = await conn.query(
      'insert into plantio (nome, cod_safra, cod_cultivar,cod_talhao,data_inicio,data_fim) values (?, ?, ?, ?, ?, ?)',
      [
        nome,
        codSafra,
        codCultivar,
        codTalhao,
        dataInicioFormatada,
        dataFimFormatada,
      ]);
}

// //GET all the farm fields
Future<List<Plantio>> getPlantios(
    {String? codSafra, String? codTalhao, String? codCultivar}) async {
  List<Plantio> plantios = [];
  final conn = await mysqlconnector;
  if (codSafra == null) {
    return plantios = [];
  }

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(milliseconds: 500));
  // var results = await conn.query('select * from Plantio');
  var results = await conn.query(
      """SELECT plantio.cod_plantio,plantio.nome,safra.nome,cultivar.nome,propriedade.nome,campo.nome,
        talhao.nome,plantio.data_inicio,plantio.data_fim,talhao.area FROM plantio
                        JOIN safra ON plantio.cod_safra = safra.cod_safra
                        JOIN cultivar ON plantio.cod_cultivar = cultivar.cod_cultivar
                        JOIN talhao on plantio.cod_talhao = talhao.cod_talhao
                        JOIN campo ON campo.cod_campo = talhao.cod_campo
                        JOIN propriedade ON propriedade.cod_propriedade = campo.cod_propriedade
                         where plantio.cod_safra=?""", [codSafra]);
  for (var row in results) {
    // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    plantios.add(
      Plantio(
          area: row[9],
          name: '${row[1]}',
          nomeCampo: '${row[5]}',
          nomePropriedade: '${row[4]}',
          codPlantio: '${row[0]}',
          codCultivar: '${row[3]}',
          codSafra: '${row[2]}',
          codTalhao: '${row[6]}',
          dataInicio: '${row[7]}',
          dataFim: '${row[8]}'),
    );

    // print(Plantios[0]);
  }

  // print(plantios);
  return plantios;
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
//     // print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
//     propriedades.add(
//       Propriedade(
//           nome: '${row[2]}', codPropriedade: '${row[1]}', area: '${row[0]}'),
//     );
//   }
//   // await conn.close();
//   return propriedades;
// }

Future<void> deletePlantio(String id) async {
  try {
    final conn = await mysqlconnector;
    var delete =
        await conn.query('DELETE FROM Plantio WHERE cod_Plantio = ?', [id]);
  } catch (e) {
    // print(e);
  }
}

Future<void> updatePlantio(String? nome, DateTime? dataInicio,
    DateTime? dataFim, String? codPlantio) async {
  final conn = await mysqlconnector;

  var dataInicioFormatada = intl.DateFormat('yyyy-MM-dd').format(dataInicio!);
  var dataFimFormatada = intl.DateFormat('yyyy-MM-dd').format(dataFim!);

  var update = await conn.query(
      'update plantio  set nome=?, data_inicio=?, data_fim=? WHERE cod_plantio = ?',
      [nome, dataInicioFormatada, dataFimFormatada, codPlantio]);
}

Future<void> updateInsumoPlantioList(
    String dosagem, String codPlantio, String codInsumo) async {
  final conn = await mysqlconnector;

  var update = await conn.query(
      'update plantio_x_insumo  set dosagem=? WHERE cod_plantio = ? AND cod_insumo=?',
      [dosagem, codPlantio, codInsumo]);
}

Future<void> addInsumoList(
    String dosagem, String codPlantio, String codInsumo) async {
  final conn = await mysqlconnector;

  var insert = await conn.query(
      // 'insert into plantio_x_insumo  set nome=?, area=? WHERE cod_Plantio = ?',
      'insert into plantio_x_insumo (dosagem, cod_plantio, cod_insumo) values (?, ?, ?)',
      [dosagem, codPlantio, codInsumo]);
}

Future<void> deleteInsumoPlantioList(
    String codPlantio, String codInsumo) async {
  final conn = await mysqlconnector;

  var insert = await conn.query(
      // 'insert into plantio_x_insumo  set nome=?, area=? WHERE cod_Plantio = ?',
      'DELETE FROM plantio_x_insumo WHERE cod_plantio=? AND cod_insumo=?',
      [codPlantio, codInsumo]);
}

class TelaPlantios extends StatefulWidget {
  static const routeName = '/plantio';
  const TelaPlantios({Key? key}) : super(key: key);

  @override
  State<TelaPlantios> createState() => _TelaPlantiosState();
}

class _TelaPlantiosState extends State<TelaPlantios> {
  late Future<List<Plantio>> futurePlantio;
  late Future<List<Safra>> futureSafra;
  late Future<List<Talhao>> futureTalhao;
  late Future<List<Cultivar>> futureCultivar;

  Safra? _selectedSafra;
  Talhao? _selectedTalhao;
  Cultivar? _selectedCultivar;

  String dropdownValue = 'One';
  String holder = '';

  @override
  void initState() {
    super.initState();
    futurePlantio = getPlantios(
        codSafra: context.read<SafraProvider>().selectedSafra?.codSafra);
    futureSafra = getSafras();
    futureTalhao = getTalhoes();
    futureCultivar = getCultivares();
  }

  void _handleUpdate() {
    futurePlantio = getPlantios(
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
    // final List<Plantio> Plantios;
    // Plantios = getPlantios() as List<Plantio>;
    // final Plantio? Plantio1;
    // Plantio1 =
    //     const Plantio(name: "name", area: "25", cod_propriedade: 3, cod_Plantio: 4);
    // var Plantiocard = PlantioCard(Plantio: Plantio1);
    return
        // MaterialApp(
        //   title: 'Cardss',
        //   theme: ThemeData(
        //     primarySwatch: Colors.blue,
        //   ),
        // home:
        Scaffold(
      appBar: AppBar(
        title: const Text('Plantios'),
      ),
      body: Center(
        child: FutureBuilder<List<Plantio>>(
            future: futurePlantio,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    Column(
                      children: [
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
                        //                     futurePlantio = getPlantios();
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
                        //                     futurePlantio = getPlantios();
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
                        //                     futurePlantio = getPlantios();
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
                        ...?snapshot.data?.map((d) => PlantioCard(
                              plantio: d,
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
              builder: (context) => DialogAddPlantio(
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

class Plantio {
  String name;
  double? area;
  String? nomePropriedade;
  String? nomeCampo;
  String codPlantio;
  String codCultivar;
  String codTalhao;
  String codSafra;
  String dataInicio;
  String dataFim;

  Plantio({
    this.area,
    this.nomeCampo,
    this.nomePropriedade,
    required this.name,
    required this.codPlantio,
    required this.codCultivar,
    required this.codTalhao,
    required this.codSafra,
    required this.dataInicio,
    required this.dataFim,
  });
}

class PlantioCard extends StatelessWidget {
  final Plantio? plantio;
  // final Future<List<Insumo>> futureInsumo;
  // final String onChanded;
  // final Future<List<InsumoPlantio>> futureInsumo = getInsumosPlantio();

  final Function onChanged;

  PlantioCard({
    this.plantio,
    required this.onChanged,
    Key? key,
    // this.insumo,
    // required this.futureInsumo,
    // required this.futureInsumo
  }) : super(key: key);

//   @override
//   State<PlantioCard> createState() => _PlantioCardState();
// }

// class _PlantioCardState extends State<PlantioCard> {
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
                plantio!.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Id: ' + (plantio!.codPlantio.toString()),
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
                          text: plantio!.area!.toStringAsFixed(2),
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
                          text: plantio!.codSafra,
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
                          text: plantio!.nomePropriedade,
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
                          text: plantio!.nomeCampo,
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
                          text: plantio!.codTalhao,
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
                          text: plantio!.codCultivar,
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
                  child: Text(plantio!.dataInicio, textAlign: TextAlign.center),
                ),
                // Expanded(
                //   child:
                //       Text('Craft beautiful UIs', textAlign: TextAlign.center),
                // ),
                Expanded(
                  child: Text(plantio!.dataFim, textAlign: TextAlign.center),
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

            FutureBuilder<List<InsumoPlantio>>(
                future: getInsumosPlantio(plantio: plantio!.codPlantio),
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
                                              codPlantio: plantio!.codPlantio,
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
                                    await deleteInsumoPlantioList(
                                            plantio!.codPlantio,
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
                              codPlantio: plantio!.codPlantio,
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
                TextButton.icon(
                  //textColor: const Color(0xFF6200EE),
                  onPressed: () async {
                    await showDialog<void>(
                        context: context,
                        builder: (context) => DialogUpdatePlantio(
                              codPlantio: plantio!.codPlantio,
                              nomePlantio: plantio!.name,
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
                    await deletePlantio(plantio!.codPlantio).then((_) {
                      onChanged();
                    });

                    // print('Voce esta aqui');
                    // onChanged(plantio!.cod_propriedade);

                    // _TelaPlantiosState().futurePlantio =
                    //     getPlantios(codPropriedade: Plantio!.cod_propriedade);
                    // Navigator.pop(context);
                    // Navigator.pushNamed(context, '/Plantio');
                    // Perform some action
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Excluir'),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DialogAddPlantio extends StatefulWidget {
  const DialogAddPlantio(
      {Key? key,
      required this.codPropriedade,
      required this.nome,
      required this.propriedadeSelecionada,
      required this.onChanged})
      : super(key: key);

  final String codPropriedade;
  final String nome;
  final Propriedade? propriedadeSelecionada;
  final Function onChanged;

  @override
  State<DialogAddPlantio> createState() => _DialogAddPlantioState();
}

class _DialogAddPlantioState extends State<DialogAddPlantio> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? area;
  Cultivar? _selectedCultivar;
  DateTime date = DateTime.now();
  late Future<List<Cultivar>> futureCultivar;

  @override
  void initState() {
    super.initState();
    futureCultivar = getCultivares();
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
                        child: FutureBuilder<List<Cultivar>>(
                            future: futureCultivar,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButton<Cultivar>(
                                  hint: const Text('Selecionar cultivar'),
                                  value: _selectedCultivar,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  isExpanded: true,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (Cultivar? newValue) {
                                    setState(() {
                                      _selectedCultivar = newValue!;
                                    });
                                  },
                                  items: snapshot.data
                                      ?.map<DropdownMenuItem<Cultivar>>(
                                          (Cultivar value) {
                                    return DropdownMenuItem<Cultivar>(
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
                            await insertPlantios(
                                    nome,
                                    context
                                        .read<TalhaoProvider>()
                                        .selectedTalhao!
                                        .codTalhao,
                                    _selectedCultivar!.codCultivar,
                                    context
                                        .read<SafraProvider>()
                                        .selectedSafra!
                                        .codSafra,
                                    date,
                                    date)
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

class DialogUpdateInsumoList extends StatefulWidget {
  const DialogUpdateInsumoList({
    Key? key,
    this.codPropriedade,
    this.nomePropriedade,
    this.codInsumo,
    this.codPlantio,
    // required this.onChanged
  }) : super(key: key);
  // final ValueChanged onChanged;
  final String? codPropriedade;
  final String? nomePropriedade;
  final String? codInsumo;
  final String? codPlantio;

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
                            updateInsumoPlantioList(dosagem!,
                                widget.codPlantio!, widget.codInsumo!);
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

class DialogUpdatePlantio extends StatefulWidget {
  const DialogUpdatePlantio({
    Key? key,
    this.codPlantio,
    this.nomePlantio,
    // required this.onChanged
  }) : super(key: key);
  // final ValueChanged onChanged;
  final String? codPlantio;
  final String? nomePlantio;

  @override
  State<DialogUpdatePlantio> createState() => _DialogUpdatePlantioState();
}

class _DialogUpdatePlantioState extends State<DialogUpdatePlantio> {
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
        title: Text('Editar plantio "' + widget.nomePlantio! + '"'),
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
                          onPressed: () async {
                            await updatePlantio(
                                nome, date, date, widget.codPlantio);
                            Navigator.pop(context);
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
    this.codPlantio,
    // required this.listInsumo,
    // required this.onChanged
  }) : super(key: key);
  // final ValueChanged onChanged;
  final String? codPlantio;

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
        title: const Text('Adicionar insumo no plantio'),
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
                          onPressed: () {
                            addInsumoList(dosagem!, widget.codPlantio!,
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
