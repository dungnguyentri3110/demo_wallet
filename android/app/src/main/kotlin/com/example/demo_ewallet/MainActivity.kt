package com.example.demo_ewallet

import android.os.AsyncTask
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.biometric.BiometricManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutionException

class MainActivity: FlutterActivity() {

    private val CHANNEL = "e_wallet_app_v03"

    private val CHECK_IS_ENROLL = "CHECK_IS_ENROLL"
    private val AUTHEN_BIOMETRIC = "AUTHEN_BIOMETRIC"

    var fingerprintDialog: FingerprintDialog? = null
    var fingerprintMethod: FingerprintMethod? = null
    var mBiometricManager: androidx.biometric.BiometricManager? = null


    override fun onStart() {
        super.onStart()
        mBiometricManager = BiometricManager.from(this)
        fingerprintDialog = FingerprintDialog()
        fingerprintMethod = FingerprintMethod(this, fingerprintDialog)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)



        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                CHECK_IS_ENROLL -> {
                    var enroll: java.util.HashMap<*, *>? = null
                    enroll = try {
                        checkIsEnroll()
                    } catch (e: ExecutionException) {
                        throw RuntimeException(e)
                    } catch (e: InterruptedException) {
                        throw RuntimeException(e)
                    }

                    result.success(enroll)
                }

                AUTHEN_BIOMETRIC -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        onAuthenFinger(call.argument("config"), result)
                    }
                }

                else -> {

                }
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    @Throws(
        ExecutionException::class,
        InterruptedException::class
    )
    fun checkIsEnroll(): HashMap<*, *>? {
        val result: AsyncTask<*, *, *> = Biometric(mBiometricManager).execute()
        return result.get() as HashMap<*, *>
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    fun onAuthenFinger(
        config: java.util.HashMap<*, *>?,
        _result: MethodChannel.Result?
    ): java.util.HashMap<*, *>? {
        return fingerprintMethod!!.authenticate(config, _result)
    }


    override fun onResume() {
        super.onResume()
        FingerprintMethod.isAppActive = true;
    }

    override fun onPause() {
        super.onPause()
        if (fingerprintDialog?.isVisible() == true) {
            FingerprintMethod.isAppActive = false;
            FingerprintMethod.inProgress = false;
            fingerprintDialog?.dismiss();
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (fingerprintDialog?.isVisible() == true) {
            FingerprintMethod.isAppActive = false;
            FingerprintMethod.inProgress = false;
            fingerprintDialog?.dismiss();
        }
    }
}
