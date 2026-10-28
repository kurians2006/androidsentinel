# AndroidSentinel Agent Manifest

This repository and projects using AndroidSentinel adhere to the following standards across all AI agents (Codex, Claude, Cursor, Antigravity):

## Tech Stack & Targets
- **Languages**: Kotlin 2.0+, Java 17+ / 21+
- **Frameworks**: Jetpack Compose, Kotlin Coroutines, StateFlow, AndroidX Security, Hilt / Koin
- **Architectures**: SOLID principles, MVVM, MVI, Clean Architecture
- **Security Standard**: OWASP Mobile Application Security Verification Standard (MASVS)

## Coding Standards

### Concurrency
- Tie coroutines to structured scopes (`viewModelScope`, `lifecycleScope`). Ban `GlobalScope`.
- Dispatch IO work to `Dispatchers.IO` and CPU work to `Dispatchers.Default`.
- Honor cooperative cancellation with `coroutineContext.ensureActive()`.

### Jetpack Compose
- Keep `@Composable` bodies declarative; avoid side-effects outside `LaunchedEffect`.
- Always provide explicit, stable keys in `LazyColumn` and `LazyRow`.
- Enforce parameter stability with `@Immutable` and `@Stable`.

### Security
- Store sensitive tokens and keys in `EncryptedSharedPreferences` or KeyStore.
- Do not enable `android:usesCleartextTraffic="true"`.
- Explicitly mark non-exported components with `android:exported="false"`.
- Do not output credentials in `Log.d()` or `println()`; use `Timber` stripped in release.

### Testing
- Author test suites using JUnit 5, MockK, `runTest`, and `createComposeRule()`.
