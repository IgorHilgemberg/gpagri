import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import 'data.dart';
import 'examples/calendar.dart';
import 'examples/certificate.dart';
import 'examples/document.dart';
import 'examples/invoice.dart';
import 'examples/report.dart';
import 'examples/resume.dart';
import 'examples/reportInsumo.dart';

const examples = <Example>[
  Example('PLANTIOS', 'resume.dart', generateResume),
  Example('COLHEITAS', 'document.dart', generateDocument),
  Example('APLICAÇÕES', 'invoice.dart', generateInvoice),
  // Example('INSUMOS', 'reportInsumo.dart', generateReportInsumos),
  // Example('REPORT', 'report.dart', generateReport),
  // Example('CALENDAR', 'calendar.dart', generateCalendar),
  // Example('CERTIFICATE', 'certificate.dart', generateCertificate, true),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, CustomData data);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
