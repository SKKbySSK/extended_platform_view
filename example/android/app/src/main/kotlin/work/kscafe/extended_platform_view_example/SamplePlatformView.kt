package work.kscafe.extended_platform_view_example

import android.view.View
import android.widget.TextView
import work.kscafe.extended_platform_view.CreationParams
import work.kscafe.extended_platform_view.ExtendedPlatformView

class SamplePlatformView: ExtendedPlatformView() {
    override fun initialize(params: CreationParams): View {
        val textView = TextView(context).apply {
            text = params.args as String
        }

        // ExtendedPlatformView generates MethodChannel automatically
        methodChannel.setMethodCallHandler { call, result ->
            when(call.method) {
                "set_text" -> {
                    textView.text = call.arguments as String
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        return textView
    }
}
