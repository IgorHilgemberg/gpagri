/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:typed_data';

import 'package:flutter/services.dart';
// import 'package:login_example/colheita.dart';
import 'package:login_example/insumo.dart';
import 'package:login_example/plantio.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:vector_math/vector_math_64.dart';

import '../data.dart';

Future<Uint8List> generateResume(PdfPageFormat format, CustomData data) async {
  final lorem = pw.LoremText();

  final doc = pw.Document(pageMode: PdfPageMode.outlines);

  final font1 = await PdfGoogleFonts.openSansRegular();
  final font2 = await PdfGoogleFonts.openSansBold();
  final shape = await rootBundle.loadString('assets/document.svg');
  final swirls = await rootBundle.loadString('assets/swirls2.svg');
  final libreBaskerville = await PdfGoogleFonts.libreBaskervilleRegular();
  final libreBaskervilleItalic = await PdfGoogleFonts.libreBaskervilleItalic();
  final libreBaskervilleBold = await PdfGoogleFonts.libreBaskervilleBold();
  final robotoLight = await PdfGoogleFonts.robotoLight();
  final medail = await rootBundle.loadString('assets/medail.svg');
  final swirls1 = await rootBundle.loadString('assets/swirls1.svg');
  final swirls2 = await rootBundle.loadString('assets/swirls2.svg');
  final swirls3 = await rootBundle.loadString('assets/swirls3.svg');
  final garland = await rootBundle.loadString('assets/garland.svg');

  final List<Plantio> plantios = await getPlantios(codSafra: '1');
  final List<InsumoPlantio> insumos = await getInsumosPlantio();
  // final List<ListItem> resumos = await getResumoplantio('1');

  const baseColor = PdfColors.green;

  // pw.Widget _anywidget(List<InsumoPlantio> insumoPlantio) {
  //   return pw.Table.fromTextArray(
  //     // context: context,
  //     data: <List<String>>[
  //       <String>[
  //         'Insumo',
  //         'Dosagem(L/ha)',
  //         'Total(L)',
  //       ],
  //       ...insumoPlantio.map((insumo) => [
  //             insumo.nome,
  //             insumo.dosagem.toStringAsFixed(2),
  //             insumo.totalGasto.toStringAsFixed(2),
  //           ]),
  //     ],
  //     headerStyle: pw.TextStyle(
  //       color: PdfColors.white,
  //       fontWeight: pw.FontWeight.bold,
  //     ),
  //     headerDecoration: const pw.BoxDecoration(
  //       color: baseColor,
  //     ),
  //     rowDecoration: const pw.BoxDecoration(
  //       border: pw.Border(
  //         bottom: pw.BorderSide(
  //           color: baseColor,
  //           width: .5,
  //         ),
  //       ),
  //     ),
  //     cellAlignment: pw.Alignment.centerRight,
  //     cellAlignments: {0: pw.Alignment.centerLeft},
  //   ); // Center
  // }

  doc.addPage(
    pw.Page(
      pageTheme: pw.PageTheme(
        pageFormat: format.copyWith(
          marginBottom: 0,
          marginLeft: 0,
          marginRight: 0,
          marginTop: 0,
        ),
        // orientation: pw.PageOrientation.portrait,
        buildBackground: (context) =>
            pw.SvgImage(svg: shape, fit: pw.BoxFit.fill),
        theme: pw.ThemeData.withFont(
          base: font1,
          bold: font2,
        ),
      ),
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(
            left: 60,
            right: 60,
            bottom: 30,
          ),
          child: pw.Column(
            children: [
              pw.Spacer(),
              pw.RichText(
                  text: pw.TextSpan(children: [
                pw.TextSpan(
                  text: DateTime.now().year.toString() + '\n',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey600,
                    fontSize: 40,
                  ),
                ),
                pw.TextSpan(
                  text: 'Relatório de plantios',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ])),
              pw.Spacer(),
              // pw.Column(
              //   children: [
              //     _anywidget(insumos),
              //   ],
              // ),
              // _anywidget(),
              pw.Container(
                alignment: pw.Alignment.topRight,
                height: 150,
                child: pw.PdfLogo(),
              ),
              pw.Spacer(flex: 2),
              // pw.Align(
              //   alignment: pw.Alignment.topLeft,
              //   child: pw.UrlLink(
              //     destination: 'https://wikipedia.org/wiki/PDF',
              //     child: pw.Text(
              //       'https://wikipedia.org/wiki/PDF',
              //       style: const pw.TextStyle(
              //         color: PdfColors.pink100,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    ),
  );

  // doc.addPage(
  //   pw.Page(
  //     theme: pw.ThemeData.withFont(
  //       base: font1,
  //       bold: font2,
  //     ),
  //     pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
  //     // orientation: pw.PageOrientation.portrait,
  //     build: (context) {
  //       return pw.Column(
  //         children: [
  //           pw.Center(
  //             child: pw.Text('Table of content',
  //                 style: pw.Theme.of(context).header0),
  //           ),
  //           pw.SizedBox(height: 20),
  //           pw.TableOfContent(),
  //           pw.Spacer(),
  //           pw.Center(
  //               child: pw.SvgImage(
  //                   svg: swirls, width: 100, colorFilter: PdfColors.grey)),
  //           pw.Spacer(),
  //         ],
  //       );
  //     },
  //   ),
  // );

  // doc.addPage(
  //   pw.Page(
  //     build: (context) => pw.Column(
  //       children: [
  //         pw.Spacer(flex: 2),
  //         pw.RichText(
  //           text: pw.TextSpan(
  //               style: pw.TextStyle(
  //                 fontWeight: pw.FontWeight.bold,
  //                 fontSize: 25,
  //               ),
  //               children: [
  //                 const pw.TextSpan(text: 'CERTIFICATE '),
  //                 pw.TextSpan(
  //                   text: 'of',
  //                   style: pw.TextStyle(
  //                     fontStyle: pw.FontStyle.italic,
  //                     fontWeight: pw.FontWeight.normal,
  //                   ),
  //                 ),
  //                 const pw.TextSpan(text: ' ACHIEVEMENT'),
  //               ]),
  //         ),
  //         pw.Spacer(),
  //         pw.Text(
  //           'THIS ACKNOWLEDGES THAT',
  //           style: pw.TextStyle(
  //             font: robotoLight,
  //             fontSize: 10,
  //             letterSpacing: 2,
  //             wordSpacing: 2,
  //           ),
  //         ),
  //         pw.SizedBox(
  //           width: 300,
  //           child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
  //         ),
  //         pw.Text(
  //           data.name,
  //           textAlign: pw.TextAlign.center,
  //           style: pw.TextStyle(
  //             fontWeight: pw.FontWeight.bold,
  //             fontSize: 20,
  //           ),
  //         ),
  //         pw.SizedBox(
  //           width: 300,
  //           child: pw.Divider(color: PdfColors.grey, thickness: 1.5),
  //         ),
  //         pw.Text(
  //           'HAS SUCCESSFULLY COMPLETED THE',
  //           style: pw.TextStyle(
  //             font: robotoLight,
  //             fontSize: 10,
  //             letterSpacing: 2,
  //             wordSpacing: 2,
  //           ),
  //         ),
  //         pw.SizedBox(height: 10),
  //         pw.Row(
  //           mainAxisAlignment: pw.MainAxisAlignment.center,
  //           children: [
  //             pw.SvgImage(
  //               svg: swirls,
  //               height: 10,
  //             ),
  //             pw.Padding(
  //               padding: const pw.EdgeInsets.symmetric(horizontal: 10),
  //               child: pw.Text(
  //                 'Flutter PDF Demo',
  //                 style: const pw.TextStyle(
  //                   fontSize: 10,
  //                 ),
  //               ),
  //             ),
  //             pw.Transform(
  //               transform: Matrix4.diagonal3Values(-1, 1, 1),
  //               adjustLayout: true,
  //               child: pw.SvgImage(
  //                 svg: swirls,
  //                 height: 10,
  //               ),
  //             ),
  //           ],
  //         ),
  //         pw.Spacer(),
  //         pw.SvgImage(
  //           svg: swirls2,
  //           width: 150,
  //         ),
  //         pw.Spacer(),
  //         pw.Row(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             pw.Flexible(
  //               child: pw.Text(
  //                 lorem.paragraph(40),
  //                 style: const pw.TextStyle(fontSize: 6),
  //                 textAlign: pw.TextAlign.justify,
  //               ),
  //             ),
  //             pw.SizedBox(width: 100),
  //             pw.SvgImage(
  //               svg: medail,
  //               width: 100,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //     pageTheme: pw.PageTheme(
  //       pageFormat: format,
  //       theme: pw.ThemeData.withFont(
  //         base: libreBaskerville,
  //         italic: libreBaskervilleItalic,
  //         bold: libreBaskervilleBold,
  //       ),
  //       buildBackground: (context) => pw.FullPage(
  //         ignoreMargins: true,
  //         child: pw.Container(
  //           margin: const pw.EdgeInsets.all(10),
  //           decoration: pw.BoxDecoration(
  //             border: pw.Border.all(
  //                 color: const PdfColor.fromInt(0xffe435), width: 1),
  //           ),
  //           child: pw.Container(
  //             margin: const pw.EdgeInsets.all(5),
  //             decoration: pw.BoxDecoration(
  //               border: pw.Border.all(
  //                   color: const PdfColor.fromInt(0xffe435), width: 5),
  //             ),
  //             width: double.infinity,
  //             height: double.infinity,
  //             child: pw.Stack(
  //               alignment: pw.Alignment.center,
  //               children: [
  //                 pw.Positioned(
  //                   top: 5,
  //                   child: pw.SvgImage(
  //                     svg: swirls1,
  //                     height: 60,
  //                   ),
  //                 ),
  //                 pw.Positioned(
  //                   bottom: 5,
  //                   child: pw.Transform(
  //                     transform: Matrix4.diagonal3Values(1, -1, 1),
  //                     adjustLayout: true,
  //                     child: pw.SvgImage(
  //                       svg: swirls1,
  //                       height: 60,
  //                     ),
  //                   ),
  //                 ),
  //                 pw.Positioned(
  //                   top: 5,
  //                   left: 5,
  //                   child: pw.SvgImage(
  //                     svg: swirls3,
  //                     height: 160,
  //                   ),
  //                 ),
  //                 pw.Positioned(
  //                   top: 5,
  //                   right: 5,
  //                   child: pw.Transform(
  //                     transform: Matrix4.diagonal3Values(-1, 1, 1),
  //                     adjustLayout: true,
  //                     child: pw.SvgImage(
  //                       svg: swirls3,
  //                       height: 160,
  //                     ),
  //                   ),
  //                 ),
  //                 pw.Positioned(
  //                   bottom: 5,
  //                   left: 5,
  //                   child: pw.Transform(
  //                     transform: Matrix4.diagonal3Values(1, -1, 1),
  //                     adjustLayout: true,
  //                     child: pw.SvgImage(
  //                       svg: swirls3,
  //                       height: 160,
  //                     ),
  //                   ),
  //                 ),
  //                 pw.Positioned(
  //                   bottom: 5,
  //                   right: 5,
  //                   child: pw.Transform(
  //                     transform: Matrix4.diagonal3Values(-1, -1, 1),
  //                     adjustLayout: true,
  //                     child: pw.SvgImage(
  //                       svg: swirls3,
  //                       height: 160,
  //                     ),
  //                   ),
  //                 ),
  //                 pw.Padding(
  //                   padding: const pw.EdgeInsets.only(
  //                     top: 120,
  //                     left: 80,
  //                     right: 80,
  //                     bottom: 80,
  //                   ),
  //                   child: pw.SvgImage(
  //                     svg: garland,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   ),
  // );

  doc.addPage(pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: font1,
        bold: font2,
      ),
      pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      // orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return pw.SizedBox();
        }
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
            child: pw.Text('Relatório de plantio',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
                'Página ${context.pageNumber} de ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.RichText(
              text: pw.TextSpan(
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 21,
                  ),
                  children: [
                    pw.TextSpan(text: plantios.first.nomePropriedade),
                    pw.TextSpan(
                      text: '=>' + plantios.first.nomeCampo!,
                      // style: pw.TextStyle(
                      //   fontStyle: pw.FontStyle.italic,
                      //   fontWeight: pw.FontWeight.normal,
                      // ),
                    ),
                    pw.TextSpan(text: '=>' + plantios.first.codTalhao),
                  ]),
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(20)),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.RichText(
                  text: pw.TextSpan(
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 15,
                      ),
                      children: [
                        pw.TextSpan(text: plantios.first.codSafra),
                      ]),
                ),
              ],
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(5)),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.RichText(
                  text: pw.TextSpan(
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 15,
                      ),
                      children: [
                        const pw.TextSpan(text: 'Plantio: '),
                        pw.TextSpan(text: plantios.first.name + ' - '),
                        pw.TextSpan(text: plantios.first.codCultivar),
                      ]),
                ),
              ],
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(5)),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.RichText(
                  text: pw.TextSpan(
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 15,
                      ),
                      children: [
                        pw.TextSpan(
                            text:
                                'Data de início: ' + plantios.first.dataInicio),
                        pw.TextSpan(
                            text: '        Data de término: ' +
                                plantios.first.dataFim),
                      ]),
                ),
              ],
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>[
                  'Insumo',
                  'Dosagem(L/ha)',
                  'Total(L)',
                ],
                ...insumos.map((insumo) => [
                      insumo.nome,
                      insumo.dosagem.toStringAsFixed(2),
                      insumo.totalGasto.toStringAsFixed(2),
                    ]),
              ],
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: const pw.BoxDecoration(
                color: baseColor,
              ),
              rowDecoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: baseColor,
                    width: .5,
                  ),
                ),
              ),
              cellAlignment: pw.Alignment.centerRight,
              cellAlignments: {0: pw.Alignment.centerLeft},
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(20)),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.RichText(
                  text: pw.TextSpan(
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 15,
                      ),
                      children: const [
                        pw.TextSpan(text: 'Resumo do plantio'),
                      ]),
                ),
              ],
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            // pw.Table.fromTextArray(
            //   context: context,
            //   data: <List<String>>[
            //     <String>[
            //       'registros',
            //       'Peso total(kg)',
            //       'Produtividade(sc 60Kg/ha)'
            //     ],
            //     ...resumos.map((resumo) => [
            //           resumo.count.toString(),
            //           resumo.total!.toStringAsFixed(2),
            //           resumo.produtividade!.toStringAsFixed(2),
            //         ]),
            //   ],
            //   headerStyle: pw.TextStyle(
            //     color: PdfColors.white,
            //     fontWeight: pw.FontWeight.bold,
            //   ),
            //   headerDecoration: const pw.BoxDecoration(
            //     color: baseColor,
            //   ),
            //   rowDecoration: const pw.BoxDecoration(
            //     border: pw.Border(
            //       bottom: pw.BorderSide(
            //         color: baseColor,
            //         width: .5,
            //       ),
            //     ),
            //   ),
            //   cellAlignment: pw.Alignment.centerRight,
            //   cellAlignments: {0: pw.Alignment.center},
            // ),
          ]));

  return await doc.save();
}

