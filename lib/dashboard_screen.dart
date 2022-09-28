import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_login/theme.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_login/widgets.dart';
import 'package:login_example/campo.dart';
import 'package:login_example/app.dart';
import 'package:login_example/safra.dart';
// import 'package:collection/collection.dart;
import 'package:login_example/talhao.dart';
import 'package:provider/provider.dart';
import 'package:login_example/propriedade.dart';
import 'transition_route_observer.dart';
import 'widgets/fade_in.dart';
import 'constants.dart';
import 'form_widgets.dart';
import 'widgets/animated_numeric_text.dart';
import 'widgets/round_button.dart';

final demos = [
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
  Demo(
    name: 'Form widgets',
    route: '/form_widgets',
    builder: (context) => const FormWidgetsDemo(),
  ),
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

class Atualizar with ChangeNotifier {
  late Future<List<Campo>> futureCampo;
  List<Campo> listCampo = [];
  String? currentPropriedade;

  void toList() async {
    listCampo = await futureCampo;
    notifyListeners();
  }

  void increment(String id) {
    currentPropriedade = id;
    futureCampo = getCampos(codPropriedade: id);
    notifyListeners();
  }
}

class DropDownPropriedades extends StatefulWidget {
  const DropDownPropriedades({Key? key}) : super(key: key);

  @override
  State<DropDownPropriedades> createState() => _DropDownPropriedadesState();
}

class _DropDownPropriedadesState extends State<DropDownPropriedades> {
  Propriedade? _selectedPropriedade;

  @override
  void initState() {
    super.initState();
    context.read<PropriedadProvider>().toList();
  }

  @override
  Widget build(BuildContext context) {
    _selectedPropriedade =
        context.read<PropriedadProvider>().selectedPropriedade;
    var propriedades = context.read<PropriedadProvider>();
    // print(propriedades.emptyField);

    // propriedades.toList();

    // print(context.read<PropriedadProvider>().listPropriedade[0].hashCode);
    // final index = propriedades.listPropriedade.indexWhere((_selecionada) =>
    //     _selecionada.nome == propriedades.selectedPropriedade?.nome);
    // print(index);
    // if (index < 0) {
    //   propriedades.emptyField = false;
    // }
    // print(propriedades.backup?.nome);
    // if (propriedades.listPropriedade.contains(propriedades.backup)) {
    //   print('Aqui estamos mais um dia');
    //   propriedades.getSelected(propriedades.backup);
    // }

    // if (propriedades.listPropriedade
    //     .any((element) => element.nome == propriedades.backup?.nome)) {
    //   // propriedades.getSelected(element);
    //   print('Vasdasdasdasdasd');
    //   final resultado = propriedades.listPropriedade
    //       .firstWhere((element) => element.nome == propriedades.backup!.nome);
    //   propriedades.getSelected(resultado);
    // }

    // if (propriedades.listPropriedade
    //     .any((element) => element.nome == propriedades.backup?.nome)) {
    //   propriedades.getSelected(element);
    // }

    return Expanded(
      child: Consumer<PropriedadProvider>(
        builder: (context, propriedadeProvider, child) =>
            DropdownButton<Propriedade>(
          isExpanded: true,
          hint: const Text('Selecionar propriedade'),
          value: propriedades.emptyField
              ? propriedadeProvider.listPropriedade[propriedadeProvider.index]
              : null,

          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          // style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Propriedade? newValue) {
            setState(() {
              if (propriedadeProvider.selectedPropriedade != newValue!) {
                propriedadeProvider.getSelected(newValue);
                var up = context.read<PropriedadProvider>();
                var index = propriedadeProvider.listPropriedade.indexWhere(
                    (_selecionada) =>
                        _selecionada.nome ==
                        propriedadeProvider.selectedPropriedade!.nome);
                propriedadeProvider.findit(index);
                up.onChangedTrue();
                _selectedPropriedade = newValue;
                var atualizar = context.read<PropriedadProvider>();
                atualizar.incrementCampo(_selectedPropriedade!.nome,
                    _selectedPropriedade!.codPropriedade);
                atualizar.toListCampo();
                atualizar.incrementSafra(_selectedPropriedade!.nome,
                    _selectedPropriedade!.codPropriedade);
                atualizar.toListSafra();
                // atualizar.onChangedSafraFalse();
                // atualizar.onChangedFalse();
                var talhoes = context.read<CampoProvider>();
                // talhoes.onChangedFalse();
                talhoes.emptyList();
                // var safras = context.read<SafraProvider>();
                // safras.onChangedFalse();
                // safras.emptyList();

                context.read<PropriedadProvider>().getSelected(newValue);
                context.read<CampoProvider>().getSelected(null);
                context.read<SafraProvider>().getSelected(null);
                context.read<TalhaoProvider>().getSelected(null);
              }
            });
          },
          items: propriedadeProvider.listPropriedade
              .map<DropdownMenuItem<Propriedade>>((Propriedade value) {
            return DropdownMenuItem<Propriedade>(
              value: value,
              child: Text(value.codPropriedade + ' ' + value.nome),
              onTap: () {},
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DropDownSafras extends StatefulWidget {
  const DropDownSafras({Key? key}) : super(key: key);

  @override
  State<DropDownSafras> createState() => _DropDownSafrasState();
}

class _DropDownSafrasState extends State<DropDownSafras> {
  Safra? _selectedSafra;

  @override
  Widget build(BuildContext context) {
    var callback = context.read<PropriedadProvider>();

    _selectedSafra = context.read<SafraProvider>().selectedSafra;
    var safras = context.read<SafraProvider>();
    safras.toList();
    return Expanded(
      child: Consumer<PropriedadProvider>(
        builder: (context, propriedadeProvider, child) => DropdownButton<Safra>(
          isExpanded: true,
          hint: const Text('Selecionar safra'),
          value: callback.emptyFieldSafra
              ? context.read<SafraProvider>().selectedSafra
              : null,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          // style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Safra? newValue) {
            setState(() {
              if (context.read<SafraProvider>().selectedSafra != newValue!) {
                callback.onChangedSafraTrue();
                // if (propriedadeProvider.listSafra.contains(newValue)) {
                //   callback.onChangedTrue();
                //   // print(campoProvider.emptyField);
                // }

                context.read<SafraProvider>().getSelected(newValue);
                // print(context.read<SafraProvider>().selectedSafra!.codSafra);
                // callback.onChangedTrue();
              }
            });
          },
          items: propriedadeProvider.listSafra
              .map<DropdownMenuItem<Safra>>((Safra value) {
            return DropdownMenuItem<Safra>(
              value: value,
              child: Text(value.codSafra + ' ' + value.nome),
              onTap: () {},
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DropDownTalhoes extends StatefulWidget {
  const DropDownTalhoes({Key? key}) : super(key: key);

  @override
  State<DropDownTalhoes> createState() => _DropDownTalhoesState();
}

class _DropDownTalhoesState extends State<DropDownTalhoes> {
  Talhao? _selectedTalhao;
  // final Future<List<Campo>> futureCampo;

  @override
  Widget build(BuildContext context) {
    _selectedTalhao = context.read<TalhaoProvider>().selectedTalhao;
    var callback = context.read<CampoProvider>();

    return Expanded(
      child: Consumer<CampoProvider>(
        builder: (context, campoProvider, child) => DropdownButton<Talhao>(
          isExpanded: true,
          hint: const Text('Selecionar talhão'),
          value: callback.emptyField
              ? context.read<TalhaoProvider>().selectedTalhao
              : null,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          // style: const TextStyle(
          //     color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Talhao? newValue) {
            setState(() {
              // callback.onChangedTrue();
              if (campoProvider.listTalhao.contains(newValue)) {
                // callback.emptyField == true;
                _selectedTalhao = newValue!;
                var talhao = context.read<TalhaoProvider>();
                talhao.increment(
                    _selectedTalhao!.nome, _selectedTalhao!.codTalhao);
                // print(newValue);
                context.read<TalhaoProvider>().getSelected(newValue);
                talhao.onChangedFalse();
                callback.onChangedTrue();
              }
            });
          },
          items: campoProvider.listTalhao
              .map<DropdownMenuItem<Talhao>>((Talhao value) {
            return DropdownMenuItem<Talhao>(
              value: value,
              child: Text(value.codTalhao + ' ' + value.nome),
              // onTap: () {},
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DemoT extends StatefulWidget {
  const DemoT({Key? key}) : super(key: key);

  // final ValueChanged onChanged;
  // final List<Campo> futureCampo;

  @override
  State<DemoT> createState() => _DemoTState();
}

class _DemoTState extends State<DemoT> {
  Campo? _selectedCampo;
  // final Future<List<Campo>> futureCampo;

  @override
  Widget build(BuildContext context) {
    _selectedCampo = context.read<CampoProvider>().selectedCampo;
    // _selectedCampo = widget.selectedCampo;
    var callback = context.read<PropriedadProvider>();
    // if (widget.aviso == null) {
    //   _selectedCampo = null;
    // }

    return Expanded(
      child: Consumer<PropriedadProvider>(
        builder: (context, propriedadeProvider, child) => DropdownButton<Campo>(
          isExpanded: true,
          hint: const Text('Selecionar campo'),
          value: callback.emptyFieldCampo
              ? context.read<CampoProvider>().selectedCampo
              : null,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          // style: const TextStyle(
          //     color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Campo? newValue) {
            setState(() {
              if (context.read<CampoProvider>().selectedCampo != newValue!) {
                _selectedCampo = newValue;
                callback.onChangedCampoTrue();
                var campoProvider = context.read<CampoProvider>();
                campoProvider.increment(
                    _selectedCampo!.nome, _selectedCampo!.codCampo);
                campoProvider.toList();
                context.read<CampoProvider>().getSelected(newValue);

                campoProvider.onChangedFalse();
                context.read<TalhaoProvider>().getSelected(null);

                // callback.onChangedTrue();
                // print(campoProvider.emptyField);
              }
            });
          },
          items: propriedadeProvider.listCampo
              .map<DropdownMenuItem<Campo>>((Campo value) {
            return DropdownMenuItem<Campo>(
              value: value,
              child: Text(value.codCampo + ' ' + value.nome),
              // onTap: () {},
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DemoTile extends StatelessWidget {
  final Demo? demo;

  const DemoTile({this.demo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(demo!.name),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, demo!.route);
      },
    );
  }
}

class Demo {
  final String name;
  final String route;
  final WidgetBuilder builder;

  const Demo({required this.name, required this.route, required this.builder});
}

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/auth')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  Propriedade? _selectedPropriedade;
  Campo? _selectedCampo;
  Talhao? _selectedTalhao;
  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  late Future<List<Propriedade>> futurePropriedade;
  late Future<List<Campo>> futureCampo;
  late Future<List<Talhao>> futureTalhao;
  AnimationController? _loadingController;
  late List<Campo> futureabc;

  @override
  void initState() {
    super.initState();
    futurePropriedade = getPropriedades();
    futureCampo = getCampos();
    futureTalhao = getTalhoes();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
      parent: _loadingController!,
      curve: headerAniInterval,
    ));
  }

  void _handleUpdate() {
    futurePropriedade = getPropriedades();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute<dynamic>?);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }

  void _handleSelected() {
    setState(() {});
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  AppBar _buildAppBar(ThemeData theme) {
    // drawer: Drawer(
    //   child:ListView(
    //     padding: EdgeInsets.zero,
    //     children:[
    //       ListTile(
    //         title: const Text('Sign in with HTTP'),
    //         onTap:(){
    //
    //         },
    //       ),
    //     ],
    //   ),
    // );
    // final menuBtn = IconButton(
    //   color: theme.colorScheme.secondary,
    //   icon: const Icon(FontAwesomeIcons.bars),
    //   onPressed: () {},
    // );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      // color: theme.colorScheme.secondary,
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 8.0),
          //   child:
          Hero(
            tag: Constants.logoTag,
            child: Image.asset(
              'assets/images/gpagri.png',
              filterQuality: FilterQuality.high,
              height: 70,
            ),
          ),
          // ),
          // HeroText(
          //   'GPAGRI',
          //   tag: Constants.titleTag,
          //   viewState: ViewState.shrunk,
          //   style: LoginThemeHelper.loginTextStyle,
          // ),
          // const SizedBox(width: 5),
        ],
      ),
    );

    return AppBar(
      // leading: FadeIn(
      //   controller: _loadingController,
      //   offset: .3,
      //   curve: headerAniInterval,
      //   fadeDirection: FadeDirection.startToEnd,
      // child: Drawer(
      //   child: ListView(
      //       padding: EdgeInsets.zero,
      //
      //       children:[
      //   ListTile(
      //   title: const Text('Sign in with HTTP'),
      //   onTap: () {
      //     Navigator.pushNamed(context, '/form_widgets');
      //   },
      // ),
      // ],
      //   ),
      // ),
      // ),
      actions: <Widget>[
        FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: signOutBtn,
        ),
      ],

      title: title,
      // backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      // toolbarTextStyle: TextStle(),
      // textTheme: theme.accentTextTheme,
      // iconTheme: theme.accentIconTheme,
    );
  }

  Widget _buildButton(
      {Widget? icon, String? label, required Interval interval}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: const ElasticOutCurve(0.42),
      ),
      onPressed: () {},
    );
  }

  String _value = '';

  void _onChanged(String value) {
    setState(() => _value = 'Change: $value');
  }

  void _onSubmit(String value) {
    setState(() => _value = 'Submit: $value');
  }

  Widget _contextSection(Propriedade? propriedade) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(_value),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Hello',
                  hintText: 'Hint',
                  icon: Icon(Icons.people)),
              autocorrect: true,
              autofocus: true,

              //displaying number keyboard
              //keyboardType: TextInputType.number,

              //displaying text keyboard
              keyboardType: TextInputType.text,

              onChanged: _onChanged,
              onSubmitted: _onSubmit,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var propriedades = context.read<PropriedadProvider>();

    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(child: Text('Selecionar:')),
                ),
                const Divider(
                  height: 8,
                ),
                // ListTile(
                //   title: const Text('Propriedades'),
                //   onTap: () {
                //     Navigator.pushNamed((context), '/propriedade');
                //   },
                // ),
                ListTile(
                  title: const Text('Campos'),
                  onTap: () {
                    Navigator.pushNamed((context), '/campo');
                  },
                ),
                const Divider(
                  height: 8,
                ),
                ListTile(
                  title: const Text('Talhões'),
                  onTap: () {
                    Navigator.pushNamed((context), '/talhao');
                  },
                ),
                const Divider(
                  height: 8,
                ),
                ListTile(
                  title: const Text('Safras'),
                  onTap: () {
                    Navigator.pushNamed((context), '/safra');
                  },
                ),
                const Divider(
                  height: 8,
                ),
                ListTile(
                  title: const Text('Insumos'),
                  onTap: () {
                    Navigator.pushNamed((context), '/insumo');
                  },
                ),
                const Divider(
                  height: 8,
                ),
                ListTile(
                  title: const Text('Plantio'),
                  onTap: () {
                    Navigator.pushNamed((context), '/plantio');
                  },
                ),
                const Divider(
                  height: 8,
                ),
                ListTile(
                  title: const Text('Culturas'),
                  onTap: () {
                    Navigator.pushNamed((context), '/cultura');
                  },
                ),
                const Divider(
                  height: 8,
                ),
                ListTile(
                  title: const Text('Cultivares'),
                  onTap: () {
                    Navigator.pushNamed((context), '/cultivar');
                  },
                ),
                const Divider(
                  height: 8,
                ),
                ListTile(
                  title: const Text('Aplicação'),
                  onTap: () {
                    Navigator.pushNamed((context), '/aplicacao');
                  },
                ),
                const Divider(
                  height: 8,
                ),
                ListTile(
                  title: const Text('Colheita'),
                  onTap: () {
                    Navigator.pushNamed((context), '/colheita');
                  },
                ),
                // const Divider(
                //   height: 8,
                // ),
                // ListTile(
                //   title: const Text('Relatório'),
                //   onTap: () {
                //     Navigator.pushNamed((context), '/relatorio');
                //   },
                // ),
                const Divider(
                  height: 8,
                ),
                ListTile(
                  title: const Text('Relatório'),
                  onTap: () {
                    Navigator.pushNamed((context), '/myapp');
                  },
                ),
              ],
            ),
          ),
          body: Center(
            child: FutureBuilder<List<Propriedade>>(
                future: propriedades.futurePropriedade,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        Row(
                          children: [
                            Card(
                              child: Consumer<PropriedadProvider>(
                                builder: (context, counter, child) =>
                                    counter.selectedPropriedade?.nome != null
                                        ? Text(
                                            counter.selectedPropriedade!.nome,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.5),
                                          )
                                        : Container(),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios),
                            Card(
                              child: Consumer<CampoProvider>(
                                builder: (context, counter, child) =>
                                    counter.selectedCampo?.nome != null
                                        ? Text(
                                            counter.selectedCampo!.nome,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.5),
                                          )
                                        : Container(),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios),
                            Card(
                              child: Consumer<TalhaoProvider>(
                                builder: (context, counter, child) =>
                                    counter.selectedTalhao?.nome != null
                                        ? Text(
                                            counter.selectedTalhao!.nome,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.5),
                                          )
                                        : Container(),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios),
                            Card(
                              child: Consumer<SafraProvider>(
                                builder: (context, counter, child) =>
                                    counter.selectedSafra?.nome != null
                                        ? Text(
                                            counter.selectedSafra!.nome,
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.5),
                                          )
                                        : Container(),
                              ),
                            ),
                            // const Spacer(),
                            // TextButton.icon(
                            //   //textColor: const Color(0xFF6200EE),
                            //   onPressed: () {
                            //     // Perform some action
                            //     Navigator.pushNamed((context), '/campo');
                            //     // getCampos(codPropriedade: propriedade!.Aplicacao);
                            //   },
                            //   label: const Text('Ver campos'),
                            //   icon: const Icon(Icons.remove_red_eye),
                            // ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     FutureBuilder<List<Propriedade>>(
                        //         future: getPropriedades(),
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
                        //                   child: Text(value.Aplicacao +
                        //                       ' ' +
                        //                       value.nome),
                        //                   onTap: () {
                        //                     // futureCampo = getCampos(
                        //                     //     codPropriedade:
                        //                     //         value.codPropriedade);
                        //                     // print(value.codPropriedade);
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

                        const Divider(
                          height: 8,
                        ),
                        Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          semanticContainer: true,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // if you need this
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Row(
                              //   children: [
                              // Flexible(
                              //   child: TextField(
                              //     onChanged: (text) {
                              //       // NEW
                              //       setState(() {
                              //         // NEW
                              //         // _isComposing = text.isNotEmpty; // NEW
                              //       }); // NEW
                              //     }, // NEW
                              //     // onSubmitted: _isComposing ? _handleSubmitted : null,
                              //     decoration: const InputDecoration(
                              //         hintText: 'Pesquisar propriedade'),
                              //     // focusNode: _focusNode,
                              //   ),
                              // ),
                              // Container(
                              //   margin: const EdgeInsets.symmetric(
                              //       horizontal: 4.0),
                              //   child: // MODIFIED
                              //       TextButton.icon(
                              //           // MODIFIED
                              //           label: const Text('Buscar'),
                              //           icon: const Icon(Icons.search),
                              //           onPressed: () {}),
                              // ),
                              //   ],
                              // ),
                              Row(
                                children: [],
                              ),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Suas propriedades',
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .apply(fontSizeFactor: 2.0),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 8,
                              ),
                              ...?snapshot.data?.map((d) => PropriedadeCard(
                                  propriedade: d, onChanged: _handleUpdate)),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                }),
            // child: ListView(
            //   children: [
            //     // Column(
            //     //   children: [
            //     //     ...campos.map((d) => CampoCard(campo: d)),
            //     //     // campocard,
            //     //   ],
            //     // ),
            //   ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff03dac6),
            foregroundColor: Colors.black,
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (context) => DialogUpdateTeste(
                  onChanged: _handleUpdate,
                  update: didChangeDependencies,
                ),
              ).then((_) {
                // _handleUpdate();
              });
            },
            tooltip: 'Nova propriedade',
            child: const Icon(Icons.add),
          ),
          // Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   color: theme.primaryColor.withOpacity(.1),
          //   child: Stack(
          //     children: <Widget>[
          //       Column(
          //         children: <Widget>[
          //           const SizedBox(height: 40),
          //           Expanded(
          //             flex: 8,
          //             child: ShaderMask(
          //               // blendMode: BlendMode.srcOver,
          //               shaderCallback: (Rect bounds) {
          //                 return LinearGradient(
          //                   begin: Alignment.topLeft,
          //                   end: Alignment.bottomRight,
          //                   tileMode: TileMode.clamp,
          //                   colors: <Color>[
          //                     Colors.deepPurpleAccent.shade100,
          //                     Colors.deepPurple.shade100,
          //                     Colors.deepPurple.shade100,
          //                     Colors.deepPurple.shade100,
          //                     // Colors.red,
          //                     // Colors.yellow,
          //                   ],
          //                 ).createShader(bounds);
          //               },
          //               child: _buildDashboardGrid(),
          //             ),
          //           ),
          //         ],
          //       ),
          //       // if (!kReleaseMode) _buildDebugButtons(),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}

class PropriedadeContext extends StatefulWidget {
  const PropriedadeContext({Key? key}) : super(key: key);

  @override
  State<PropriedadeContext> createState() => _PropriedadeContext();
}

class _PropriedadeContext extends State<PropriedadeContext> {
  Propriedade? _selectedPropriedade;
  @override
  Widget build(BuildContext context) {
    var propriedades = context.read<PropriedadProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<List<Propriedade>>(
            future: propriedades.futurePropriedade,
            builder: (context, propr) {
              if (propr.hasData) {
                return DropdownButton<Propriedade>(
                  hint: const Text('Selecionar propriedade'),
                  value: _selectedPropriedade,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (Propriedade? newValue) {
                    setState(() {
                      _selectedPropriedade = newValue!;
                    });
                  },
                  items: propr.data
                      ?.map<DropdownMenuItem<Propriedade>>((Propriedade value) {
                    return DropdownMenuItem<Propriedade>(
                      value: value,
                      child: Text(value.codPropriedade + ' ' + value.nome),
                      onTap: () {
                        // futureCampo = getCampos(
                        //     codPropriedade:
                        //         value.codPropriedade);
                        // print(value.codPropriedade);
                      },
                    );
                  }).toList(),
                );
              } else if (propr.hasError) {
                return Text('${propr.error}');
              }
              return const CircularProgressIndicator();
            }),
      ],
    );
  }
}

class MyApp extends StatefulWidget {
  final Propriedade? propriedade;
  const MyApp({Key? key, this.propriedade}) : super(key: key);

  @override
  _State createState() => _State();
}

//State is information of the application that can change over time or when some actions are taken.
class _State extends State<MyApp> {
  String _value = '';

  void _onChanged(String value) {
    setState(() => _value = widget.propriedade!.nome);
  }

  void _onSubmit(String value) {
    setState(() => _value = 'Submit: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(_value),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Hello',
                  hintText: 'Hint',
                  icon: Icon(Icons.people)),
              autocorrect: true,
              autofocus: true,

              //displaying number keyboard
              //keyboardType: TextInputType.number,

              //displaying text keyboard
              keyboardType: TextInputType.text,

              onChanged: _onChanged,
              onSubmitted: _onSubmit,
            )
          ],
        ),
      ),
    );
  }
}

class Counter with ChangeNotifier {
  late Future<List<Campo>> futureCampo;
  late Future<List<Propriedade>> futurePropriedade;
  List<Campo> listCampo = [];
  bool emptyField = false;
  String codPropriedade = '';
  String nomePropriedade = '';
  Propriedade? selectedPropriedade;

  void selecionarPropriedade(Propriedade? seleciona) {
    selectedPropriedade = seleciona;
  }

  void getAllPropriedades() {
    futurePropriedade = getPropriedades();
    notifyListeners();
  }

  void toList() async {
    listCampo = await futureCampo;
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
    nomePropriedade = nome;
    codPropriedade = cod;
    futureCampo = getCampos(codPropriedade: cod);
    notifyListeners();
  }
}

class PropriedadProvider with ChangeNotifier {
  late Future<List<Campo>> futureCampo;
  late Future<List<Propriedade>> futurePropriedade = getPropriedades();
  late Future<List<Safra>> futureSafra;
  List<Propriedade> listPropriedade = [];
  List<Safra> listSafra = [];
  List<Campo> listCampo = [];
  bool emptyField = false;
  String codPropriedade = '';
  String nomePropriedade = '';
  Propriedade? selectedPropriedade;
  bool emptyFieldSafra = false;
  bool emptyFieldCampo = false;
  Propriedade? backup;
  int index = 0;

  // void toList() async {
  //   listTalhao = await futureTalhao;
  //   notifyListeners();
  // }
  void back(Propriedade? propriedade) {
    backup = propriedade;
    notifyListeners();
  }

  void findit(int valor) {
    index = valor;
    notifyListeners();
  }

  void getSelected(Propriedade? propriedade) {
    selectedPropriedade = propriedade;
    notifyListeners();
  }

  void toListSafra() async {
    listSafra = await futureSafra;
    notifyListeners();
  }

  void toListCampo() async {
    listCampo = await futureCampo;
    notifyListeners();
  }

  void toList() async {
    listPropriedade = await futurePropriedade;
    notifyListeners();
  }

  void onChangedSafraTrue() {
    emptyFieldSafra = true;
    notifyListeners();
  }

  void onChangedSafraFalse() {
    emptyFieldSafra = false;
    notifyListeners();
  }

  void onChangedCampoTrue() {
    emptyFieldCampo = true;
    notifyListeners();
  }

  void onChangedCampoFalse() {
    emptyFieldCampo = false;
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

  void incrementSafra(String nome, String cod) {
    futureSafra = getSafras(codPropriedade: cod);
    notifyListeners();
  }

  void incrementCampo(String nome, String cod) {
    nomePropriedade = nome;
    codPropriedade = cod;
    futureCampo = getCampos(codPropriedade: cod);
    notifyListeners();
  }

  void increment() {
    futurePropriedade = getPropriedades();
    notifyListeners();
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
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

class DialogUpdateTeste extends StatefulWidget {
  const DialogUpdateTeste(
      {Key? key,
      this.codPropriedade,
      this.nomePropriedade,
      required this.onChanged,
      required this.update})
      : super(key: key);
  final Function onChanged;
  final Function update;
  final String? codPropriedade;
  final String? nomePropriedade;

  @override
  State<DialogUpdateTeste> createState() => _DialogUpdateTesteState();
}

class _DialogUpdateTesteState extends State<DialogUpdateTeste> {
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
        title: const Text('Cadastrar nova propriedade'),
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
                            await insertPropriedade(nome!, area!).then((_) {
                              widget.onChanged();
                              var counter = context.read<PropriedadProvider>();
                              counter.onChangedFalse();
                              widget.onChanged();
                              counter.increment();
                              counter.toList();
                              // counter.back(counter.selectedPropriedade);
                              // counter.getSelected(null);
                              var index = counter.listPropriedade.indexWhere(
                                  (_selecionada) =>
                                      _selecionada.codPropriedade ==
                                      counter
                                          .selectedPropriedade!.codPropriedade);
                              counter.findit(index);
                              // var propriedades =
                              //     context.read<PropriedadProvider>();
                              // if (propriedades.listPropriedade.any((element) =>
                              //     element.nome == propriedades.backup?.nome)) {
                              //   // propriedades.getSelected(element);
                              //   print('Vasdasdasdasdasd');
                              //   final resultado = propriedades.listPropriedade
                              //       .firstWhere((element) =>
                              //           element.nome ==
                              //           propriedades.backup!.nome);
                              //   propriedades.getSelected(resultado);
                              // }
                              counter.onChangedTrue();
                              // if (counter.listPropriedade
                              //     .contains(counter.selectedPropriedade)) {
                              //   // final _selecionada = counter.selectedPropriedade;
                              //   print('Você está aqui 1');
                              //   final index = counter.listPropriedade
                              //       .indexWhere((_selecionada) =>
                              //           _selecionada.nome ==
                              //           counter.selectedPropriedade!.nome);
                              //   print(index);
                              //   counter.getSelected(null);
                              //   counter.getSelected(
                              //       counter.listPropriedade[index]);
                              //   print('Você está aqui 2' +
                              //       counter.listPropriedade[index].hashCode
                              //           .toString());
                              //   print('Você está aqui 2' +
                              //       counter.listPropriedade[0].hashCode
                              //           .toString());
                              //   counter.onChangedTrue();
                              // }
                              // counter.onChangedTrue();
                              // widget.update(context
                              //     .read<PropriedadProvider>()
                              //     .selectedPropriedade);
                              // widget.onChanged();
                              // counter.onChangedTrue();
                            });
                            // context.read<PropriedadProvider>().onChangedTrue();

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
