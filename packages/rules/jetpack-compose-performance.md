# Jetpack Compose Performance & State Hygiene Rules

This guide outlines performance and architectural standards for modern Jetpack Compose development.

---

## 1. Avoid Side-Effects in Composable Bodies

### Rule: NEVER perform network calls, database queries, or mutations inside Composable bodies
* **Why**: The Compose runtime can re-execute a `@Composable` function multiple times per frame during animations or scrolling. Side-effects in the body trigger infinite loops or severe stutter.
* **Bad**:
  ```kotlin
  @Composable
  fun UserScreen(viewModel: UserViewModel) {
      // ❌ Side-effect directly in the composable body executes on every recomposition!
      viewModel.fetchUserData()
      
      UserList(viewModel.users)
  }
  ```
* **Good**:
  ```kotlin
  @Composable
  fun UserScreen(viewModel: UserViewModel, userId: String) {
      // ✅ Tied to lifecycle and key identity
      LaunchedEffect(userId) {
          viewModel.fetchUserData(userId)
      }
      
      val uiState by viewModel.uiState.collectAsStateWithLifecycle()
      UserList(uiState.users)
  }
  ```

---

## 2. Recomposition Optimization & Stability

### Rule: Mark external or unannotated data classes with `@Immutable` or `@Stable`
* **Why**: Compose skips recomposing a Composable only if all its parameters are stable. Standard Kotlin `List<T>` is considered unstable by default because it is an interface that could be a `MutableList` under the hood.
* **Best Practice**:
  * Use immutable collections (`kotlinx.collections.immutable.ImmutableList<T>`) or wrap collections in an `@Immutable` data class:
  ```kotlin
  @Immutable
  data class UserUiState(
      val users: ImmutableList<UserItem> = persistentListOf(),
      val isLoading: Boolean = false
  )
  ```

---

## 3. LazyLayout Keying

### Rule: Always provide explicit, stable keys in `LazyColumn` / `LazyRow`
* **Why**: Without keys, item insertions or reorders cause Compose to discard and recreate the entire layout tree instead of animating and reusing view instances.
* **Bad**:
  ```kotlin
  // ❌ Inefficient re-rendering on item list changes
  LazyColumn {
      items(userList) { user -> UserRow(user) }
  }
  ```
* **Good**:
  ```kotlin
  // ✅ Preserves scroll position and optimizes view reuse
  LazyColumn {
      items(items = userList, key = { user -> user.id }) { user ->
          UserRow(user)
      }
  }
  ```

---

## 4. `derivedStateOf` for Rapidly Changing State

### Rule: Wrap scroll position or high-frequency calculations in `derivedStateOf`
* **Why**: Reduces recompositions by only notifying observers when the computed boolean/value actually flips.
* **Good**:
  ```kotlin
  val listState = rememberLazyListState()
  // ✅ Only recomposes when the button's visibility actually changes
  val showScrollToTop by remember {
      derivedStateOf { listState.firstVisibleItemIndex > 5 }
  }
  ```
