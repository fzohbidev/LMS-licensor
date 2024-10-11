import 'package:flutter/material.dart';
import 'package:lms/features/product_management/data/models/product_model.dart';
import 'package:lms/features/product_management/presentation/views/product_form.dart';

class ProductManagementView extends StatefulWidget {
  final List<RegionProductModel> productList = [];
  final List<String> regionList = [];

  ProductManagementView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<ProductManagementView> {
  String? _selectedRegion;

  // Filter products based on the selected region
  List<RegionProductModel> _getFilteredProducts() {
    if (_selectedRegion == null || _selectedRegion == "All") {
      return widget
          .productList; // Show all products if no region or "All" is selected
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
          regionList: widget.regionList, // Pass the region list to ProductForm
        ),
      ),
    ).then((_) {
      setState(() {}); // Refresh the view after returning from ProductForm
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      widget.productList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('License Management System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown Button to Select Region
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
                      // Add "All" option
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('No products available.'))
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteProduct(
                                      widget.productList.indexOf(product)),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}
