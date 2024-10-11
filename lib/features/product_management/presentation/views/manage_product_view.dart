import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/form_validators.dart';
import 'package:lms/features/product_management/data/models/product_model.dart';
import 'package:lms/features/product_management/presentation/manager/cubit/product_cubit.dart';

class ManageProductView extends StatelessWidget {
  ManageProductView({super.key, required this.product});
  RegionProductModel product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text('manage product'),
      ),
      body: ManageProductViewBody(
        product: product,
      ),
    );
  }
}

class ManageProductViewBody extends StatefulWidget {
  const ManageProductViewBody({super.key, required this.product});
  final RegionProductModel product;

  @override
  State<ManageProductViewBody> createState() => _ManageProductViewBodyState();
}

class _ManageProductViewBodyState extends State<ManageProductViewBody> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController imageController;
  late TextEditingController regionNameController;

  List<String> regionList = ['a', 'b'];
  String? _selectedRegion;
  bool _showRegionAttributes = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    descriptionController =
        TextEditingController(text: widget.product.description);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    imageController = TextEditingController(text: widget.product.imageUrl);

    regionNameController =
        TextEditingController(text: widget.product.regionId.toString());
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate()) {
      RegionProductModel newProduct = RegionProductModel(
        id: widget.product.id,
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        imageUrl: imageController.text,
        regionId: regionList.indexOf(_selectedRegion!),
      );

      context.read<ProductCubit>().updateProduct(product: newProduct);
      _clearForm();
    }
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    imageController.clear();
    regionNameController.clear();
    _selectedRegion = null;
    _showRegionAttributes = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state is UpdateProductFailureState) {
          showSnackBar(context, state.errorMsg, Colors.red);
        } else if (state is UpdateProductSuccessState) {
          showSnackBar(context, 'Product updated successfully', Colors.green);
          GoRouter.of(context).pop();
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
                  decoration: const InputDecoration(labelText: 'Product Name'),
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
                DropdownButtonFormField<String>(
                  value: _selectedRegion,
                  decoration: const InputDecoration(labelText: 'Select Region'),
                  items: regionList.map((region) {
                    return DropdownMenuItem<String>(
                      value: region,
                      child: Text(region),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRegion = value; // Set the selected region
                    });
                  },
                  validator: (value) =>
                      FormValidators.validateDropdown(value, 'region'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateProduct,
                  child: state is AddProductLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Update Product'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageController.dispose();
    regionNameController.dispose();
    super.dispose();
  }
}
