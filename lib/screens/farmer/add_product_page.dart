import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agroconnect/services/product_service.dart';
import 'package:agroconnect/utils/constants.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _productService = ProductService();

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      setState(() => _isLoading = true);

      try {
        // 1. Upload image to Cloudinary
        final imageUrl = await _productService.uploadImageToCloudinary(
          _imageFile!,
        );

        // 2. Add product details (with image URL) to Firestore
        await _productService.addProduct(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          imageUrl: imageUrl,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully!'),
              backgroundColor: kPrimaryColor,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: kErrorColor,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image for your product.'),
          backgroundColor: kErrorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                    border: Border.all(color: kPrimaryLightColor),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(kDefaultRadius),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 50,
                                color: kTextSecondaryColor,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to select an image',
                                style: kBodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) =>
                    v!.isEmpty ? 'Please enter a product name' : null,
              ),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) =>
                    v!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: kDefaultPadding),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Please enter a price' : null,
              ),
              const SizedBox(height: kDefaultPadding * 2),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: kAccentColor),
                    )
                  : ElevatedButton(
                      onPressed: _submitProduct,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding * 0.8,
                        ),
                        backgroundColor: kPrimaryColor,
                      ),
                      child: const Text('Add Product', style: kButtonTextStyle),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
