---
name: android-security-audit
description: Audits Android applications for OWASP Mobile Top 10 vulnerabilities, insecure SharedPreferences, exported components, cleartext HTTP, and KeyStore integration.
---

# Android Security & Privacy Auditor

This skill performs rigorous static analysis and security auditing of Android applications against the **OWASP Mobile Application Security Verification Standard (MASVS)**.

## Audit Workflow

### Step 1: Storage & Secrets (MASVS-STORAGE)
1. Search codebase for `getSharedPreferences` or `PreferenceManager`.
   - 🛑 Flag if tokens, passwords, API keys, or PII are stored without encryption.
   - Enforce `EncryptedSharedPreferences` or Android KeyStore.
2. Flag hardcoded API keys or secret strings in code or `strings.xml`.

### Step 2: Component Protection (MASVS-PLATFORM)
1. Inspect `AndroidManifest.xml` for all `<activity>`, `<service>`, `<receiver>`, and `<provider>` tags:
   - 🛑 Flag `android:exported="true"` unless explicitly intended for external interaction (e.g., Main/Launcher Activity).
   - Ensure exported components enforce signature permissions (`android:permission`).
2. Search for `PendingIntent` creation without `FLAG_IMMUTABLE` or `FLAG_MUTABLE`.

### Step 3: Network Security (MASVS-NETWORK)
1. Check `AndroidManifest.xml` for `android:usesCleartextTraffic="true"`.
2. Inspect `res/xml/network_security_config.xml` to verify cleartext traffic is disabled and certificate pinning is configured for financial or healthcare applications.

### Step 4: Cryptography & Biometrics (MASVS-AUTH & MASVS-CRYPTO)
1. Flag outdated ciphers (DES, 3DES, MD5, SHA-1 for signatures).
2. Enforce AES-GCM via `MasterKey` or `Cipher.getInstance("AES/GCM/NoPadding")`.
3. Verify `BiometricPrompt` uses `CryptoObject` for sensitive operations rather than simple boolean checks.

### Step 5: Output Report
Produce an audit matrix specifying Vulnerability ID, Severity (Critical, High, Medium, Low), File/Line, and Drop-in Remediation snippet.
