import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/assets.dart';
import 'package:lms/core/widgets/build_list_tile.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/auth/presentation/manager/user_state.dart';
import 'package:provider/provider.dart';

class CustomExpandedDrawer extends StatefulWidget {
  const CustomExpandedDrawer({super.key});

  @override
  State<CustomExpandedDrawer> createState() => _CustomExpandedDrawerState();
}

class _CustomExpandedDrawerState extends State<CustomExpandedDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        return Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildListTile(
                    context: context,
                    icon: Icons.home_outlined,
                    title: 'Home',
                    onTap: () {
                      // Navigate to Home
                    },
                  ),
                  if (userRole.contains('ROLE_ADMIN'))
                    buildExpansionTile(
                      context: context,
                      icon: Icons.person_outline_sharp,
                      title: 'Users',
                      children: [
                        buildListTile(
                          context: context,
                          icon: Icons.manage_accounts,
                          title: 'Manage Users',
                          onTap: () {
                            GoRouter.of(context)
                                .push(AppRouter.kUserManagement);
                          },
                        ),
                      ],
                    ),
                  buildExpansionTile(
                    context: context,
                    icon: Icons.groups_outlined,
                    title: 'Teams & Groups',
                    children: [
                      buildListTile(
                        context: context,
                        icon: Icons.group,
                        title: 'Show Groups',
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kTeamManagement);
                        },
                      ),
                    ],
                  ),
                  buildExpansionTile(
                    context: context,
                    icon: FontAwesomeIcons.moneyBill,
                    title: 'Billing',
                    children: [
                      buildListTile(
                        context: context,
                        icon: FontAwesomeIcons.solidCreditCard,
                        title: 'View Payments',
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kPaymentView);
                        },
                      ),
                    ],
                  ),
                  if (userRole.contains('ROLE_ADMIN'))
                    buildListTile(
                      context: context,
                      icon: Icons.verified_user,
                      title: 'Roles and permissions',
                      onTap: () {
                        GoRouter.of(context)
                            .push(AppRouter.kRolesAndPermissionView);
                      },
                    ),
                  if (userState.isLicensor)
                    buildListTile(
                      context: context,
                      icon: Icons.settings,
                      title: 'Product Management',
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kProductManagement);
                      },
                    ),
                  if (!userState.isLicensor)
                    buildExpansionTile(
                      context: context,
                      icon: Icons.add_shopping_cart_sharp,
                      title: 'Product',
                      children: [
                        buildListTile(
                          context: context,
                          icon: Icons.shopping_cart,
                          title: 'Purchase Product',
                          onTap: () {
                            GoRouter.of(context).push(AppRouter.kProductList);
                          },
                        ),
                        buildListTile(
                          context: context,
                          icon: Icons.manage_accounts,
                          title: 'Manage Purchased Products',
                          onTap: () {
                            GoRouter.of(context)
                                .push(AppRouter.kLicenseRenewalView);
                          },
                        ),
                      ],
                    ),
                  if (userState.isLicensor)
                    buildListTile(
                      context: context,
                      icon: Icons.generating_tokens_sharp,
                      title: 'Generate Auth Code',
                      onTap: () {
                        GoRouter.of(context)
                            .push(AppRouter.kLicensorAuthGenerator);
                      },
                    ),
                  if (userState.isLicensor)
                    buildListTile(
                      context: context,
                      icon: Icons.token_outlined,
                      title: 'Authorization Codes',
                      onTap: () {
                        GoRouter.of(context)
                            .push(AppRouter.kLicensorListAuthCodes);
                      },
                    ),
                  buildListTile(
                    context: context,
                    icon: FontAwesomeIcons.wrench,
                    title: 'Setup',
                    onTap: () {
                      // Navigate to Setup
                    },
                  ),
                  const Divider(),
                  buildListTile(
                    context: context,
                    icon: FontAwesomeIcons.ellipsis,
                    title: 'Show all items',
                    onTap: () {
                      // Show all items
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomCollapsedDrawer extends StatefulWidget {
  final VoidCallback closeDrawer;

  const CustomCollapsedDrawer({super.key, required this.closeDrawer});

  @override
  State<CustomCollapsedDrawer> createState() => _CustomCollapsedDrawerState();
}

class _CustomCollapsedDrawerState extends State<CustomCollapsedDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                buildListTile(
                  context: context,
                  icon: Icons.home_outlined,
                  onTap: () {},
                ),
                userRole.contains('ROLE_ADMIN')
                    ? buildListTile(
                        context: context,
                        icon: Icons.person_outline_sharp,
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kUserManagement);
                        },
                      )
                    : const SizedBox(),
                //NEED TO CHANGE ENDPOINTS FOR LICENSOR USERS
                if (userState.isLicensor)
                  buildListTile(
                    context: context,
                    icon: Icons.person_outline_sharp,
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kUserManagement);
                    },
                  ),

                buildListTile(
                  context: context,
                  icon: Icons.groups_outlined,
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kTeamManagement);
                  },
                ),

                userRole.contains('ROLE_ADMIN')
                    ? buildExpansionTile(
                        context: context,
                        icon: FontAwesomeIcons.moneyBill,
                        children: <Widget>[
                          buildListTile(
                            context: context,
                            icon: FontAwesomeIcons.solidCreditCard,
                            onTap: () {
                              GoRouter.of(context).push(AppRouter.kPaymentView);
                            },
                          ),
                        ],
                      )
                    : const SizedBox(),

                userRole.contains('ROLE_ADMIN')
                    ? ListTile(
                        title: Image.asset(
                          AssetsData.rolesIcon,
                          height: 30,
                          width: 30,
                        ),
                        onTap: () {
                          GoRouter.of(context)
                              .push(AppRouter.kRolesAndPermissionView);
                        },
                      )
                    : const SizedBox(),
                if (userState.isLicensor)
                  ListTile(
                    title: Image.asset(
                      'assets/images/poroduct_mngmt.png',
                      height: 30,
                      width: 30,
                    ),
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kProductManagement);
                    },
                  ),
                if (userState.isLicensor)
                  buildListTile(
                    context: context,
                    icon: Icons.generating_tokens_sharp,
                    onTap: () {
                      GoRouter.of(context)
                          .push(AppRouter.kLicensorAuthGenerator);
                    },
                  ),
                if (userState.isLicensor)
                  buildListTile(
                    context: context,
                    icon: Icons.token_outlined,
                    onTap: () {
                      GoRouter.of(context)
                          .push(AppRouter.kLicensorListAuthCodes);
                    },
                  ),
                // Ensure that userRole.contains is not null and valid
                if (!userState.isLicensor)
                  buildExpansionTile(
                    context: context,
                    icon: Icons.add_shopping_cart_sharp,
                    children: <Widget>[
                      buildListTile(
                        context: context,
                        icon: FontAwesomeIcons.creditCard,
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kProductList);
                        },
                      ),
                      buildListTile(
                        context: context,
                        icon: Icons.work_outline,
                        onTap: () {
                          GoRouter.of(context)
                              .push(AppRouter.kLicenseRenewalView);
                        },
                      ),
                    ],
                  ),

                buildListTile(
                  context: context,
                  icon: FontAwesomeIcons.wrench,
                  onTap: () {
                    // Navigate to Copilot
                  },
                ),
                const Divider(),
                buildListTile(
                  context: context,
                  icon: FontAwesomeIcons.ellipsis,
                  onTap: () {
                    // Show all items
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
