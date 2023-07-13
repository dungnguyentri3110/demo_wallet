package com.example.demo_ewallet;


import android.os.AsyncTask;
import android.os.Build;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyPermanentlyInvalidatedException;
import android.security.keystore.KeyProperties;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.biometric.BiometricManager;

import java.security.Key;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.cert.Certificate;
import java.util.HashMap;
import java.util.UUID;

import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;

@RequiresApi(api = Build.VERSION_CODES.M)
public class Biometric extends AsyncTask {
    public static final String KEY_NAME = "EPAY_BIO";
    private static final String SECRET_MESSAGE = "EPAY_BIO_SECRET";
    private BiometricManager mBiometricManager;

    Biometric(BiometricManager bioManager){
        mBiometricManager = bioManager;
    }


    @Override
    protected Object doInBackground(Object[] objects) {
        HashMap result = isEnrolledAsync();
        return result;
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    public HashMap isEnrolledAsync() {
        HashMap<String, Boolean> isEnroll = new HashMap<>();
        HashMap<String, String> hashToken = new HashMap<>();
        HashMap<String, String> error = new HashMap<>();
        HashMap hashResult = new HashMap();

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            int result = 0;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                result = mBiometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_WEAK);
            }
            boolean isEnrolled = result == BiometricManager.BIOMETRIC_SUCCESS;
            isEnroll.put("isEnrolled", isEnrolled);
            Log.e("BiometricModule", "isEnroll ==> " + isEnrolled);
            try {
                Cipher cipher = getCipher();
                KeyPair keyPair = getKeyPair();
                if (keyPair == null) {
                    Log.e("BiometricModule", "keyPair null, regenerate");
                    keyPair = genKeyPair();
                    Log.e("BiometricModule", "keyPair=" + keyPair.toString());
                }

                cipher.init(Cipher.DECRYPT_MODE, keyPair.getPrivate());
                String token = Base64.encodeToString(keyPair.getPublic().getEncoded(), 2);
                Log.e("BiometricModule", "token ===>" + token);
                if (token != null) {
                    Log.e("BiometricModule", "Put token to map");
                    hashToken.put("token", token);
                }
                hashResult.putAll(isEnroll);
                hashResult.putAll(hashToken);
            } catch (KeyPermanentlyInvalidatedException ex) {
                try {
                    Log.e("BiometricModule", "KeyPermanentlyInvalidatedException");
                    genKeyPair();
                } catch (Exception e) {
                    Log.e("BiometricModule", "Exception: " + e.getMessage());
                    e.printStackTrace();
                    error.put("errorCode", "-1");
                    hashResult.putAll(error);
                }
//                isEnrolledAsync();
            } catch (Exception ex) {
                ex.printStackTrace();
                hashResult.putAll(hashToken);
                hashResult.putAll(error);
                hashResult.putAll(isEnroll);
            }

        } else {
            isEnroll.put("isEnrolled",false);
            hashToken.put("token", UUID.randomUUID().toString());
            hashResult.putAll(isEnroll);
            hashResult.putAll(hashToken);
        }
        return hashResult;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private KeyPair genKeyPair() throws Exception {
        return generateKeyPair(
                new KeyGenParameterSpec.Builder(
                        KEY_NAME,
                        KeyProperties.PURPOSE_DECRYPT)
                        .setDigests(KeyProperties.DIGEST_SHA256, KeyProperties.DIGEST_SHA512)
                        .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_RSA_OAEP)
                        .setInvalidatedByBiometricEnrollment(true)
                        .setUserAuthenticationRequired(true)
                        .build());
    }
    @RequiresApi(api = Build.VERSION_CODES.M)
    private KeyPair generateKeyPair(KeyGenParameterSpec keyGenParameterSpec) throws Exception {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(
                KeyProperties.KEY_ALGORITHM_RSA, "AndroidKeyStore");
        keyPairGenerator.initialize(keyGenParameterSpec);
        return keyPairGenerator.generateKeyPair();
    }

    private KeyPair getKeyPair() throws Exception {
        KeyStore keyStore = KeyStore.getInstance("AndroidKeyStore");

        // Before the keystore can be accessed, it must be loaded.
        keyStore.load(null);
        Key key = keyStore.getKey(KEY_NAME, null);
        if (key instanceof PrivateKey && keyStore.getCertificate(KEY_NAME) != null) {
            // Get certificate of public key
            Certificate cert = keyStore.getCertificate(KEY_NAME);

            // Get public key
            PublicKey publicKey = cert.getPublicKey();

            // Return a key pair
            return new KeyPair(publicKey, (PrivateKey) key);
        }
        return null;
    }

    private Cipher getCipher() throws NoSuchPaddingException, NoSuchAlgorithmException {
        return Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
    }
}
