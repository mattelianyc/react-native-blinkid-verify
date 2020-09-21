package com.microblink.blinkid.verify.sample;

import android.os.Bundle;
import android.widget.Button;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.microblink.blinkid.verify.VerifySDK;
import com.microblink.blinkid.verify.manager.config.api.BlinkIdScanStep;
import com.microblink.blinkid.verify.manager.config.api.LivenessCheckStep;
import com.microblink.blinkid.verify.manager.config.api.MicroblinkLicenseFile;
import com.microblink.blinkid.verify.manager.config.api.VerificationFinishListener;
import com.microblink.blinkid.verify.manager.config.api.VerifyConfiguration;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button btnStart = findViewById(R.id.btnStart);
        btnStart.setOnClickListener(v -> VerifySDK.startVerification(
                MainActivity.this,
                new VerifyConfiguration.Builder(
                        new MicroblinkLicenseFile("com.microblink.blinkid.verify.dev.sample.mblic"),
                        verificationFinishListener
                )
                        .verificationServiceUrl("https://blinkid-verify-ws.microblink.com/verification")
                        .verificationSteps(
                                new BlinkIdScanStep.Builder().build(),
                                new LivenessCheckStep.Builder("<your_liveness_license_key>").build()
                        )
                        .build()
        ));

    }

    private VerificationFinishListener verificationFinishListener = new VerificationFinishListener() {
        @Override
        public void onVerificationSuccess() {
            Toast.makeText(MainActivity.this, "Verification successful", Toast.LENGTH_LONG).show();
        }

        @Override
        public void onVerificationFailed() {
            Toast.makeText(MainActivity.this, "Verification failed", Toast.LENGTH_LONG).show();
        }

        @Override
        public void onVerificationCanceled() {
            Toast.makeText(MainActivity.this, "Verification canceled", Toast.LENGTH_LONG).show();
        }
    };

}
