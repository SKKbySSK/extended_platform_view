package work.kscafe.extended_platform_view

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine

import io.flutter.embedding.engine.plugins.FlutterPlugin

val FlutterEngine.extendedPlatformView
  get() = plugins.get(ExtendedPlatformViewPlugin::class.java)!! as ExtendedPlatformViewPlugin

/** ExtendedPlatformViewPlugin */
class ExtendedPlatformViewPlugin: FlutterPlugin {
  private val registeredViews = mutableMapOf<String, ExtendedPlatformViewBuilder>()
  private var currentBinding: FlutterPlugin.FlutterPluginBinding? = null

  fun register(viewType: String, viewBuilder: ExtendedPlatformViewBuilder) {
    registeredViews[viewType] = viewBuilder
    currentBinding?.let {
      registerPlatformView(it, viewType, viewBuilder)
    }
  }

  private fun registerPlatformView(binding: FlutterPlugin.FlutterPluginBinding, viewType: String, viewBuilder: ExtendedPlatformViewBuilder) {
    val factory = ExtendedPlatformViewFactoryWrapper(binding.binaryMessenger, viewType, viewBuilder)
    binding.platformViewRegistry.registerViewFactory(viewType, factory)
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    registeredViews.forEach {
      registerPlatformView(flutterPluginBinding, it.key, it.value)
    }
    currentBinding = flutterPluginBinding
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    currentBinding = null
  }
}
