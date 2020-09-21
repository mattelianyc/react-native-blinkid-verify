package com.microblink.blinkid.verify.sample

import android.os.Bundle
import android.widget.ImageView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.microblink.blinkid.verify.VerifySDK
import com.microblink.blinkid.verify.manager.config.api.*
import com.microblink.blinkid.verify.manager.config.api.filter.DocumentFilter
import com.microblink.blinkid.verify.result.api.*
import com.microblink.blinkid.verify.result.api.config.fields.*
import com.microblink.blinkid.verify.result.api.config.fields.validation.Validator
import com.microblink.entities.recognizers.blinkid.generic.classinfo.Country
import com.microblink.entities.recognizers.blinkid.generic.classinfo.Region
import com.microblink.entities.recognizers.blinkid.generic.classinfo.Type
import kotlinx.android.parcel.Parcelize
import kotlinx.android.synthetic.main.activity_main.*
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btnStart.setOnClickListener {
            VerifySDK.startVerification(this, createVerifyConfiguration())
        }
    }

    private fun shouldShowResultsInDialog(): Boolean {
        // TODO return true to show results in dialog
        return false
    }

    private fun createVerifyConfiguration(): VerifyConfiguration {
        // license file from assets folder
        val microblinkLicense = MicroblinkLicenseFile("com.microblink.blinkid.verify.dev.sample.mblic")
        return VerifyConfiguration.Builder(microblinkLicense, verificationFinishListener)
            .verificationServiceUrl("https://blinkid-verify-ws.microblink.com/verification")
            // you can set your custom date format for displaying dates in result
            .dateFormat(SimpleDateFormat("dd MMM yyyy", Locale.getDefault()))
            .verificationSteps(
                BlinkIdScanStep.Builder()
                    // array of DocumentFields that will be shown in the result screen and returned
                    // via documentResultListener
                    .documentFields(buildDocumentFields())
                    // whether to show full document images in result screen
                    .showDocumentImages(true)
                    // listener for the document scanning results
                    .documentResultListener(documentResultListener)
                    // document filter, if not set, all supported documents will be allowed
                    .documentFilter(CustomDocumentFilter())
                    .build(),
                LivenessCheckStep.Builder("<your_liveness_license_key>")
                    // listener for the liveness detection result
                    .livenessResultListener(livenessResultListener)
                    .build()
            )
            .build()
    }

    fun buildDocumentFields(): Array<DocumentField> {
        // This array defines which fields are shown in the result screen and their order. Also, only
        // these fields are returned in the result. Some fields can be modified by user (inserted or
        // edited), for such fields you can define ModificationConfig. By default, when ModificationConfig
        // is not defined for some field, editing and inserting are not allowed.
        return arrayOf(
            // first name will be editable if it is scanned from the document
            FieldFirstName(ModificationConfig(insertable = false, editable = true)),
            // last name will be editable if it is scanned from the document
            FieldLastName(ModificationConfig(insertable = false, editable = true)),
            FieldFullName(),
            FieldDateOfBirth(),
            FieldSex(),
            // If personal id number is not scanned from the document, user will be able to insert it.
            // If it is scanned from the document, it won't be editable (if you want it to be editable
            // in this case, you should also set editable flag to true).
            // Also, we have defined custom validator here which requires that all inserted characters
            // must be digits for a personal id number to be valid.
            FieldPersonalIdNumber(ModificationConfig(
                insertable = true,
                editable = false,
                // validator used on the results screen for this field
                validator = object : Validator {
                    override fun validateValue(value: String): Boolean {
                        value.forEach { c ->
                            if (!c.isDigit()) return false
                        }
                        return value.isNotEmpty()
                    }
                }
            )),
            FieldAddress(),
            FieldNationality(),
            FieldDocumentNumber(),
            FieldIssuingAuthority(),
            FieldDateOfIssue(),
            FieldDateOfExpiry(),
            FieldDocumentAdditionalNumber()
            // there are more fields available
        )
    }

    private val documentResultListener = object : DocumentResultListener {
        override fun onResultConfirmed(
            result: DocumentResult,
            flowHandler: VerificationFlowHandler
        ) {
            // invoked after the user has confirmed (and maybe modified) the document scanning result
            // FieldType -> ResultField map of all result fields
            val resultFieldsMap = result.getResultFieldsAsMap()
            // only fields that are requested by the buildDocumentFields() method and are successfully
            // scanned from the document or inserted by the user are returned
            val firstName = resultFieldsMap[FieldType.FIRST_NAME]
            val lastName = resultFieldsMap[FieldType.LAST_NAME]
            val dateOfBirth = resultFieldsMap[FieldType.DATE_OF_BIRTH]
            // we show only few returned fields for simplicity
            val resultText = "First name: ${firstName?.toDisplayString() ?: ""}\n" +
                        "Last name: ${lastName?.toDisplayString() ?: ""}\n" +
                        "Date of birth: ${dateOfBirth?.toDisplayString() ?: ""}"


            if (shouldShowResultsInDialog()) {
                // Pause verification flow to return control from the Verify SDK to this activity.
                // After verification flow is paused, you can do your custom logic on returned
                // results, for example, validate results in some way and resume verification
                // process if the results are valid, or cancel verification process otherwise.
                flowHandler.pauseVerificationFlow()
                AlertDialog.Builder(this@MainActivity)
                    .setTitle("Scan results")
                    .setMessage(resultText)
                    .setCancelable(false)
                    .setOnCancelListener() {
                        // we will resume verification flow when dialog is cancelled
                        flowHandler.resumeVerificationFlow(this@MainActivity)
                        // for some other use cases, you can cancel verification flow by calling
                        // flowHandler.cancelVerificationFlow()
                    }
                    .setPositiveButton(R.string.dialog_btn_close) { dialog, _ ->
                        dialog.cancel()
                    }
                    .create()
                    .show()
            } else {
                // remain in the verification flow and just show the Toast message
                Toast.makeText(
                    this@MainActivity,
                    resultText,
                    Toast.LENGTH_LONG
                ).show()
            }
        }
    }

    private val livenessResultListener = object : LivenessResultListener {
        override fun onLivenessCheckFailed() {
            // TODO do something when liveness check has failed
        }

        override fun onLivenessCheckSuccess(
            result: LivenessResult,
            flowHandler: VerificationFlowHandler
        ) {
            val faceImage = result.faceImage
            if (shouldShowResultsInDialog()) {
                // pause verification flow
                flowHandler.pauseVerificationFlow()
                val imageView = ImageView(this@MainActivity)
                imageView.setImageBitmap(faceImage)
                AlertDialog.Builder(this@MainActivity)
                    .setTitle("Face image")
                    .setView(imageView)
                    .setCancelable(false)
                    .setOnCancelListener() {
                        // we will resume verification flow when dialog is canceled
                        flowHandler.resumeVerificationFlow(this@MainActivity)
                    }
                    .setPositiveButton(R.string.dialog_btn_close) {dialog, _ ->
                        dialog.cancel()
                    }
                    .create()
                    .show()
            } else {
                // remain in the verification flow and just show the Toast message
                Toast.makeText(
                    this@MainActivity,
                    "Face image WxH = ${faceImage.width}x${faceImage.height}",
                    Toast.LENGTH_LONG
                ).show()
            }
        }
    }

    private fun ResultField.toDisplayString(): String {
        return when (this) {
            is StringResultField -> value
            is InsertedStringResultField -> insertedValue
            is EditedStringResultField -> editedValue
            is DateResultField -> date.toDisplayString(this@MainActivity)
            is BooleanResultField -> value.toString()
        }
    }

    private val verificationFinishListener = object: VerificationFinishListener {
        override fun onVerificationCanceled() {
            Toast.makeText(this@MainActivity, "Verification canceled", Toast.LENGTH_LONG).show()
        }

        override fun onVerificationFailed() {
            Toast.makeText(this@MainActivity, "Verification failed", Toast.LENGTH_LONG).show()
        }

        override fun onVerificationSuccess() {
            Toast.makeText(this@MainActivity, "Verification successful", Toast.LENGTH_LONG).show()
        }
    }

    /**
     * Custom document filter which allows all documents.
     */
    @Parcelize
    class CustomDocumentFilter: DocumentFilter {
        /**
         * Called while scanning document, after the document is detected to determine whether the
         * document should be processed or not, based on the detected country, region and type of
         * the scanned document.
         */
        override fun isDocumentAllowed(country: Country, region: Region, type: Type): Boolean {
            // we will allow all documents regardless of the detected document country, region and type
            // you can do your custom logic here
            return true
        }

    }
}