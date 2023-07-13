package com.example.demo_ewallet;


import android.annotation.TargetApi;
import android.content.Context;
import android.hardware.fingerprint.FingerprintManager;
import android.os.Build;
import android.os.CancellationSignal;
import android.util.Log;

@TargetApi(Build.VERSION_CODES.M)
public class FingerprintHandler extends FingerprintManager.AuthenticationCallback {

    private CancellationSignal cancellationSignal;
    private boolean selfCancelled;

    private final FingerprintManager mFingerprintManager;
    private final Callback mCallback;

    public FingerprintHandler(Context context, Callback callback) {
        mFingerprintManager = context.getSystemService(FingerprintManager.class);
        mCallback = callback;
    }

    public void startAuth(FingerprintManager.CryptoObject cryptoObject) {
        cancellationSignal = new CancellationSignal();
        selfCancelled = false;
        mFingerprintManager.authenticate(cryptoObject, cancellationSignal, 0, this, null);
    }

    public void endAuth() {
        cancelAuthenticationSignal();
    }

    @Override
    public void onAuthenticationError(int errCode,
                                      CharSequence errString) {
        Log.e("onAuthenticationError", "" + errCode + " " + errString);
        if (!selfCancelled) {
            mCallback.onError(errString.toString(), errCode);
        }

    }

    @Override
    public void onAuthenticationFailed() {
        Log.e("onAuthenticationFailed", "" + FingerprintAuthConstants.AUTHENTICATION_FAILED);
        mCallback.onError("Not recognized. Try again.", FingerprintAuthConstants.AUTHENTICATION_FAILED);
    }

    @Override
    public void onAuthenticationSucceeded(FingerprintManager.AuthenticationResult result) {
        mCallback.onAuthenticated();
        cancelAuthenticationSignal();

    }

    private void cancelAuthenticationSignal() {
        selfCancelled = true;
        if (cancellationSignal != null) {
            cancellationSignal.cancel();
            cancellationSignal = null;
        }
    }

    public interface Callback {
        void onAuthenticated();

        void onError(String errorString, int errorCode);

        void onCancelled();
    }
}