// class Tabelas extends pw.StatelessWidget {
//     final lorem = pw.LoremText();

//   final doc = pw.Document(pageMode: PdfPageMode.outlines);

//   final font1 =  PdfGoogleFonts.openSansRegular();
//   final font2 =  PdfGoogleFonts.openSansBold();
//   final shape =  rootBundle.loadString('assets/document.svg');
//   final swirls =  rootBundle.loadString('assets/swirls2.svg');
//   final libreBaskerville =  PdfGoogleFonts.libreBaskervilleRegular();
//   final libreBaskervilleItalic = PdfGoogleFonts.libreBaskervilleItalic();
//   final libreBaskervilleBold =  PdfGoogleFonts.libreBaskervilleBold();
//   final robotoLight =  PdfGoogleFonts.robotoLight();
//   final medail =  rootBundle.loadString('assets/medail.svg');
//   final swirls1 =  rootBundle.loadString('assets/swirls1.svg');
//   final swirls2 =  rootBundle.loadString('assets/swirls2.svg');
//   final swirls3 =  rootBundle.loadString('assets/swirls3.svg');
//   final garland =  rootBundle.loadString('assets/garland.svg');

//   final List<Plantio> plantios = await getPlantios(codSafra: '1');
//   final List<InsumoPlantio> insumos = await getInsumosPlantio(plantio: '1');
//   // final List<ListItem> resumos = await getResumoplantio('1');

