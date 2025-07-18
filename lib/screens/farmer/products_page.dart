import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agroconnect/utils/constants.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // State for the promotional banner
  int _bannerCurrentPage = 0;
  final PageController _bannerController = PageController();

  // Dummy data for banner and categories
  final List<String> _bannerImages = [
    'assets/images/promo_banner.png',
    'assets/images/promo_banner.png',
    'assets/images/promo_banner.png',
  ];

  final List<Map<String, String>> _categories = [
    {'name': 'Fruits', 'image': 'assets/images/category_fruits.png'},
    {'name': 'Grains', 'image': 'assets/images/category_grains.png'},
    {'name': 'Herbs', 'image': 'assets/images/category_herbs.png'},
    {'name': 'Vegetables', 'image': 'assets/images/category_vegetables.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: const Text(
          'Farmers',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_balance_wallet_outlined,
              color: kTextColor,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: kTextColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: kDefaultPadding),
            _buildPromoBanner(),
            const SizedBox(height: kDefaultPadding),
            _buildSectionHeader(title: 'Categories', onViewAll: () {}),
            const SizedBox(height: kDefaultPadding / 2),
            _buildCategoriesList(),
            const SizedBox(height: kDefaultPadding),
            _buildSectionHeader(title: 'Browse Products', onViewAll: () {}),
            const SizedBox(height: kDefaultPadding / 2),
            _buildProductsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search..',
                prefixIcon: const Icon(
                  Icons.search,
                  color: kTextSecondaryColor,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kDefaultRadius),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: kDefaultPadding / 2),
          Container(
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(kDefaultRadius),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _bannerImages.length,
            onPageChanged: (value) =>
                setState(() => _bannerCurrentPage = value),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kDefaultRadius * 1.5),
                  child: Image.asset(
                    _bannerImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _bannerImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _bannerCurrentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _bannerCurrentPage == index
                    ? kPrimaryColor
                    : kPrimaryLightColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  // --- FIX APPLIED HERE ---
                  backgroundColor: kPrimaryLightColor.withAlpha(
                    128,
                  ), // Replaced withOpacity(0.5)
                  backgroundImage: AssetImage(_categories[index]['image']!),
                  onBackgroundImageError: (exception, stackTrace) {},
                ),
                const SizedBox(height: 8),
                Text(
                  _categories[index]['name']!,
                  style: kBodyTextStyle.copyWith(color: kTextColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(productsCollection)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kAccentColor),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'No products found yet!',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final products = snapshot.data!.docs;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: kDefaultPadding,
              crossAxisSpacing: kDefaultPadding,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              return ProductGridCard(product: product);
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: kSubheadingStyle),
          TextButton(
            onPressed: onViewAll,
            child: const Text(
              'View all',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductGridCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductGridCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kDefaultRadius * 1.5),
        boxShadow: [
          BoxShadow(
            // --- FIX APPLIED HERE ---
            color: kPrimaryColor.withAlpha(26), // Replaced withOpacity(0.1)
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(kDefaultRadius * 1.5),
                    topRight: Radius.circular(kDefaultRadius * 1.5),
                  ),
                  child: Image.network(
                    product['imageUrl'] ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error_outline, color: kErrorColor),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      // --- FIX APPLIED HERE ---
                      color: Colors.black.withAlpha(
                        102,
                      ), // Replaced withOpacity(0.4)
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Unnamed Product',
                  style: kBodyTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${product['price']?.toStringAsFixed(0) ?? '0'}',
                      style: kHeadingStyle.copyWith(
                        fontSize: 16,
                        color: kPrimaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '4.5 (200)',
                          style: kBodyTextStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
