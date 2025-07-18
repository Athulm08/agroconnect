import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agroconnect/utils/constants.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Farm Products'),
        backgroundColor: kBackgroundColor,
        elevation: 1,
      ),
      // Use a StreamBuilder to listen for real-time updates from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(productsCollection)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Handle error state
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          // Handle no data state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No products found.\nAdd one using the center button!',
                textAlign: TextAlign.center,
              ),
            );
          }

          // If data is available, display it in a list
          final products = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(kDefaultRadius / 2),
                        child: Image.network(
                          product['imageUrl'] ?? '',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          // Shows a loading indicator while the image loads
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                          // Shows an error icon if the image fails to load
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] ?? 'No Name',
                              style: kSubheadingStyle.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                              style: kHeadingStyle.copyWith(
                                fontSize: 16,
                                color: kPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: kBodyTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
