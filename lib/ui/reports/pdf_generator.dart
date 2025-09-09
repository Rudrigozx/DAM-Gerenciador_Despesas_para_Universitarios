import 'dart:typed_data';
import 'package:fin_plus/domain/models/report_data_model.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfReportGenerator {
  static Future<Uint8List> generate({
    required ReportData reportData,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy');

    pdf.addPage(
      pw.MultiPage(
        header: (context) => _buildHeader(dateFormat.format(startDate), dateFormat.format(endDate)),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildSummary(reportData, currencyFormat, boldFont),
          pw.SizedBox(height: 20),
          _buildCategoryTable(reportData, currencyFormat, boldFont, font),
          // Adicionar mais seções aqui (ex: lista de transações)
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(String startDate, String endDate) {
    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Relatório Financeiro', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.Text('Período: $startDate a $endDate', style: const pw.TextStyle(fontSize: 14)),
          pw.Divider(),
        ],
      ),
    );
  }
  
  static pw.Widget _buildSummary(ReportData data, NumberFormat format, pw.Font bold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Resumo do Período', style: pw.TextStyle(font: bold, fontSize: 18)),
        pw.SizedBox(height: 10),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Total de Receitas:'),
          pw.Text(format.format(data.totalIncome), style: pw.TextStyle(color: PdfColors.green, font: bold)),
        ]),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Total de Despesas:'),
          pw.Text(format.format(data.totalExpenses), style: pw.TextStyle(color: PdfColors.red, font: bold)),
        ]),
        pw.Divider(height: 10),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Saldo do Período:', style: pw.TextStyle(font: bold)),
          pw.Text(format.format(data.balance), style: pw.TextStyle(font: bold)),
        ]),
      ],
    );
  }
  
  static pw.Widget _buildCategoryTable(ReportData data, NumberFormat format, pw.Font bold, pw.Font regular) {
     final headers = ['Categoria', 'Valor Gasto', '% do Total'];
     final tableData = data.expensesByCategory.entries.map((entry) {
       final percentage = data.totalExpenses > 0 ? (entry.value / data.totalExpenses * 100) : 0;
       return [entry.key, format.format(entry.value), '${percentage.toStringAsFixed(1)}%'];
     }).toList();
     
     return pw.Column(
       crossAxisAlignment: pw.CrossAxisAlignment.start,
       children: [
         pw.Text('Gastos por Categoria', style: pw.TextStyle(font: bold, fontSize: 18)),
         pw.SizedBox(height: 10),
         pw.Table.fromTextArray(
           headers: headers,
           data: tableData,
           border: pw.TableBorder.all(),
           headerStyle: pw.TextStyle(font: bold),
           cellStyle: pw.TextStyle(font: regular),
           cellAlignment: pw.Alignment.centerRight,
           cellAlignments: {0: pw.Alignment.centerLeft},
         ),
       ]
     );
  }

  static pw.Widget _buildFooter(pw.Context context) { // 1. Recebe o 'context'
  return pw.Container(
    alignment: pw.Alignment.centerRight,
    margin: const pw.EdgeInsets.only(top: 20),
    child: pw.Text(
      // 2. Usa as propriedades do 'context'
      'Página ${context.pageNumber} de ${context.pagesCount}',
      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
    ),
  );
}
}