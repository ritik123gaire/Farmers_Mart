import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/payment_successful_page.dart';
import '../screens/payment_loading_page.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  // Debit card that always succeeds
  static const String _successfulCardNumber = '4242424242424242';

  Future<void> makePayment(BuildContext context, double amount) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildPaymentForm(context, amount),
        );
      },
    );
  }

  Widget _buildPaymentForm(BuildContext context, double amount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Amount: \$${amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            _buildCardNumberField(),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _buildExpiryDateField()),
                SizedBox(width: 15),
                Expanded(child: _buildCVCField()),
              ],
            ),
            SizedBox(height: 15),
            _buildZipCodeField(),
            SizedBox(height: 25),
            _buildPayButton(context, amount),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _cardNumberController,
      decoration: InputDecoration(
        labelText: 'Card Number',
        hintText: '1234 5678 9012 3456',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(Icons.credit_card),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        _CardNumberFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your card number';
        } else if (!isValidCardNumber(value)) {
          return 'Invalid card number';
        }
        return null;
      },
    );
  }

  Widget _buildExpiryDateField() {
    return TextFormField(
      controller: _expiryDateController,
      decoration: InputDecoration(
        labelText: 'MM / YY',
        hintText: '12 / 25',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(Icons.calendar_today),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        _ExpiryDateFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter expiry date';
        } else if (!isValidExpiryDate(value)) {
          return 'Invalid expiry date';
        }
        return null;
      },
    );
  }

  Widget _buildCVCField() {
    return TextFormField(
      controller: _cvcController,
      decoration: InputDecoration(
        labelText: 'CVC',
        hintText: '123',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(Icons.security),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter CVC';
        } else if (value.length != 3) {
          return 'CVC must be 3 digits';
        }
        return null;
      },
    );
  }

  Widget _buildZipCodeField() {
    return TextFormField(
      controller: _zipCodeController,
      decoration: InputDecoration(
        labelText: 'ZIP Code',
        hintText: '12345',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(Icons.location_on),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(5),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ZIP Code';
        } else if (value.length != 5) {
          return 'ZIP Code must be 5 digits';
        }
        return null;
      },
    );
  }

  Widget _buildPayButton(BuildContext context, double amount) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _processPayment(context, amount);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Pay \$${amount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, double amount) {
    Navigator.pop(context); // Close the bottom sheet
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentLoadingPage(
          processPayment: () => _simulatePaymentProcess(context, amount),
        ),
      ),
    );
  }

  Future<void> _simulatePaymentProcess(
      BuildContext context, double amount) async {
    // Simulate payment processing delay
    await Future.delayed(Duration(seconds: 3));

    // Check if the card number is the one that always succeeds
    if (_cardNumberController.text.replaceAll(' ', '') ==
        _successfulCardNumber) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentSuccessfulPage(amount: amount)),
      );
    } else {
      // Simulate a random success or failure for other card numbers
      if (DateTime.now().millisecond % 2 == 0) {
        // Success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentSuccessfulPage(amount: amount)),
        );
      } else {
        // Failure
        throw Exception('Payment failed');
      }
    }
  }

  bool isValidCardNumber(String input) {
    input = input.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    if (input.length < 13 || input.length > 19) return false;

    int sum = 0;
    bool alternate = false;
    for (int i = input.length - 1; i >= 0; i--) {
      int n = int.parse(input[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return (sum % 10 == 0);
  }

  bool isValidExpiryDate(String input) {
    final parts = input.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0].trim());
    final year = int.tryParse(parts[1].trim());

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final expiry = DateTime(2000 + year, month);

    return expiry.isAfter(now);
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write(' / ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
