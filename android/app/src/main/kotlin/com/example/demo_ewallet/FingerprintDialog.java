package com.example.demo_ewallet;


import android.annotation.SuppressLint;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
import android.hardware.fingerprint.FingerprintManager;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;

public class FingerprintDialog extends DialogFragment implements FingerprintHandler.Callback {

    private FingerprintManager.CryptoObject mCryptoObject;
    private DialogResultListener dialogCallback;
    private FingerprintHandler mFingerprintHandler;
    private boolean isAuthInProgress;
    private Button mCancelButton;
    private final int TOO_MANY_ATTEMPT_CODE = 7;

    private ImageView mFingerprintImage;
    private TextView mFingerprintDescription;
    private TextView mFingerprintSensorDescription;
    private TextView mFingerprintError;
    private String authReason;
    private int imageColor = 0;
    private int imageErrorColor = 0;
    private String dialogTitle = "";
    private String cancelText = "";
    private String cancelTextTooManyAttempt = "";
    private String sensorDescription = "";
    private String sensorErrorDescription = "";
    private String tooManyAttempError = "";
    private String errorText = "";

    HashMap<String, Boolean> authen = new HashMap<>();

    private MethodChannel.Result result;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        this.mFingerprintHandler = new FingerprintHandler(context, this);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(DialogFragment.STYLE_NORMAL, android.R.style.Theme_Material_Light_Dialog);
        // setCancelable(false);
    }

    @SuppressLint("MissingInflatedId")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v = inflater.inflate(R.layout.fingerprint_dialog, container, false);
        getDialog().setCanceledOnTouchOutside(false);
        getDialog().getWindow().setBackgroundDrawableResource(R.drawable.bg_touch_id_xml);
        //getDialog().getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        this.mFingerprintDescription = (TextView) v.findViewById(R.id.fingerprint_description);
        this.mFingerprintDescription.setText(this.authReason);

        this.mFingerprintImage = (ImageView) v.findViewById(R.id.fingerprint_icon);
//        if (this.imageColor != 0) {
//            this.mFingerprintImage.setColorFilter(this.imageColor);
//        }

        this.mFingerprintSensorDescription = (TextView) v.findViewById(R.id.fingerprint_sensor_description);
        this.mFingerprintSensorDescription.setText(this.sensorDescription);

        this.mFingerprintError = (TextView) v.findViewById(R.id.fingerprint_error);
        this.mFingerprintError.setText(this.errorText);

        this.mCancelButton = (Button) v.findViewById(R.id.cancel_button);
        this.mCancelButton.setText(this.cancelText);
        this.mCancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onCancelled();
            }
        });

        getDialog().setTitle(this.dialogTitle);
        getDialog().setOnKeyListener(new DialogInterface.OnKeyListener() {
            public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
                if (keyCode != KeyEvent.KEYCODE_BACK || mFingerprintHandler == null) {
                    return false; // pass on to be processed as normal
                }
                onCancelled();
                return true; // pretend we've processed it
            }
        });

        return v;
    }

    @Override
    public void onResume() {
        super.onResume();

        if (this.isAuthInProgress) {
            return;
        }

        this.isAuthInProgress = true;
        this.mFingerprintHandler.startAuth(mCryptoObject);
    }

    @Override
    public void onPause() {
        super.onPause();
        if (this.isAuthInProgress) {
            this.mFingerprintHandler.endAuth();
            this.isAuthInProgress = false;
        }
    }

    public void setResult(MethodChannel.Result _result) {
        this.result = _result;
    }


    public void setCryptoObject(FingerprintManager.CryptoObject cryptoObject) {
        this.mCryptoObject = cryptoObject;
    }

    public void setDialogCallback(DialogResultListener newDialogCallback) {
        this.dialogCallback = newDialogCallback;
    }

    public void setReasonForAuthentication(String reason) {
        this.authReason = reason;
    }

    public void setAuthConfig(final HashMap config) {
        if (config == null) {
            return;
        }

        if (config.containsKey("title")) {
            this.dialogTitle = (String) config.get("title");
        }

        if (config.containsKey("cancelText")) {
            this.cancelText = (String) config.get("cancelText");
        }

        if (config.containsKey("sensorDescription")) {
            this.sensorDescription = (String) config.get("sensorDescription");
        }

        if (config.containsKey("sensorErrorDescription")) {
            this.sensorErrorDescription = (String) config.get("sensorErrorDescription");
        }

        if (config.containsKey("imageColor")) {
            this.imageColor = (int) config.get("imageColor");
        }

        if (config.containsKey("imageErrorColor")) {
            this.imageErrorColor = (int) config.get("imageErrorColor");
        }

        if (config.containsKey("sensorTooManyAttemptDescription")) {
            this.tooManyAttempError = (String) config.get("sensorTooManyAttemptDescription");
        }
        if (config.containsKey("cancelTextTooManyAttempt")) {
            this.cancelTextTooManyAttempt = (String) config.get("cancelTextTooManyAttempt");
        }
    }

    public interface DialogResultListener {
        void onAuthenticated();

        void onError(String errorString, int errorCode);

        void onCancelled();
    }

    @Override
    public void onAuthenticated() {
        this.isAuthInProgress = false;
        this.dialogCallback.onAuthenticated();

        authen.put("success", true);
        this.result.success(authen);
        dismiss();
    }

    @Override
    public void onError(String errorString, int errorCode) {
        this.mFingerprintError.setText(errorString + "" + errorCode);
//        this.mFingerprintImage.setColorFilter(this.imageErrorColor);
        if (errorCode == TOO_MANY_ATTEMPT_CODE) {
//            authen.put("error", "1");

            HashMap<String, String> er = new HashMap<>();
            er.put("error", Integer.toString(TOO_MANY_ATTEMPT_CODE));
            er.put("message", "Try too many attempt");

            this.result.success(er);
            this.mFingerprintDescription.setText(this.authReason);
            this.mFingerprintSensorDescription.setText(this.tooManyAttempError);
            this.mCancelButton.setText(this.cancelTextTooManyAttempt);
            return;
        }

        this.mFingerprintDescription.setText(this.sensorErrorDescription);
//      this.mFingerprintDescription.setTextColor(this.imageErrorColor);
    }

    @Override
    public void onCancelled() {
        this.isAuthInProgress = false;
        this.mFingerprintHandler.endAuth();
        this.dialogCallback.onCancelled();
        dismiss();
    }
}