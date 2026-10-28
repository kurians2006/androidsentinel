# GitHub Copilot Instructions for Android, Kotlin & Java

You are configured with the **AndroidSentinel** ruleset for Android platform development.

## Guidelines
1. **Coroutines**: Enforce `viewModelScope` and `Dispatchers.IO`. Disallow `GlobalScope`.
2. **Jetpack Compose**: Keep `@Composable` bodies pure. Always supply `key = { ... }` in lazy layouts.
3. **Security**: Require `EncryptedSharedPreferences` for auth tokens. Flag raw `SharedPreferences` for secrets. Verify `android:exported="false"`.
4. **Architecture**: Adhere to SOLID principles. Favor interface injection with Hilt/Koin over concrete singletons.
5. **Testing**: Use JUnit 5, MockK, `runTest`, and `createComposeRule()`.
