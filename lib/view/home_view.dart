// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PDFViewerView extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerView({super.key, required this.pdfUrl});

  @override
  State<PDFViewerView> createState() => _PDFViewerViewState();
}

class _PDFViewerViewState extends State<PDFViewerView> {
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        elevation: 0,
      ),
      body: PDF(
        autoSpacing: false,
        defaultPage: 0,
        enableSwipe: true,
        onViewCreated: _onPDFViewCreated,
        onPageChanged: _onPageChanged,
      ).fromUrl(
        widget.pdfUrl,
        errorWidget: (dynamic error) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        height: 55,
        color: Colors.blue.shade200,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_circle_up, color: Colors.white),
              onPressed: () {
                if (_currentPage > 0) {
                  _pdfViewController?.setPage(_currentPage - 1);
                }
              },
            ),
            Expanded(
              child: Text(
                'Page ${_currentPage + 1} of $_totalPages',
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon:
                  const Icon(Icons.arrow_drop_down_circle, color: Colors.blue),
              onPressed: () {
                if (_currentPage < _totalPages - 1) {
                  _pdfViewController?.setPage(_currentPage + 1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onPDFViewCreated(PDFViewController pdfViewController) {
    setState(() {
      _pdfViewController = pdfViewController;
      _pdfViewController!.getPageCount().then((count) {
        _totalPages = count!;
      });
    });
  }

  void _onPageChanged(int? page, int? total) {
    setState(() {
      _currentPage = page ?? 0;
      _totalPages = total ?? 0;
    });
  }
}
