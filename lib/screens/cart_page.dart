import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem(
      {required this.name,
      required this.price,
      required this.image,
      this.quantity = 1});
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(
      name: 'Banana',
      price: 5.99,
      image:
          'https://www.merokirana.com/archive/KiranaProduct/banana-sagor-kola-12-pcs-banana-sagar-kola.jpeg',
      quantity: 2,
    ),
    CartItem(
      name: 'Apple',
      price: 3.99,
      image:
          'https://www.merokirana.com/archive/KiranaProduct/Fresh-Red-FUJI-Apple-Specification-Yantai-FUJI-Apple-Honey-FUJI-Apple.jpg',
      quantity: 1,
    ),
    CartItem(
      name: 'Orange',
      price: 4.99,
      image:
          'https://www.merokirana.com/archive/KiranaProduct/da3424e2b59948358ef0669c5f9b1a1b.jpg',
      quantity: 3,
    ),
  ];

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get tax => subtotal * 0.1; // Assuming 10% tax
  double get total => subtotal + tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildQuantityButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      setState(() {
                                        if (item.quantity > 1) {
                                          item.quantity--;
                                        } else {
                                          cartItems.removeAt(index);
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildQuantityButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      setState(() {
                                        item.quantity++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSummaryRow('Subtotal', subtotal),
                const SizedBox(height: 8),
                _buildSummaryRow('Tax', tax),
                const Divider(height: 24, thickness: 1),
                _buildSummaryRow('Total', total, isTotal: true),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement payment processing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Proceeding to payment...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
