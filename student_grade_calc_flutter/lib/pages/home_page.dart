import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:printing/printing.dart';
import '../data/history_repository.dart';
import '../models/grade_session.dart';
import '../models/student.dart';
import '../services/excel_service.dart';
import '../services/grade_calculator.dart';
import '../services/pdf_service.dart';
import '../theme/app_theme.dart';
import '../widgets/export_buttons.dart';
import '../widgets/file_picker_card.dart';
import '../widgets/results_table.dart';

/// The main page of the app.
///
/// User flow:
///   1. See the file picker card → tap "Browse" → OS file picker opens
///   2. Select an .xlsx file → file name appears → "Process File" button appears
///   3. Tap "Process File" → loading indicator → results table appears
///   4. Download results as Excel or PDF using the export buttons
///   5. Session is automatically saved to history
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ── State variables ────────────────────────────────────────────────────────
  String? _selectedFilePath; // null until user picks a file
  String? _selectedFileName; // just the file name, not the full path
  List<String> _subjectHeaders = [];
  List<Student> _students = [];
  bool _isProcessing = false;
  bool _hasResults = false;
  String? _errorMessage;

  // ── Services ───────────────────────────────────────────────────────────────
  final _excelService = ExcelService();
  final _pdfService = PdfService();
  final _gradeCalculator = GradeCalculator();
  final _historyRepo = HistoryRepository();

  @override
  void initState() {
    super.initState();
    // The repo is already init'd globally in main.dart,
    // but we need a local instance to call saveSession
    _historyRepo.init();
  }

  // ── File picking ───────────────────────────────────────────────────────────
  Future<void> _pickFile() async {
    // file_picker opens a native OS dialog filtered to .xlsx files
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (result == null) return; // user cancelled
      setState(() {
        _selectedFilePath = result.files.single.path;
        _selectedFileName = result.files.single.name;
        _hasResults = false; // reset previous results
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not open file picker: ${e.toString()}';
      });
    }
  }

  // ── Processing ─────────────────────────────────────────────────────────────
  Future<void> _processFile() async {
    if (_selectedFilePath == null) return;
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // 1. Read the Excel file
      final result = await _excelService.readFile(_selectedFilePath!);

      // 2. Compute grades
      final enriched = _gradeCalculator.calculateAll(result.students);

      // 3. Update state — this triggers a rebuild showing the results
      setState(() {
        _subjectHeaders = result.headers;
        _students = enriched;
        _hasResults = true;
        _isProcessing = false;
      });

      // 4. Save to history (fire and forget — don't block the UI)
      _saveToHistory();
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Could not read file: ${e.toString()}';
      });
    }
  }

  // ── Save to history ────────────────────────────────────────────────────────
  Future<void> _saveToHistory() async {
    try {
      final passCount = _students.where((s) => s.status == 'PASS').length;
      final session = GradeSession(
        fileName: _selectedFileName ?? 'Unknown',
        processedAt: DateTime.now(),
        totalStudents: _students.length,
        passCount: passCount,
        failCount: _students.length - passCount,
        classAverage: _gradeCalculator.classAverage(_students),
        students: _students,
        subjectHeaders: _subjectHeaders,
      );
      await _historyRepo.saveSession(session);
    } catch (e) {
      // Silently fail — history save shouldn't block the user
      debugPrint('Failed to save session to history: $e');
    }
  }

  // ── Excel export ───────────────────────────────────────────────────────────
  Future<void> _exportExcel() async {
    // Ask user where to save the file
    try {
      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Grade Report',
        fileName: 'grades_output.xlsx',
        allowedExtensions: ['xlsx'],
        type: FileType.custom,
      );
      if (savePath == null) return;

      await _excelService.writeFile(savePath, _students, _subjectHeaders);
      _showSnackBar('Excel file saved successfully.');
    } catch (e) {
      _showSnackBar('Failed to save Excel: ${e.toString()}');
    }
  }

  // ── PDF export ─────────────────────────────────────────────────────────────
  Future<void> _exportPdf() async {
    try {
      final bytes = await _pdfService.generateReport(
        students: _students,
        subjectHeaders: _subjectHeaders,
        sessionLabel: _selectedFileName ?? 'Grade Report',
      );
      // `printing` package opens the OS print/save dialog
      await Printing.sharePdf(bytes: bytes, filename: 'grade_report.pdf');
    } catch (e) {
      _showSnackBar('Failed to generate PDF: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          Text('Grade Calculator', style: AppTextStyles.display()),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Import an Excel file to compute student grades.',
            style: AppTextStyles.body(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),

          // File picker
          FilePickerCard(
            selectedFileName: _selectedFileName,
            isProcessing: _isProcessing,
            onFilePicked: _pickFile,
            onProcess: _processFile,
          ),

          // Error message (shown only on failure)
          if (_errorMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_errorMessage!,
                style: AppTextStyles.body(color: AppColors.danger)),
          ],

          // Results (shown only after successful processing)
          if (_hasResults) ...[
            const SizedBox(height: AppSpacing.xl),
            Text('Results', style: AppTextStyles.heading()),
            const SizedBox(height: AppSpacing.md),
            ResultsTable(students: _students, subjectHeaders: _subjectHeaders),
            const SizedBox(height: AppSpacing.lg),
            ExportButtons(
              onExportExcel: _exportExcel,
              onExportPdf: _exportPdf,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ],
      ),
    );
  }
}
