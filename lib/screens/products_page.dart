import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String image;

  Product({required this.name, required this.price, required this.image});
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  final List<Product> products = [
    Product(
      name: 'Banana',
      price: 5.99,
      image:
          'https://www.merokirana.com/archive/KiranaProduct/banana-sagor-kola-12-pcs-banana-sagar-kola.jpeg',
    ),
    Product(
      name: 'Apple',
      price: 3.99,
      image:
          'https://www.merokirana.com/archive/KiranaProduct/Fresh-Red-FUJI-Apple-Specification-Yantai-FUJI-Apple-Honey-FUJI-Apple.jpg',
    ),
    Product(
      name: 'Orange',
      price: 4.99,
      image:
          'https://www.merokirana.com/archive/KiranaProduct/da3424e2b59948358ef0669c5f9b1a1b.jpg',
    ),
    Product(
      name: 'Mango',
      price: 6.99,
      image:
          'https://m.media-amazon.com/images/I/31cXlUcvRVL._AC_UF894,1000_QL80_.jpg',
    ),
  ];

  Map<Product, int> cart = {};
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void addToCart(Product product) {
    setState(() {
      cart[product] = (cart[product] ?? 0) + 1;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      if (cart[product] == 1) {
        cart.remove(product);
      } else {
        cart[product] = cart[product]! - 1;
      }
    });
  }

  int get totalItems => cart.values.fold(0, (sum, quantity) => sum + quantity);

  double get totalPrice => cart.entries
      .fold(0, (sum, entry) => sum + (entry.key.price * entry.value));

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Your Cart',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final product = cart.keys.elementAt(index);
                        final quantity = cart[product]!;
                        return ListTile(
                          leading: Image.network(
                            product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.name),
                          subtitle:
                              Text('\$${product.price.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setModalState(() {
                                    removeFromCart(product);
                                  });
                                },
                              ),
                              Text('$quantity'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setModalState(() {
                                    addToCart(product);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total: \$${totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement checkout functionality
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Proceed to Checkout'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome, Steve'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: _showCart,
                ),
              ),
              if (totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$totalItems',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('\$${product.price.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => addToCart(product),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size(double.infinity, 36),
                              ),
                              child: const Text('Add to Cart'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            _showCart();
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
