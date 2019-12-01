package cz.papajik.vivarium_control_unit

import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.particle.android.sdk.cloud.ApiFactory
import io.particle.android.sdk.cloud.ParticleCloudSDK
import io.particle.android.sdk.devicesetup.ParticleDeviceSetupLibrary


val TAG = "MyActivity"


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ParticleCloudSDK.initWithOauthCredentialsProvider(this,
                object : ApiFactory.OauthBasicAuthCredentialsProvider {
                    override fun getClientId(): String {
                        return "vivarium-control-app-7262"
                    }
                    override fun getClientSecret(): String {
                        return "98a4382f0797364a947fea1a83dd852b85ec1f32"
                    }
                })
        ParticleDeviceSetupLibrary.init(this)
        //ParticleDeviceSetupLibrary.startDeviceSetup(this,  )
        //Unit ParticleCloudSDK.getCloud().signUpWithUser()



        GeneratedPluginRegistrant.registerWith(this)
    }
}
