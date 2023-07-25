import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// !Product Details Page for each file using the given API
class ProductDetailPage extends StatefulWidget {
  final int productId;
  final void Function(int countToAdd) addToCart;
  const ProductDetailPage(this.productId, this.addToCart, {Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic> productData = {};
  int cartItemCount = 0;

  // updates the cart count from ProductDetailPage
  void updateCartCount(int count) {
    setState(() {
      cartItemCount = count;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }

  //! Fetch products - API
  Future<void> fetchProductDetail() async {
    final String apiUrl =
        'https://fakestoreapi.com/products/${widget.productId}';
    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          productData = json.decode(response.body);
        });
      } else {
        print('Failed to load product detail. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
          'Product Details: ${productData['title']??
              'Product Title'}',
          maxLines: 1,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    productData.containsKey('image') &&
                            productData['image'] is String
                        ? Image.network(
                            productData['image'],
                             height: 300,
                          )
                        : const SizedBox(
                            height: 300,
                            child: Center(
                              child: Text('Image not available'),
                            ),
                          ),
                    SizedBox(height: 16),
                    Text(
                      productData['title'] ??
                          'Product Title', // Placeholder title
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      productData['category'] ??
                          'Product Category', // Placeholder title
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Price: \$${productData['price'] ?? '0.00'}', // Placeholder price
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Rating: ${productData['rating'] != null ? productData['rating']['rate'] ?? 0 : 0} (${productData['rating'] != null ? productData['rating']['count'] ?? 0 : 0} reviews)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 10),
                    const Text( 'Description-',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      productData['description'] ??
                          'Product description', // Placeholder description
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: () {
                widget.addToCart(1); // Call the addToCart function in Product Catalog Page.
                // Show a dialog that item has been added in cart.
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Added to Cart'),
                      content: Text('The item has been added to the cart.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog.
                            Navigator.pop(
                                context); // Return to Product Catalog Page.
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add To Cart'),
            ),
          )
        ],
      ),
    );
  }
}




