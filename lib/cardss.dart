import 'package:flutter/material.dart';
import 'conn.dart';

//GET all the farm fields
Future getCampo() async {
  final conn = await mysqlconnector;

  //var conn = await MySqlConnection.connect(settings);
  await Future.delayed(const Duration(seconds: 1));

  var results = await conn.query(
      'select name, area, cod_campo, cod_propriedade from campo where cod_campo = ?',
      [1]);
  for (var row in results) {
    print(
        'Name: ${row[0]}, area: ${row[1]}, cod_propriedade:${row[3]}, cod_campo: ${row[2]}');
    Campo(
        name: '${row[0]}',
        area: '${row[1]}',
        cod_propriedade: '${row[3]}',
        cod_campo: '${row[2]}');
  }
  await conn.close();
  return results;
}

final campos = [
  // Demo(
  //   name: 'Sign in with HTTP',
  //   route: '/signin_http',
  //   builder: (context) => SignInHttpDemo(
  //     // This sample uses a mock HTTP client.
  //     httpClient: mockClient,
  //   ),
  // ),
  // Demo(
  //   name: 'Autofill',
  //   route: '/autofill',
  //   builder: (context) => const AutofillDemo(),
  // ),
  const Campo(name: 'Campo1', area: '1', cod_propriedade: '1', cod_campo: '1'),
  const Campo(name: 'Campo2', area: '2', cod_propriedade: '2', cod_campo: '2'),
  const Campo(name: 'Campo3', area: '3', cod_propriedade: '3', cod_campo: '3'),
  const Campo(name: 'Campo4', area: '4', cod_propriedade: '4', cod_campo: '4'),
  const Campo(name: 'Campo5', area: '5', cod_propriedade: '5', cod_campo: '5'),

  // Demo(
  //   name: 'Validation',
  //   route: '/validation',
  //   builder: (context) => const FormValidationDemo(),
  // ),
  // Demo(
  //   name: 'Logout',
  //   route: '/login',
  //   builder: (context) => const SignUpScreen(),
  // ),
  // Demo(
  //   name: 'Logout',
  //   route: '/welcome',
  //   builder: (context) => const FormApp(),
  // ),
];

class Cardss extends StatelessWidget {
  static const routeName = '/cardss';
  const Cardss({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyHomePage(
        // title: 'Flutter Demo',
        // debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //     //buttonColor: Colors.blue,
        //     ),
        // body: const MyHomePage(),
        );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campos'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              //       ListTile(
              //         leading: const Icon(Icons.arrow_drop_down_circle),
              //         title: const Text('Card title 1'),
              //         subtitle: Text(
              //           'Secondary Text',
              //           style: TextStyle(color: Colors.black.withOpacity(0.6)),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: Text(
              //           'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
              //           style: TextStyle(color: Colors.black.withOpacity(0.6)),
              //         ),
              //       ),
              //       ButtonBar(
              //         alignment: MainAxisAlignment.start,
              //         children: [
              //           TextButton(
              //             //textColor: const Color(0xFF6200EE),
              //             onPressed: () {
              //               // Perform some action
              //             },
              //             child: const Text('ACTION 1'),
              //           ),
              //           TextButton(
              //             //textColor: const Color(0xFF6200EE),
              //             onPressed: () {
              //               // Perform some action
              //             },
              //             child: const Text('ACTION 2'),
              //           ),
              //         ],
              //       ),
              //       //Image.asset('assets/card-sample-image.jpg'),
              //     ],
              //   ),
              // ),
              ...campos.map((d) => CampoCard(campo: d)),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          //showDialog<void>(context: context, builder: (context) => dialog);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute<void>(
          //     builder: (BuildContext context) => const SimpleDialog(),
          //     // fullscreenDialog: true,
          //   ),
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Campo {
  final String name;
  final String area;
  final String cod_propriedade;
  final String cod_campo;

  const Campo(
      {required this.name,
      required this.area,
      required this.cod_propriedade,
      required this.cod_campo});
}

class CampoCard extends StatelessWidget {
  final Campo? campo;
  const CampoCard({this.campo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_drop_down_circle),
            title: Text(campo!.name),
            subtitle: Text(
              campo!.area,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () {
                  // Perform some action
                },
                child: const Text('Editar'),
              ),
              TextButton(
                //textColor: const Color(0xFF6200EE),
                onPressed: () {
                  // Perform some action
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
          //Image.asset('assets/card-sample-image.jpg'),
        ],
      ),
    );
  }
}
