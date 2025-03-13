import 'package:flutter/material.dart';

class UsersDropdown extends StatelessWidget {
  final List<String> users;
  final String? selectedUser;
  final Function(String?) onChanged;
  final bool isLoading;

  const UsersDropdown({
    Key? key,
    required this.users,
    required this.selectedUser,
    required this.onChanged,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'بەكارهێنەر هەڵبژێرە',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: isLoading
              ? const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          )
              : Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('بەكارهێنەر هەڵبژێرە'),
                value: selectedUser,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
                onChanged: onChanged,
                items: users.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}