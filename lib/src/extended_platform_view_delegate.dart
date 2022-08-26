/// Mixin that detects platform view lifecycle
mixin ExtendedPlatformViewDelegate {
  /// Called when the native view has been created.
  void onPlatformViewCreated(String viewType, int id);

  /// Called when the native view has been disposed.
  void onPlatformViewDispose();
}
