# Android Security & Privacy Auditing Rules (OWASP MASVS)

This guide enforces platform-specific security best practices for Android applications, aligned with the **OWASP Mobile Application Security Verification Standard (MASVS)**.

---

## 1. Credential & Data Storage (MASVS-STORAGE)

### Rule: Auth tokens, API keys, and sensitive data MUST be encrypted via `EncryptedSharedPreferences` or Android KeyStore
* **Why**: Standard `SharedPreferences` writes plaintext XML files in `/data/data/<package>/shared_prefs/`, easily readable on rooted devices, via adb backup, or through system compromise.
* **Bad**:
  ```kotlin
  // ❌ Insecure plaintext storage
  val prefs = context.getSharedPreferences("app_prefs", Context.MODE_PRIVATE)
  prefs.edit().putString("auth_token", token).apply()
  ```
* **Good**:
  ```kotlin
  // ✅ Hardware-backed encryption via AndroidX Security
  val masterKey = MasterKey.Builder(context)
      .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
      .build()

  val securePrefs = EncryptedSharedPreferences.create(
      context,
      "secure_prefs",
      masterKey,
      EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
      EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
  )
  securePrefs.edit().putString("auth_token", token).apply()
  ```

---

## 2. Manifest & Component Protection (MASVS-PLATFORM)

### Rule: NEVER export components without explicit intent or permission protection
* **Why**: An `activity`, `service`, `receiver`, or `provider` with `android:exported="true"` can be invoked by any malicious app on the device, allowing intent injection, account takeovers, or privilege escalation.
* **Bad**:
  ```xml
  <!-- ❌ Exposes internal payment activity to third-party apps -->
  <activity
      android:name=".PaymentActivity"
      android:exported="true" />
  ```
* **Good**:
  ```xml
  <!-- ✅ Internal components must be explicitly unexported -->
  <activity
      android:name=".PaymentActivity"
      android:exported="false" />
  ```

---

## 3. Network Communication & Cleartext Traffic (MASVS-NETWORK)

### Rule: Disallow cleartext HTTP traffic globally; enforce TLS 1.3
* **Why**: HTTP traffic is subject to man-in-the-middle (MitM) eavesdropping and packet injection.
* **Bad**:
  ```xml
  <!-- ❌ Allows insecure HTTP communication across the entire application -->
  <application
      android:usesCleartextTraffic="true" ... />
  ```
* **Good**:
  ```xml
  <!-- res/xml/network_security_config.xml -->
  <network-security-config>
      <base-config cleartextTrafficPermitted="false">
          <trust-anchors>
              <certificates src="system" />
          </trust-anchors>
      </base-config>
  </network-security-config>
  ```

---

## 4. Biometric Authentication & Cryptographic Binding (MASVS-AUTH)

### Rule: NEVER use client-side Boolean checks as the sole authorization gate
* **Why**: Attackers with Frida or Xposed can hook `onAuthenticationSucceeded` and execute sensitive actions without physical biometric authorization.
* **Good**: Cryptographically bind the operation with `BiometricPrompt.CryptoObject(cipher)` so that the KeyStore only decrypts the payload if hardware authentication succeeded.

---

## 5. Telemetry & Privacy Logging (MASVS-PRIVACY)

### Rule: NEVER log PII, passwords, or session tokens via `Log.d()` or `System.out.println()`
* **Why**: Android `logcat` buffers can be read by diagnostics tools and connected computers.
* **Good**: Use `Timber` with a `Tree` that completely disables debug logs in release builds:
  ```kotlin
  if (BuildConfig.DEBUG) {
      Timber.plant(Timber.DebugTree())
  }
  ```
