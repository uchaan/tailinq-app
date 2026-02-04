import 'package:flutter/material.dart';

enum SocialProvider {
  google,
  apple,
}

class SocialSignInButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback onPressed;
  final bool enabled;

  const SocialSignInButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(),
          const SizedBox(width: 12),
          Text(
            _getButtonText(),
            style: TextStyle(
              color: enabled ? Colors.black87 : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider) {
      case SocialProvider.google:
        return Image.network(
          'https://www.google.com/favicon.ico',
          width: 20,
          height: 20,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.g_mobiledata,
            size: 24,
            color: Colors.red,
          ),
        );
      case SocialProvider.apple:
        return const Icon(
          Icons.apple,
          size: 24,
          color: Colors.black,
        );
    }
  }

  String _getButtonText() {
    switch (provider) {
      case SocialProvider.google:
        return 'Continue with Google';
      case SocialProvider.apple:
        return 'Continue with Apple';
    }
  }
}

class SocialSignInButtons extends StatelessWidget {
  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final bool enabled;
  final bool showApple;

  const SocialSignInButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
    this.enabled = true,
    this.showApple = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialSignInButton(
          provider: SocialProvider.google,
          onPressed: onGooglePressed,
          enabled: enabled,
        ),
        if (showApple) ...[
          const SizedBox(height: 12),
          SocialSignInButton(
            provider: SocialProvider.apple,
            onPressed: onApplePressed,
            enabled: enabled,
          ),
        ],
      ],
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }
}
