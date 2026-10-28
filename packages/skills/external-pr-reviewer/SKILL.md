---
name: external-pr-reviewer
description: Reviews external GitHub Pull Requests (PRs), GitLab Merge Requests (MRs), and remote Git repositories for Android, Kotlin, and Java projects.
---

# External PR & Repository Reviewer for Android

This skill enables reviewing any external or third-party pull request, merge request, or remote repository for Android apps.

## Workflow

### 1. Fetch Diff
- Fetch the PR diff using GitHub API or standard `.diff` format:
  ```bash
  curl -sSL "https://github.com/{owner}/{repo}/pull/{prNumber}.diff"
  ```

### 2. Multi-Pass Audit
1. **Kotlin & Coroutines**: Scope leaks (`GlobalScope`), missing cancellation, dispatcher mismatches.
2. **Jetpack Compose**: Side-effects in bodies, missing `items()` keys, unstable collection parameters.
3. **Android Security**: `AndroidManifest.xml` exported components, `EncryptedSharedPreferences`, cleartext traffic.
4. **Architecture & SOLID**: Dependency Inversion, UseCase decoupling, Repository abstractions.

### 3. Generate High-Impact Review Report
Categorize findings into `🚨 Critical`, `⚠️ Warning`, and `💡 Optimization` with a final verdict (`APPROVE`, `REQUEST_CHANGES`, or `COMMENT`).
