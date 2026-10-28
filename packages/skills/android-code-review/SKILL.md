---
name: android-code-review
description: Audits and reviews Android, Kotlin, and Java pull requests, git diffs, and source files. Detects coroutine leaks, Compose recomposition traps, OWASP MASVS vulnerabilities, and architectural anti-patterns.
---

# Android Code Review Specialist

This skill guides a deep, production-grade code review of Android, Kotlin, and Java codebases.

## Review Methodology

### Step 1: Concurrency & Coroutines Verification
1. **Scope Checking**: Ensure no `GlobalScope.launch` exists; ensure `viewModelScope` or `lifecycleScope` is used.
2. **Context & Dispatchers**: Verify background operations use `Dispatchers.IO` or `Dispatchers.Default` via `withContext`.
3. **State Flows**: Verify persistent state uses `StateFlow` and is collected in Compose via `collectAsStateWithLifecycle()`.

### Step 2: Compose Performance & State Hygiene
1. **Body Purity**: Verify no side-effects or mutations exist in Composable function bodies without `LaunchedEffect` or `rememberCoroutineScope`.
2. **Keys in Lazy Layouts**: Ensure all `items()` inside `LazyColumn` or `LazyRow` provide explicit keys.
3. **Stability**: Ensure collection properties in UI states are immutable or wrapped in `@Immutable` classes.

### Step 3: Security & Privacy (OWASP MASVS)
1. **Plaintext Secrets**: Flag any `SharedPreferences` storing tokens, passwords, or PII. Enforce `EncryptedSharedPreferences`.
2. **Exported Components**: Inspect `AndroidManifest.xml` for `android:exported="true"` without permission gates.
3. **Cleartext Traffic**: Flag `android:usesCleartextTraffic="true"`.
4. **Log Sanitization**: Flag `Log.d` or `println` containing credentials or PII.

### Step 4: SOLID Principles & Architecture
1. **Single Responsibility (SRP)**: Ensure UI classes (Composables/Fragments) don't call network or database layers directly.
2. **Dependency Inversion (DIP)**: Verify classes depend on repository interfaces rather than concrete singletons.

### Step 5: Formatting Output
Format reviews using standardized severity tiers:
- `🚨 Critical / Blocker`: Security leaks, exported component flaws, or coroutine leaks.
- `⚠️ Warning`: Compose recomposition traps, missing lazy layout keys, or missing cancellation.
- `💡 Optimization`: Kotlin idioms, derivedStateOf, or test coverage.
