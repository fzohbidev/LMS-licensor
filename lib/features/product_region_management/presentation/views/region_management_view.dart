import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/presentation/manager/region_cubit/region_cubit.dart';

class RegionManagementView extends StatefulWidget {
  RegionManagementView({super.key, this.regions = const []});
  List<RegionModel> regions;

  @override
  State<RegionManagementView> createState() => _RegionManagementViewState();
}

class _RegionManagementViewState extends State<RegionManagementView> {
  void _navigateToAddProduct() {
    GoRouter.of(context).push(AppRouter.kAddRegionView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Region'),
      ),
      body: RegionManagementViewBody(
        regions: widget.regions,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProduct,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RegionManagementViewBody extends StatefulWidget {
  RegionManagementViewBody({super.key, this.regions = const []});
  List<RegionModel> regions;

  @override
  State<RegionManagementViewBody> createState() =>
      _RegionManagementViewBodyState();
}

class _RegionManagementViewBodyState extends State<RegionManagementViewBody> {
  int? deletingRegionId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegionCubit, RegionState>(
      listener: (context, state) {
        if (state is DeleteRegionFailureState) {
          showSnackBar(context, state.errorMsg, Colors.red);
        } else if (state is DeleteRegionSuccessState) {
          showSnackBar(context, 'Product deleted successfully', Colors.blue);
          setState(() {
            widget.regions
                .removeWhere((region) => region.id == deletingRegionId);
            deletingRegionId = null;
          });
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            const Text('All Regions'),
            Expanded(
                child: ListView.builder(
              itemCount: widget.regions.length,
              itemBuilder: (context, index) {
                final region = widget.regions[index];
                return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(region.name ?? '',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text('country: ${region.country ?? ''}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700])),
                              ],
                            ),
                          ),
                          // IconButton(
                          //   icon: const Icon(Icons.settings),
                          //   onPressed: () {
                          //     GoRouter.of(context).push(
                          //         AppRouter.kManageProductView,
                          //         extra: product);
                          //   },
                          // ),
                          IconButton(
                            icon: deletingRegionId == region.id
                                ? const CircularProgressIndicator()
                                : const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() => deletingRegionId = region.id);
                              context
                                  .read<RegionCubit>()
                                  .deleteRegion(regionId: region.id!);
                            },
                          ),
                        ],
                      ),
                    ));
              },
            )),
          ],
        );
      },
    );
  }
}
