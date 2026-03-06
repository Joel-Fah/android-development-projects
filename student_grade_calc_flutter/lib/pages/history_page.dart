import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../data/history_repository.dart';
import '../models/grade_session.dart';
import '../services/excel_service.dart';
import '../services/pdf_service.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/export_buttons.dart';
import '../widgets/history_tile.dart';
import '../widgets/results_table.dart';
import 'package:file_picker/file_picker.dart';

/// Shows a chronological list of all past grade calculation sessions.
///
/// Tapping a session opens a bottom sheet with the full results table
/// and export options for that session.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _repo = HistoryRepository();
  final _excelService = ExcelService();
  final _pdfService = PdfService();
  List<GradeSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    // Ensure DB is initialized before querying
    await _repo.init();
    await _loadSessions();
  }

  Future<void> _loadSessions() async {
    // Always set _isLoading = true before the async call
    // so the UI shows a spinner while waiting
    setState(() => _isLoading = true);
    final sessions = await _repo.getAllSessions();
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  Future<void> _deleteSession(int id) async {
    await _repo.deleteSession(id);
    await _loadSessions(); // reload list after deletion
  }

  Future<void> _clearAll() async {
    // Show confirmation dialog before wiping all data
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text('This will permanently delete all past sessions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Clear',
              style: AppTextStyles.label(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _repo.clearAll();
      await _loadSessions();
    }
  }

  void _openSessionDetail(GradeSession session) {
    // Open a bottom sheet showing results table + export buttons for this session
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // allows the sheet to be taller than 50% of screen
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(session.fileName, style: AppTextStyles.heading()),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: ResultsTable(
                    students: session.students,
                    subjectHeaders: session.subjectHeaders,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Export buttons reused — wire up same export logic
              ExportButtons(
                onExportExcel: () => _exportExcel(session),
                onExportPdf: () => _exportPdf(session),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportExcel(GradeSession session) async {
    try {
      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Grade Report',
        fileName: 'grades_output.xlsx',
        allowedExtensions: ['xlsx'],
        type: FileType.custom,
      );
      if (savePath == null) return;

      await _excelService.writeFile(
          savePath, session.students, session.subjectHeaders);
      _showSnackBar('Excel file saved successfully.');
    } catch (e) {
      _showSnackBar('Failed to save Excel: ${e.toString()}');
    }
  }

  Future<void> _exportPdf(GradeSession session) async {
    try {
      final bytes = await _pdfService.generateReport(
        students: session.students,
        subjectHeaders: session.subjectHeaders,
        sessionLabel: session.fileName,
      );
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('History', style: AppTextStyles.display()),
              if (_sessions.isNotEmpty)
                TextButton(
                  onPressed: _clearAll,
                  child: Text(
                    'Clear all',
                    style: AppTextStyles.label(color: AppColors.danger),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Body
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_sessions.isEmpty)
            const Expanded(
              child: EmptyState(
                icon: Icons.history_outlined,
                title: 'No calculations yet',
                subtitle: 'Processed sessions will appear here.',
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _sessions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => HistoryTile(
                  session: _sessions[i],
                  onTap: () => _openSessionDetail(_sessions[i]),
                  onDelete: () => _deleteSession(_sessions[i].id!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
