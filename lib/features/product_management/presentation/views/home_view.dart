import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/presentation/manager/product_cubit/product_cubit.dart';
import 'package:lms/features/product_region_management/presentation/views/product_form.dart';

class ProductManagementView extends StatefulWidget {
  List<RegionProductModel> productList = [];
  List<String> regionList = [];

  ProductManagementView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<ProductManagementView> {
  String? _selectedRegion;
  int? deletingProductId; // Track the ID of the product being deleted

  // Filter products based on the selected region
  List<RegionProductModel> _getFilteredProducts() {
    if (_selectedRegion == null || _selectedRegion == "All") {
      return widget.productList;
    }
    return widget.productList
        .where((product) =>
            product.regionId == widget.regionList.indexOf(_selectedRegion!))
        .toList();
  }

  void _navigateToAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductForm(
          productList: widget.productList,
          regionList: const ['a', 'b'], // Pass the region list to ProductForm
        ),
      ),
    ).then((_) {
      setState(() {}); // Refresh the view after returning from ProductForm
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProductCubit>().getAllProducts();
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('License Management System'),
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is GetAllProductsFailureState) {
            showSnackBar(context, state.errorMsg, Colors.red);
          } else if (state is GetAllProductsSuccessState) {
            widget.productList = state.products;
          }
          if (state is DeleteProductFailureState) {
            showSnackBar(context, state.errorMsg, Colors.red);
            setState(() {
              deletingProductId = null; // Reset when deletion fails
            });
          } else if (state is DeleteProductSuccessState) {
            showSnackBar(context, 'Product deleted successfully', Colors.blue);

            widget.productList
                .removeWhere((product) => product.id == deletingProductId);
            deletingProductId = null; // Reset after successful deletion
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedRegion,
                        hint: const Text('Select Region'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRegion = newValue;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: "All",
                            child: Text("All"),
                          ),
                          ...widget.regionList
                              .map<DropdownMenuItem<String>>((String region) {
                            return DropdownMenuItem<String>(
                              value: region,
                              child: Text(region),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _selectedRegion == null || _selectedRegion == "All"
                      ? 'All Products'
                      : 'Products in $_selectedRegion',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: widget.productList.isEmpty
                      ? const Center(child: Text('No products available.'))
                      : state is GetAllProductsLoadingState
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: widget.productList.length,
                              itemBuilder: (context, index) {
                                final product = widget.productList[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 4,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Price: \$${product.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.settings,
                                          ),
                                          onPressed: () {
                                            GoRouter.of(context).push(
                                                AppRouter.kManageProductView,
                                                extra: product);
                                          },
                                        ),
                                        IconButton(
                                          icon: deletingProductId == product.id
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : const Icon(Icons.delete,
                                                  color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              deletingProductId = product
                                                  .id; // Track the ID of the deleting product
                                            });
                                            context
                                                .read<ProductCubit>()
                                                .deleteProduct(
                                                    productId: product.id!);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
