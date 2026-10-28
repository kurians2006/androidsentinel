# Kotlin Coroutines & Structured Concurrency Rules

This guide establishes standards for asynchronous programming and structured concurrency in Kotlin and Android.

---

## 1. Structured Concurrency & Scopes

### Rule: NEVER use `GlobalScope`; tie tasks to lifecycle scopes
* **Why**: `GlobalScope` creates unmanaged daemon coroutines that outlive Activities and ViewModels, causing severe memory leaks and background CPU drain.
* **Bad**:
  ```kotlin
  // ❌ Unmanaged coroutine leaks if user leaves the screen
  class UserProfileViewModel : ViewModel() {
      fun fetchProfile() {
          GlobalScope.launch {
              val profile = api.getProfile()
              _state.value = profile
          }
      }
  }
  ```
* **Good**:
  ```kotlin
  // ✅ Automatically cancelled when ViewModel clears
  class UserProfileViewModel : ViewModel() {
      fun fetchProfile() {
          viewModelScope.launch {
              val profile = api.getProfile()
              _state.value = profile
          }
      }
  }
  ```

---

## 2. Dispatcher Discipline

### Rule: Dispatchers must match operation types; use `withContext` inside suspending functions
* **Rules**:
  * `Dispatchers.IO`: Disk reads/writes, Network calls, Database queries (Room/SQLite).
  * `Dispatchers.Default`: CPU-intensive computations (JSON parsing, image processing, complex filtering).
  * `Dispatchers.Main.immediate`: Fast UI updates without waiting for the next event loop frame.
* **Good**:
  ```kotlin
  class UserRepositoryImpl(
      private val localDb: UserDao,
      private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
  ) : UserRepository {
      override suspend fun getUser(id: String): User = withContext(ioDispatcher) {
          localDb.findById(id)
      }
  }
  ```

---

## 3. Cooperative Cancellation

### Rule: Long-running loops or tasks MUST check for cancellation
* **Why**: Coroutine cancellation is cooperative. A loop that does not call a suspending function will ignore cancellation unless `ensureActive()` or `yield()` is checked.
* **Bad**:
  ```kotlin
  // ❌ Continues running even after cancellation
  suspend fun processLargeFile(lines: List<String>) {
      for (line in lines) {
          heavyCpuWork(line)
      }
  }
  ```
* **Good**:
  ```kotlin
  // ✅ Respects cooperative cancellation
  suspend fun processLargeFile(lines: List<String>) {
      for (line in lines) {
          coroutineContext.ensureActive()
          heavyCpuWork(line)
      }
  }
  ```

---

## 4. `StateFlow` vs `SharedFlow` vs `LiveData`

### Rule: Prefer `StateFlow` for UI state, `SharedFlow` for one-time events
* **Why**: `StateFlow` is replay-1, conflated, thread-safe, and integrates natively with Compose `collectAsStateWithLifecycle()`.
* **StateFlow**: Represents persistent screen state (e.g. `Loading`, `Content`, `Error`).
* **SharedFlow**: Represents one-time side-effects (e.g. `ShowSnackbar`, `NavigateToDetails`) with `extraBufferCapacity = 1`.
