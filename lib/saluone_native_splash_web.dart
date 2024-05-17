import 'dart:async';

import 'package:flutter/services.dart';
import 'package:saluone_native_splash/remove_splash_from_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class SaluoneNativeSplashWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'saluone_native_splash',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = SaluoneNativeSplashWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'remove':
        try {
          removeSplashFromWeb();
        } catch (e) {
          throw Exception(
            'Did you forget to run "dart run saluone_native_splash:create"? \n Could not run the JS command removeSplashFromWeb()',
          );
        }
        return;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              "saluone_native_splash for web doesn't implement '${call.method}'",
        );
    }
  }
}
