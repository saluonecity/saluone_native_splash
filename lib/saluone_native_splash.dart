import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SaluoneNativeSplash {
  static const MethodChannel _channel = MethodChannel('saluone_native_splash');

  @Deprecated('This class is deprecated use [remove]')
  static void removeAfter(
    Future<void> Function(BuildContext) initializeFunction,
  ) {
    final binding = WidgetsFlutterBinding.ensureInitialized();

    // Prevents app from closing splash screen, app layout will be build but not displayed.
    binding.deferFirstFrame();
    binding.addPostFrameCallback((_) async {
      final BuildContext? context = binding.renderViewElement;
      if (context != null) {
        // Run any sync or awaited async function you want to wait for before showing app layout
        await initializeFunction.call(context);
      }

      // Closes splash screen, and show the app layout.
      binding.allowFirstFrame();
      if (kIsWeb) {
        remove();
      }
    });
  }

  static WidgetsBinding? _widgetsBinding;

  // Prevents app from closing splash screen, app layout will be build but not displayed.
  static void preserve({required WidgetsBinding widgetsBinding}) {
    _widgetsBinding = widgetsBinding;
    _widgetsBinding?.deferFirstFrame();
  }

  static void remove() {
    _widgetsBinding?.allowFirstFrame();
    _widgetsBinding = null;
    if (kIsWeb) {
      // Use SchedulerBinding to avoid white flash on splash removal.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        try {
          _channel.invokeMethod('remove');
        } catch (e) {
          throw Exception(
            '$e\nDid you forget to run "dart run saluone_native_splash:create"?',
          );
        }
      });
    }
  }
}
