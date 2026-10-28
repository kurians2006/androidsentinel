# Android Architectures & SOLID Principles Guide

This guide establishes standards and evaluation criteria for **SOLID Principles**, **MVVM**, **MVI**, and **Clean Architecture** in Android, Kotlin, and Java codebases.

---

## 1. SOLID Principles in Android

### S — Single Responsibility Principle (SRP)
* **Anti-Pattern**: A `Fragment` or `ViewModel` that handles UI, parses JSON, calls Retrofit directly, and formats dates.
* **Best Practice**: Separate into presentation (`Compose`/`Fragment`), state holder (`ViewModel`), domain (`UseCase`), and data coordination (`Repository`).

### O — Open/Closed Principle (OCP)
* Use interfaces and abstract base classes for extensible behaviors (e.g., `AnalyticsTracker` implementations: Firebase, Mixpanel, Datadog).

### L — Liskov Substitution Principle (LSP)
* Subclasses or mock implementations must be fully substitutable for their interfaces without unexpected runtime crashes.

### I — Interface Segregation Principle (ISP)
* Split monolithic interfaces into granular, role-focused contracts:
  ```kotlin
  interface UserProfileReader {
      suspend fun getProfile(id: String): UserProfile
  }

  interface UserProfileWriter {
      suspend fun updateProfile(profile: UserProfile)
  }
  ```

### D — Dependency Inversion Principle (DIP)
* High-level ViewModels must depend on abstractions (interfaces), never concrete implementations or singletons.
* **Anti-Pattern**: Calling `AppDatabase.getInstance()` or `RetrofitClient.instance` directly.
* **Best Practice**: Inject dependencies using **Hilt** (`@Inject constructor(...)` or Koin).

---

## 2. Modern Android Architectural Patterns

### Pattern A: Clean Architecture with MVVM
```text
[Compose UI] ──► [ViewModel] ──► [UseCase] ──► [Repository Interface]
                                                      ▲
                                                      │ implements
                                            [Repository Implementation]
                                                      │
                                           ┌──────────┴──────────┐
                                           ▼                     ▼
                                    [Local Database]     [Remote API Service]
```

1. **Domain Layer**:
   * **Entities**: Pure Kotlin data classes without Android framework dependencies.
   * **UseCases (Interactors)**: Single-purpose business rules (e.g. `GetUserProfileUseCase`).
   * **Repository Interfaces**: Abstract data contracts.
2. **Data Layer**:
   * **Repository Impl**: Coordinates local cache (Room) and remote APIs (Retrofit/Ktor).
   * **DataSources**: Network endpoints and local DAO abstractions.
3. **Presentation Layer**:
   * **Compose Screen**: Observes `StateFlow` from the ViewModel and renders stateless UI.
   * **ViewModel**: Handles user intents, delegates to UseCases, and publishes immutable UI state.

### Pattern B: MVI (Model-View-Intent)
* **Model**: Represents a single immutable UI state object (`ScreenState`).
* **View**: Pure Composable function rendering the `ScreenState`.
* **Intent**: User actions encapsulated in sealed interfaces (`sealed interface UserIntent { object Refresh : UserIntent ... }`).
