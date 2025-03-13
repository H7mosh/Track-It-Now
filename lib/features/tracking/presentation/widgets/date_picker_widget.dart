import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/config/theme.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?) onStartDateChanged;
  final Function(DateTime?) onEndDateChanged;
  final VoidCallback onSearchPressed;

  const DateRangePickerWidget({
    Key? key,
    this.startDate,
    this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'بەرواری گەڕان',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Start date picker
            Expanded(
              child: _buildDatePickerField(
                context,
                label: 'لە',
                date: startDate,
                onDateSelected: onStartDateChanged,
              ),
            ),
            const SizedBox(width: 8),
            // End date picker
            Expanded(
              child: _buildDatePickerField(
                context,
                label: 'بۆ',
                date: endDate,
                onDateSelected: onEndDateChanged,
              ),
            ),
            const SizedBox(width: 8),
            // Search button
            ElevatedButton(
              onPressed: onSearchPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'گەڕان',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePickerField(
      BuildContext context, {
        required String label,
        required DateTime? date,
        required Function(DateTime?) onDateSelected,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _selectDate(context, date, onDateSelected),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date != null
                        ? intl.DateFormat('yyyy-MM-dd').format(date)
                        : 'هەڵبژێرە',
                    style: TextStyle(
                      fontSize: 14,
                      color: date != null ? Colors.grey[800] : Colors.grey[500],
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
      BuildContext context,
      DateTime? currentDate,
      Function(DateTime?) onDateSelected,
      ) async {
    final DateTime initialDate = currentDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentDate) {
      onDateSelected(picked);
    }
  }
}