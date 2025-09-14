import 'dart:async';

import 'package:flutter/material.dart';

/// A utility class that converts a [Stream] into a [Listenable] for `GoRouter`.
///
/// This class listens to a stream and notifies its listeners whenever the stream
/// emits a new value. This is the standard approach to make `GoRouter`
/// react to state changes, such as user authentication.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a new instance of [GoRouterRefreshStream].
  ///
  /// The constructor takes a [Stream] and immediately starts listening to it.
  /// When the stream emits a value, [notifyListeners] is called.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
