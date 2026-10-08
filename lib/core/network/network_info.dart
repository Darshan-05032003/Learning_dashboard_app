/// Abstraction contract for checking network/internet connectivity.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Simple implementation for network connectivity checking.
/// Can be toggled or backed by connectivity packages in production.
class NetworkInfoImpl implements NetworkInfo {
  bool _mockIsOnline = true;

  NetworkInfoImpl({bool isOnline = true}) : _mockIsOnline = isOnline;

  /// Used in testing or debugging to simulate offline mode.
  void setOnlineStatus({required bool isOnline}) {
    _mockIsOnline = isOnline;
  }

  @override
  Future<bool> get isConnected async => _mockIsOnline;
}
