package com.example.demo_ewallet;

import android.util.Log;

public class DialogResultHandler implements FingerprintDialog.DialogResultListener {

    public DialogResultHandler() {
    }

    @Override
    public void onAuthenticated() {
        FingerprintMethod.inProgress = false;
        Log.e("Success", "Successfully authenticated.");
    }

    @Override
    public void onError(String errorString, int errorCode) {
        FingerprintMethod.inProgress = false;
        Log.e("onError", "Error authenticated.");

    }

    @Override
    public void onCancelled() {
        FingerprintMethod.inProgress = false;
    }
}
