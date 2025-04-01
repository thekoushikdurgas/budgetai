package com.durgas.budgetai

import android.Manifest
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.durgas.budgetai/sms"
    private val SMS_PERMISSION_CODE = 100

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkSmsPermission" -> {
                    result.success(isSmsPermissionGranted())
                }
                "requestSmsPermission" -> {
                    requestSmsPermission()
                    result.success(null)
                }
                "getAllSms" -> {
                    if (isSmsPermissionGranted()) {
                        val filter = call.argument<String>("filter")
                        val limit = call.argument<Int>("limit") ?: 100
                        val offset = call.argument<Int>("offset") ?: 0
                        try {
                            val smsMessages = getAllSms(filter, limit, offset)
                            result.success(smsMessages)
                        } catch (e: Exception) {
                            result.error("SMS_READ_ERROR", "Failed to read SMS messages", e.message)
                        }
                    } else {
                        result.error("PERMISSION_DENIED", "SMS permission not granted", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun isSmsPermissionGranted(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.READ_SMS
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestSmsPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_SMS),
            SMS_PERMISSION_CODE
        )
    }

    private fun getAllSms(filter: String?, limit: Int, offset: Int): String {
        val smsList = JSONArray()
        val uri = Uri.parse("content://sms")
        
        val selectionClause = if (!filter.isNullOrEmpty()) {
            "body LIKE ?"
        } else {
            null
        }
        
        val selectionArgs = if (!filter.isNullOrEmpty()) {
            arrayOf("%$filter%")
        } else {
            null
        }
        
        val cursor: Cursor? = contentResolver.query(
            uri,
            null,
            selectionClause,
            selectionArgs,
            "date DESC LIMIT $limit OFFSET $offset"
        )

        if (cursor != null && cursor.moveToFirst()) {
            val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
            
            do {
                val smsObject = JSONObject()
                val addressIndex = cursor.getColumnIndexOrThrow("address")
                val bodyIndex = cursor.getColumnIndexOrThrow("body")
                val dateIndex = cursor.getColumnIndexOrThrow("date")
                val typeIndex = cursor.getColumnIndexOrThrow("type")
                
                smsObject.put("address", cursor.getString(addressIndex))
                smsObject.put("body", cursor.getString(bodyIndex))
                
                val dateMillis = cursor.getLong(dateIndex)
                val date = Date(dateMillis)
                smsObject.put("date", dateFormat.format(date))
                smsObject.put("dateMillis", dateMillis)
                
                // 1 = Inbox, 2 = Sent, 3 = Draft, etc.
                val messageType = cursor.getInt(typeIndex)
                smsObject.put("type", messageType)
                
                var messageTypeText = "Unknown"
                when (messageType) {
                    1 -> messageTypeText = "Inbox"
                    2 -> messageTypeText = "Sent"
                    3 -> messageTypeText = "Draft"
                    4 -> messageTypeText = "Outbox"
                    5 -> messageTypeText = "Failed"
                    6 -> messageTypeText = "Queued"
                }
                smsObject.put("typeText", messageTypeText)
                
                smsList.put(smsObject)
            } while (cursor.moveToNext())
        }
        
        cursor?.close()
        
        return smsList.toString()
    }
}
