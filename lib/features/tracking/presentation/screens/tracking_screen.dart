import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/config/theme.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../authentication/presentation/cubit/auth_cubit.dart';
import '../../data/models/customer_visit_model.dart';
import '../cubit/activity_cubit.dart';
import '../widgets/date_picker_widget.dart';
import '../widgets/tracking_map_widget.dart';
import '../widgets/user_drop_down.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String? _selectedUser;
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _users = [];
  bool _showCurrentLocation = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    // Load list of users
    context.read<ActivityCubit>().getAllUsers();

    // Set current user as default if authenticated
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        _selectedUser = authState.user.nameUser;
      });
    }
  }

  void _loadUserActivity() {
    if (_selectedUser != null) {
      context.read<ActivityCubit>().getUserActivity(
        userName: _selectedUser!,
        startDate: _startDate,
        endDate: _endDate != null
            ? DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59)
            : null,
      );
    }
  }

  // Method to show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('پەڕاوگەکان'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User dropdown
                UsersDropdown(
                  users: _users,
                  selectedUser: _selectedUser,
                  isLoading: _isLoading,
                  onChanged: (value) {
                    setState(() {
                      _selectedUser = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Date range picker
                DateRangePickerWidget(
                  startDate: _startDate,
                  endDate: _endDate,
                  onStartDateChanged: (date) {
                    setState(() {
                      _startDate = date;
                    });
                  },
                  onEndDateChanged: (date) {
                    setState(() {
                      _endDate = date;
                    });
                  },
                  onSearchPressed: () {
                    _loadUserActivity();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('داخستن'),
            ),
            ElevatedButton(
              onPressed: () {
                _loadUserActivity();
                Navigator.pop(context);
              },
              child: const Text('گەڕان'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تڕاک ئیت ناو'),
        actions: [
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
            tooltip: 'پەڕاوگەکان',
          ),
          // Show username in the app bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return Text(
                      state.user.nameUser,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            tooltip: 'دەرچوون',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selected filters summary (if any)
            if (_selectedUser != null || _startDate != null || _endDate != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, size: 18, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getFilterSummary(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: _showFilterDialog,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),

            // Map and data display
            Expanded(
              child: BlocConsumer<ActivityCubit, ActivityState>(
                listener: (context, state) {
                  if (state is UsersListLoaded) {
                    setState(() {
                      _users = state.users;
                      _isLoading = false;

                      // If no user is selected, select the first one
                      if (_selectedUser == null && _users.isNotEmpty) {
                        _selectedUser = _users[0];
                      }
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ActivityLoading) {
                    return const Center(
                      child: LoadingIndicator(
                        message: 'چاوەڕوانبە...',
                      ),
                    );
                  } else if (state is ActivityError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _loadUserActivity,
                            icon: const Icon(Icons.refresh),
                            label: const Text('دووبارە هەوڵبدەوە'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is ActivityLoaded) {
                    // Show map with data
                    return Column(
                      children: [
                        // Map takes most of the space
                        Expanded(
                          child: Stack(
                            children: [
                              TrackingMapWidget(
                                locations: state.activity.locations,
                                visits: state.activity.customerVisits,
                                showCurrentLocation: _showCurrentLocation,
                              ),
                              // Floating action button to show filter dialog
                              Positioned(
                                top: 16,
                                right: 16,
                                child: FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.white,
                                  onPressed: _showFilterDialog,
                                  child: Icon(
                                    Icons.filter_list,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Footer with summary data (as per annotation "show such an information at the top below the map as footer of map")
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildFooterItem(
                                  Icons.location_on,
                                  'شوێنەكان',
                                  state.activity.summary.totalLocationsRecorded.toString(),
                                ),
                                _buildFooterItem(
                                  Icons.store,
                                  'سەردانەکان',
                                  state.activity.summary.totalCustomerVisits.toString(),
                                ),
                                _buildFooterItem(
                                  Icons.receipt,
                                  'پسوولەکان',
                                  state.activity.summary.visitsWithInvoice.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.map,
                            color: Colors.grey,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'بەكارهێنەرێك هەڵبژێرە و کلیک لەسەر گەڕان بکە',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Footer item widget to show summary info below the map
  Widget _buildFooterItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to show current filter settings
  String _getFilterSummary() {
    List<String> parts = [];

    if (_selectedUser != null) {
      parts.add('بەکارهێنەر: $_selectedUser');
    }

    if (_startDate != null) {
      final date = '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}';
      parts.add('لە: $date');
    }

    if (_endDate != null) {
      final date = '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}';
      parts.add('بۆ: $date');
    }

    return parts.isEmpty ? 'هیچ پەڕاوگەیەک دیاری نەکراوە' : parts.join(' | ');
  }
}