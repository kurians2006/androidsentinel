# Android App Rescue & Health Check Rules (AndroidSentinel)

When auditing, debugging, or performing an App Health Check on an Android (Kotlin/Jetpack Compose) codebase, strictly adhere to the following inspection protocol:

## 1. ANR & Main-Thread Safeguards
- **Dispatcher Enforcement:** Strict rule: No disk I/O, database access (Room), or network requests on the main thread. Always wrap repository executions in `withContext(Dispatchers.IO)`.
- **StrictMode in Debug:** Mandate `StrictMode.ThreadPolicy` and `StrictMode.VmPolicy` in debug builds to catch accidental UI thread penalties early.
- **Application Initialization:** Custom `Application.onCreate()` must only initialize critical dependencies. Third-party SDKs must be lazy-loaded or initialized asynchronously via Jetpack App Startup.

## 2. Kotlin Coroutines & Crash Safety
- **Root Coroutine Supervision:** Any coroutine launched via `viewModelScope.launch` or custom scopes must have a `CoroutineExceptionHandler` or top-level `try-catch` to avoid uncaught exceptions terminating the process.
- **Null Safety Idioms:** Ban arbitrary `!!` non-null assertion operators. Enforce safe calls `?.`, Elvis operators `?:`, and explicit error-state emissions.
- **Type-Safe Navigation:** Ensure navigation route arguments are serialized using safe type plugins rather than fragile bundle casting.

## 3. Jetpack Compose Lifecycle & Memory Leaks
- **Effect Cleanup:** Any listener, broadcast receiver, or sensor registered in a Composable must be scoped within `DisposableEffect` with clean deregistration in `onDispose`.
- **Context Retention:** Ban storing `Activity` or `Context` inside `remember { ... }` or companion objects. Use `LocalContext.current.applicationContext` only when required by low-level APIs.
- **LeakCanary Standard:** Ensure `com.squareup.leakcanary:leakcanary-android` is configured in `debugImplementation` to alert on retained destroyed Activity/Fragment instances.

## 4. Recomposition & Rendering Performance
- **Parameter Stability:** Check Compose Compiler Metrics. Any data class passed to Composable parameters containing standard `List<T>` must be made stable (e.g., using `@Immutable` or `ImmutableList`).
- **Calculation Offloading:** No complex sorting or list filtering inside `@Composable` functions without `remember(key) { ... }` or offloading to StateFlow in ViewModel.
- **Baseline Profiles:** Verify project bundles baseline profiles to eliminate JIT compilation stutter during cold start and scrolling.
