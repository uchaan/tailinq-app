import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool autofocus;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
    this.validator,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.enabled = true,
    this.maxLength,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
        counterText: '',
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;

  const EmailTextField({
    super.key,
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      label: 'Email',
      hint: 'Enter your email',
      keyboardType: TextInputType.emailAddress,
      enabled: enabled,
      validator: validator ?? _defaultEmailValidator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction textInputAction;
  final bool enabled;
  final FocusNode? focusNode;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      label: widget.label,
      hint: widget.hint,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      validator: widget.validator ?? _defaultPasswordValidator,
      onFieldSubmitted: widget.onFieldSubmitted,
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }

  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}

class ConfirmationCodeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;

  const ConfirmationCodeTextField({
    super.key,
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      label: 'Verification Code',
      hint: 'Enter 6-digit code',
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: 6,
      enabled: enabled,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator ?? _defaultCodeValidator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  String? _defaultCodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Verification code is required';
    }
    if (value.length != 6) {
      return 'Enter 6-digit code';
    }
    return null;
  }
}
