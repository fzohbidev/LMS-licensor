import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/form_validators.dart';
import 'package:lms/features/product_management/data/models/product_model.dart';
import 'package:lms/features/product_management/presentation/manager/cubit/product_cubit.dart';

import 'product_list_view.dart';

class ProductForm extends StatefulWidget {
  final List<RegionProductModel> productList;
  final List<String> regionList; // Pass the list of regions

  const ProductForm({
    super.key,
    required this.productList,
    required this.regionList, // Required parameter for regions
  });

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController regionNameController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  String? _selectedRegion; // Variable to store selected region
  bool _showRegionAttributes = false; // Flag to show/hide region attributes

  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      List<RegionProductModel> newProducts = [];
      newProducts.add(RegionProductModel(
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        imageUrl: imageController.text,
        regionId: widget.regionList
            .indexOf(_selectedRegion!), // Get the index of the selected region
      ));

      context.read<ProductCubit>().addProduct(products: newProducts);

      // Clear the form after submission
      _clearForm();
    }
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    imageController.clear();
    countryController.clear();
    regionNameController.clear();
    zipCodeController.clear();
    _selectedRegion = null; // Clear the selected region
    _showRegionAttributes = false; // Hide region attributes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insert Product')),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is AddProductFailureState) {
            showSnackBar(context, state.errorMsg, Colors.red);
          } else if (state is AddProductSuccessState) {
            showSnackBar(context, 'product added successfully', Colors.green);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                    validator: (value) =>
                        FormValidators.validateString(value, 'Product Name'),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) =>
                        FormValidators.validateString(value, 'Description'),
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) =>
                        FormValidators.validateDouble(value, 'Price'),
                  ),
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                    validator: (value) =>
                        FormValidators.validateString(value, 'Image URL'),
                  ),
                  // Dropdown for selecting region
                  DropdownButtonFormField<String>(
                    value: _selectedRegion,
                    decoration:
                        const InputDecoration(labelText: 'Select Region'),
                    items: widget.regionList.map((region) {
                      return DropdownMenuItem<String>(
                        value: region,
                        child: Text(region),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRegion = value; // Set the selected region
                        // Show region attributes if a region is selected
                        _showRegionAttributes = value != null;
                      });
                    },
                    validator: (value) =>
                        FormValidators.validateDropdown(value, 'region'),
                  ),
                  if (_showRegionAttributes) ...[
                    // Region attributes fields
                    TextFormField(
                      controller: countryController,
                      decoration: const InputDecoration(labelText: 'Country'),
                      validator: (value) =>
                          FormValidators.validateString(value, 'Country'),
                    ),
                    TextFormField(
                      controller: regionNameController,
                      decoration:
                          const InputDecoration(labelText: 'Region Name'),
                      validator: (value) =>
                          FormValidators.validateString(value, 'Region Name'),
                    ),
                    TextFormField(
                      controller: zipCodeController,
                      decoration: const InputDecoration(labelText: 'Zip Code'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          FormValidators.validateInteger(value, 'Zip Code'),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addProduct,
                    child: state is AddProductLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Insert Product'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductListView(productList: widget.productList),
                        ),
                      );
                    },
                    child: const Text('View Products'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
