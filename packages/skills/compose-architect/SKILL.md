---
name: compose-architect
description: Guides the design, implementation, and refactoring of modern Jetpack Compose architectures, MVI/MVVM, state management, and Clean Architecture in Android.
---

# Jetpack Compose Architecture Specialist

This skill guides the scaffolding and refactoring of maintainable, high-performance Jetpack Compose applications.

## Key Architecture Principles

1. **Unidirectional Data Flow (UDF)**:
   - State flows down from ViewModel to Composables as immutable data classes.
   - Events/Intents flow up from Composables to ViewModel via lambda callbacks.

2. **State Hoisting**:
   - Keep low-level UI components stateless by hoisting state to the screen-level container.
   - Use `derivedStateOf` for calculations dependent on frequently changing state (e.g. scroll offset).

3. **Clean Architecture Separation**:
   - Compose screens consume `StateFlow` from a `@HiltViewModel`.
   - The ViewModel invokes single-responsibility `UseCase` classes.
   - UseCases query repository interfaces; data sources handle Room and Retrofit.

4. **Testing Architecture**:
   - Test UI components in isolation with `createComposeRule()`.
   - Test ViewModels using `runTest` and `StandardTestDispatcher`.