//   static const baseColor = PdfColors.green;
//   Plantio? plantio;
  
//   theme: pw.ThemeData.withFont(
//         base: font1,
//         bold: font2,
//       ),
//       pageFormat: format.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
//       // orientation: pw.PageOrientation.portrait,
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       header: (pw.Context context) {
//         if (context.pageNumber == 1) {
//           return pw.SizedBox();
//         }
//         return pw.Container(
//             alignment: pw.Alignment.centerRight,
//             margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//             padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//             decoration: const pw.BoxDecoration(
//                 border: pw.Border(
//                     bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
//             child: pw.Text('Relatório de plantio',
//                 style: pw.Theme.of(context)
//                     .defaultTextStyle
//                     .copyWith(color: PdfColors.grey)));
//       },
//       footer: (pw.Context context) {
//         return pw.Container(
//             alignment: pw.Alignment.centerRight,
//             margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
//             child: pw.Text(
//                 'Página ${context.pageNumber} de ${context.pagesCount}',
//                 style: pw.Theme.of(context)
//                     .defaultTextStyle
//                     .copyWith(color: PdfColors.grey)));
//       },
//   @override
//   build:(pw.Context context) => <pw.Widget>[
//             pw.RichText(
//               text: pw.TextSpan(
//                   style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     fontSize: 21,
//                   ),
//                   children: [
//                     pw.TextSpan(text: plantios.first.nomePropriedade),
//                     pw.TextSpan(
//                       text: '=>' + plantios.first.nomeCampo!,
//                       // style: pw.TextStyle(
//                       //   fontStyle: pw.FontStyle.italic,
//                       //   fontWeight: pw.FontWeight.normal,
//                       // ),
//                     ),
//                     pw.TextSpan(text: '=>' + plantios.first.codTalhao),
//                   ]),
//             ),
//             pw.Padding(padding: const pw.EdgeInsets.all(20)),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.center,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                       style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                       children: [
//                         pw.TextSpan(text: plantios.first.codSafra),
//                       ]),
//                 ),
//               ],
//             ),
//             pw.Padding(padding: const pw.EdgeInsets.all(5)),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.center,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                       style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                       children: [
//                         const pw.TextSpan(text: 'Plantio: '),
//                         pw.TextSpan(text: plantios.first.name + ' - '),
//                         pw.TextSpan(text: plantios.first.codCultivar),
//                       ]),
//                 ),
//               ],
//             ),
//             pw.Padding(padding: const pw.EdgeInsets.all(5)),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.center,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                       style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                       children: [
//                         pw.TextSpan(
//                             text:
//                                 'Data de início: ' + plantios.first.dataInicio),
//                         pw.TextSpan(
//                             text: '        Data de término: ' +
//                                 plantios.first.dataFim),
//                       ]),
//                 ),
//               ],
//             ),
//             pw.Padding(padding: const pw.EdgeInsets.all(10)),
//             pw.Table.fromTextArray(
//               context: context,
//               data: <List<String>>[
//                 <String>[
//                   'Insumo',
//                   'Dosagem(L/ha)',
//                   'Total(L)',
//                 ],
//                 ...insumos.map((insumo) => [
//                       insumo.nome,
//                       insumo.dosagem.toStringAsFixed(2),
//                       insumo.totalGasto.toStringAsFixed(2),
//                     ]),
//               ],
//               headerStyle: pw.TextStyle(
//                 color: PdfColors.white,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//               headerDecoration: const pw.BoxDecoration(
//                 color: baseColor,
//               ),
//               rowDecoration: const pw.BoxDecoration(
//                 border: pw.Border(
//                   bottom: pw.BorderSide(
//                     color: baseColor,
//                     width: .5,
//                   ),
//                 ),
//               ),
//               cellAlignment: pw.Alignment.centerRight,
//               cellAlignments: {0: pw.Alignment.centerLeft},
//             ),
//             pw.Padding(padding: const pw.EdgeInsets.all(20)),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.center,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                       style: pw.TextStyle(
//                         fontWeight: pw.FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                       children: const [
//                         pw.TextSpan(text: 'Resumo do plantio'),
//                       ]),
//                 ),
//               ],
//             ),
//             pw.Padding(padding: const pw.EdgeInsets.all(10)),
//             // pw.Table.fromTextArray(
//             //   context: context,
//             //   data: <List<String>>[
//             //     <String>[
//             //       'registros',
//             //       'Peso total(kg)',
//             //       'Produtividade(sc 60Kg/ha)'
//             //     ],
//             //     ...resumos.map((resumo) => [
//             //           resumo.count.toString(),
//             //           resumo.total!.toStringAsFixed(2),
//             //           resumo.produtividade!.toStringAsFixed(2),
//             //         ]),
//             //   ],
//             //   headerStyle: pw.TextStyle(
//             //     color: PdfColors.white,
//             //     fontWeight: pw.FontWeight.bold,
//             //   ),
//             //   headerDecoration: const pw.BoxDecoration(
//             //     color: baseColor,
//             //   ),
//             //   rowDecoration: const pw.BoxDecoration(
//             //     border: pw.Border(
//             //       bottom: pw.BorderSide(
//             //         color: baseColor,
//             //         width: .5,
//             //       ),
//             //     ),
//             //   ),
//             //   cellAlignment: pw.Alignment.centerRight,
//             //   cellAlignments: {0: pw.Alignment.center},
//             // ),
//           ];
// }


// class Tabelasasd extends pw.StatelessWidget {
//  final pdf = pw.Document();

// pw.addPage(pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Text("Hello World"),
//         ); // Center
//       }));

//   @override
//   pw.Widget build(pw.Context context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
