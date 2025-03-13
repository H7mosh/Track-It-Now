class Validators {
  // Required field validator
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'ئەم خانەیە پێویستە';
    }
    return null;
  }

  // Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'ئەم خانەیە پێویستە';
    }

    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'ئیمەیڵێکی دروست بنووسە';
    }

    return null;
  }

  // Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'ئەم خانەیە پێویستە';
    }

    if (value.length < 6) {
      return 'وشەی نهێنی دەبێت لانیکەم ٦ پیت بێت';
    }

    return null;
  }

  // Confirm password validator
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'ئەم خانەیە پێویستە';
      }

      if (value != password) {
        return 'وشەی نهێنی یەک ناگرنەوە';
      }

      return null;
    };
  }

  // Phone number validator
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone can be optional
    }

    // Basic phone format validation for Iraq
    final phoneRegExp = RegExp(r'^07[3-9][0-9]{8}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'ژمارەی مۆبایلی دروست بنووسە';
    }

    return null;
  }
}