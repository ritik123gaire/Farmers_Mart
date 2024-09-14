import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/payment_successful_page.dart'; // For formatting date

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _expiryDateController = TextEditingController();

  // Simulate payment UI process
  Future<void> makePayment(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildPaymentForm(context),
        );
      },
    );
  }

  // Build the mock payment form UI with validation
  Widget _buildPaymentForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the modal sheet fit content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add your payment information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Card Number Field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 1234 1234 1234',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your card number';
                } else if (value.length != 16) {
                  return 'Card number must be 16 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Expiry Date Field (With DatePicker)
            GestureDetector(
              onTap: () {
                _selectExpiryDate(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(
                    labelText: 'MM / YY',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter expiry date';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // CVC Field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'CVC',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter CVC';
                } else if (value.length != 3) {
                  return 'CVC must be 3 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Country or region Field
            const TextField(
              decoration: InputDecoration(
                labelText: 'Country or region',
                hintText: 'United States',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // ZIP Code Field
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'ZIP Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ZIP Code';
                } else if (value.length != 5) {
                  return 'ZIP Code must be 5 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Simulate a successful payment
                    Navigator.pop(context); // Close the modal on "payment"
                    // Navigate to the payment success page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentSuccessfulPage(),
                      ),
                    );
                  }
                },
                child: const Text('Pay 10.00'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Date Picker for Expiry Date
  Future<void> _selectExpiryDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month),
      firstDate: DateTime(now.year, now.month),
      lastDate: DateTime(now.year + 10),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // Customize the date picker theme if needed
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Format the date as MM / YY
      _expiryDateController.text = DateFormat('MM/yy').format(picked);
    }
  }
}
