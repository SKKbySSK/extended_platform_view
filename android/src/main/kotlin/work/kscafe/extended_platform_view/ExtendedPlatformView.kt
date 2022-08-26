package work.kscafe.extended_platform_view

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

typealias ExtendedPlatformViewBuilder = () -> ExtendedPlatformView

data class CreationParams(val viewId: Int, val args: Any?)

abstract class ExtendedPlatformView() {
    lateinit var context: Context
        private set
    lateinit var binaryMessenger: BinaryMessenger
        private set
    lateinit var methodChannel: MethodChannel
        private set
    lateinit var view: View
        private set

    internal fun initInternal(context: Context, messenger: BinaryMessenger, viewType: String, id: Int, params: CreationParams) {
        this.context = context
        binaryMessenger = messenger
        methodChannel = MethodChannel(messenger, "${viewType}/${id}/method")
        view = initialize(params)
    }

    abstract fun initialize(params: CreationParams): View

    fun onFlutterViewAttached(flutterView: View) {}
    fun onFlutterViewDetached() {}
    fun dispose() {}
}

internal class ExtendedPlatformViewFactoryWrapper(
    private val messenger: BinaryMessenger,
    private val viewType: String,
    private val builder: ExtendedPlatformViewBuilder): PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val view = builder().also {
            val params = CreationParams(viewId, args)

            // MEMO: force unwrapping context. see: https://github.com/flutter/flutter/issues/104480
            it.initInternal(context!!, messenger, viewType, viewId, params)
        }
        return ExtendedPlatformViewWrapper(view)
    }

    internal class ExtendedPlatformViewWrapper(private val platformView: ExtendedPlatformView): PlatformView {
        override fun getView(): View {
            return platformView.view
        }

        override fun dispose() {
            platformView.dispose()
        }

        override fun onFlutterViewAttached(flutterView: View) {
            platformView.onFlutterViewAttached(flutterView)
        }

        override fun onFlutterViewDetached() {
            platformView.onFlutterViewDetached()
        }
    }
}