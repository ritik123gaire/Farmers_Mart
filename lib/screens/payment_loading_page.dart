import 'package:flutter/material.dart';

class PaymentLoadingPage extends StatefulWidget {
  final Future<void> Function() processPayment;

  const PaymentLoadingPage({Key? key, required this.processPayment})
      : super(key: key);

  @override
  _PaymentLoadingPageState createState() => _PaymentLoadingPageState();
}

class _PaymentLoadingPageState extends State<PaymentLoadingPage> {
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _processPayment();
  }

  Future<void> _processPayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await widget.processPayment();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'An error occurred while processing your payment. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                const Text(
                  'Processing payment...',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  _errorMessage,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _processPayment,
                  child: const Text('Retry Payment'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
