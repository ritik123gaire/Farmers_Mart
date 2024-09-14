import 'package:flutter/material.dart';
import '../services/stripe_service.dart';
import 'cart_page.dart'; // Import CartItem class

class BillReceiptPage extends StatelessWidget {
  final List<CartItem> products; // Use CartItem instead of Product

  const BillReceiptPage({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total price based on price * quantity
    double total =
        products.fold(0, (sum, item) => sum + item.price * item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invoice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Add table headers
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1), // Serial number
                1: FlexColumnWidth(3), // Item name
                2: FlexColumnWidth(1), // Quantity
                3: FlexColumnWidth(2), // Price
                4: FlexColumnWidth(2), // Total
              },
              children: [
                // Table headers
                TableRow(
                  children: [
                    tableHeaderCell('SN'),
                    tableHeaderCell('Item'),
                    tableHeaderCell('Qty'),
                    tableHeaderCell('Price'),
                    tableHeaderCell('Total'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Generate table rows dynamically for each product
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1), // Serial number
                      1: FlexColumnWidth(3), // Item name
                      2: FlexColumnWidth(1), // Quantity
                      3: FlexColumnWidth(2), // Price
                      4: FlexColumnWidth(2), // Total
                    },
                    children: [
                      TableRow(
                        children: [
                          tableCell((index + 1).toString()), // Serial number
                          tableCell(product.name), // Item name
                          tableCell(product.quantity.toString()), // Quantity
                          tableCell(
                              '\$${product.price.toStringAsFixed(2)}'), // Price
                          tableCell(
                              '\$${(product.price * product.quantity).toStringAsFixed(2)}'), // Total
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Display total amount
            Text(
              'Grand Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Proceed to Pay button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                  StripeService.instance
                      .makePayment(context); // Call your payment modal
                },
                child: const Text('Proceed to Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function for generating table cells
  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  // Helper function for generating header cells
  Widget tableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
