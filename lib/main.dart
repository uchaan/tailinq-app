import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'amplifyconfiguration.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(
    const ProviderScope(
      child: TailinqApp(),
    ),
  );
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugins([auth]);
    await Amplify.configure(amplifyconfig);
    debugPrint('Amplify configured successfully');
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify was already configured');
  } catch (e) {
    debugPrint('Error configuring Amplify: $e');
  }
}
