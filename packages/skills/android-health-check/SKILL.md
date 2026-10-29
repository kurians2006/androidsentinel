---
name: android-health-check
description: >-
  Standardized technical investigation procedure for Android apps (Kotlin/Jetpack Compose).
  Use to audit ANRs, crashes, Coroutine scope errors, memory leaks, and Compose recomposition overhead.
---

# Android App Health Check Diagnostic Workflow

This skill guides AndroidSentinel through executing an introductory or retainer-level Android App Health Check.

## Step 1: Scope Definition & Ingestion
1. Define the target scope:
   - Target journey (e.g. Cold start, Media playback, Endless scroll, Background sync).
   - Problem statement (ANR dialogs, OOM kills, dropped frames, crash spikes).
2. Gather inputs:
   - Google Play Console / Firebase Crashlytics stack traces.
   - LeakCanary heap analysis dumps.
   - Target Kotlin files (Composables, ViewModels, Repositories).

## Step 2: 4-Pillar Technical Audit

### Pillar A: ANR Prevention & Threading
- Verify `withContext(Dispatchers.IO)` is used on all disk, Room, and Retrofit network calls.
- Inspect `Application.onCreate()` for heavy blocking SDK initializations.
- Review StrictMode logs for main thread disk/network I/O.

### Pillar B: Crash Vectors & Coroutine Exception Handling
- Verify `CoroutineExceptionHandler` attached to top-level `viewModelScope.launch`.
- Eliminate non-null assertion `!!` operators.
- Audit type safety in Jetpack Navigation arguments and Parcelable classes.

### Pillar C: Memory Leaks & Lifecycle Integrity
- Inspect Composable callbacks for missing `DisposableEffect(onDispose = {})`.
- Verify ViewModels do not retain `Activity` or UI `Context` references.
- Check singleton listeners for unregistration on lifecycle `ON_DESTROY`.

### Pillar D: Compose Recomposition & Jank
- Run Compose Compiler Metrics to detect unstable data classes.
- Audit heavy computations inside `@Composable` functions.
- Verify `LazyColumn` / `LazyRow` have stable item keys.

## Step 3: Synthesis & Fix Formulation
Assign P0 (ANRs, unhandled crashes), P1 (Memory leaks, UI jank), and P2 (anti-patterns).
Provide verified Kotlin/Compose code changes and Android Studio Profiler verification instructions.

## Step 4: Deliverable Generation
Invoke `sentinel-report-generator` to compile the report.
