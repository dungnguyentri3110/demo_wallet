package com.example.demo_ewallet;

import android.app.Activity;
import android.hardware.fingerprint.FingerprintManager;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.util.HashMap;

import javax.crypto.Cipher;

import io.flutter.plugin.common.MethodChannel;

public class FingerprintMethod {

    private static final String FRAGMENT_TAG = "fingerprint_dialog";
    private Activity activity;
    public static boolean inProgress = false;
    public static boolean isAppActive;
    public FingerprintDialog fingerprintDialog;
    HashMap<String, String> hashError = new HashMap<>();
    HashMap<String, String> result = new HashMap<>();


    public FingerprintMethod(Activity _activity, FingerprintDialog dialog) {
        activity = _activity;
        fingerprintDialog = dialog;
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    public HashMap authenticate(final HashMap authConfig, MethodChannel.Result _result) {

        if (inProgress || activity == null) {
            hashError.put("error", "0");
            hashError.put("message", "Current activity not shown");
            result.putAll(hashError);
            return result;
        }
        inProgress = true;


        /* FINGERPRINT ACTIVITY RELATED STUFF */
        final Cipher cipher = new FingerprintCipher().getCipher();
        if (cipher == null) {
            inProgress = false;
            hashError.put("error", Integer.toString(FingerprintAuthConstants.NOT_AVAILABLE));
            hashError.put("message", "Fingerprint not available");
            result.putAll(hashError);

            return result;
        }

        // We should call it only when we absolutely sure that API >= 23.
        // Otherwise we will get the crash on older versions.
        // TODO: migrate to FingerprintManagerCompat
        final FingerprintManager.CryptoObject cryptoObject;
        cryptoObject = new FingerprintManager.CryptoObject(cipher);


        final DialogResultHandler drh = new DialogResultHandler();

        String reason = (String) authConfig.get("reason");

        fingerprintDialog.setCryptoObject(cryptoObject);
        fingerprintDialog.setReasonForAuthentication(reason);
        fingerprintDialog.setAuthConfig(authConfig);
        fingerprintDialog.setDialogCallback(drh);
        fingerprintDialog.setResult(_result);

        if (!isAppActive) {
            inProgress = false;
            hashError.put("error", "2");
            hashError.put("message", "App is not active");
            result.putAll(hashError);
            return result;
        }

        fingerprintDialog.show(activity.getFragmentManager(), FRAGMENT_TAG);
        return result;
    }
}
