package work.kscafe.extended_platform_view_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import work.kscafe.extended_platform_view.extendedPlatformView

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.extendedPlatformView.apply {
            register(SamplePlatformView.viewType) { SamplePlatformView() }
        }
    }
}
