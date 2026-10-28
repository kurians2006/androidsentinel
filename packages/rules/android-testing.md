# Modern Android Testing Rules

This guide outlines standards for writing unit, integration, and UI tests using **JUnit 5**, **Kotlin Coroutines Test (`runTest`)**, **MockK**, and **Compose UI Testing**.

---

## 1. Coroutine Testing with `runTest`

### Rule: Always use `runTest` and `StandardTestDispatcher`
* **Why**: `runTest` automatically advances virtual time, executes pending coroutines, and skips unnecessary delays.
* **Bad**:
  ```kotlin
  // ❌ Blocks real wall-clock time and is flaky
  @Test
  fun testViewModel() = runBlocking {
      viewModel.fetchData()
      delay(2000)
      assertEquals("Success", viewModel.state.value)
  }
  ```
* **Good**:
  ```kotlin
  @OptIn(ExperimentalCoroutinesApi::class)
  class UserProfileViewModelTest {
      @get:Rule
      val mainDispatcherRule = MainDispatcherRule()

      @Test
      fun `loads user successfully and updates state`() = runTest {
          val fakeUseCase = FakeGetUserProfileUseCase()
          val viewModel = UserProfileViewModel(fakeUseCase)

          viewModel.loadUser("usr_123")

          assertEquals("Naeem", viewModel.uiState.value.user?.name)
          assertFalse(viewModel.uiState.value.isLoading)
      }
  }
  ```

---

## 2. Mocking Discipline with MockK

### Rule: Prefer Fakes over Mocks for Domain Repositories; use MockK for external boundaries
* **Why**: Fakes provide deterministic behavior, survive refactoring, and avoid brittle mock setups.
* **Good MockK Usage**:
  ```kotlin
  val api = mockk<UserApiService>()
  coEvery { api.getUser("123") } returns NetworkUserResponse(name = "Paracha")
  ```

---

## 3. Jetpack Compose UI Testing

### Rule: Test user flows using semantic matchers
* **Good**:
  ```kotlin
  @get:Rule
  val composeTestRule = createComposeRule()

  @Test
  fun clickingSubmit_triggersLoadingIndicator() {
      composeTestRule.setContent {
          UserProfileScreen(uiState = UserUiState(isLoading = true))
      }

      composeTestRule.onNodeWithText("Loading Profile...").assertIsDisplayed()
  }
  ```
