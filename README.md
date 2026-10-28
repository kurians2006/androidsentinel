# AndroidSentinel 🛡️

> **The Universal Open-Source AI Agent Suite for Android, Kotlin & Java Development, Security Auditing, and PR Review.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Kotlin: 2.0+](https://img.shields.io/badge/Kotlin-2.0%2B-purple.svg)](https://kotlinlang.org)
[![Java: 17%2B | 21+](https://img.shields.io/badge/Java-17%2B%20%7C%2021%2B-orange.svg)](https://openjdk.org)
[![Android: Jetpack Compose](https://img.shields.io/badge/Android-Jetpack%20Compose-green.svg)](https://developer.android.com/jetpack/compose)
[![Compatible With: Claude Code | Cursor | VS Code | Codex | Antigravity](https://img.shields.io/badge/Compatible%20With-Claude%20%7C%20Cursor%20%7C%20VS%20Code%20%7C%20Codex%20%7C%20Antigravity-blue.svg)](#-one-line-universal-installation)

Generic LLMs struggle with the "Android Problem": suggesting deprecated `AsyncTask` or RxJava anti-patterns, leaking `Activity`/`Context` references in Coroutines, triggering Jetpack Compose recomposition storms, storing plaintext credentials in `SharedPreferences`, and overlooking Android-specific security vulnerabilities (insecure exported components, cleartext HTTP, and biometric bypasses).

**AndroidSentinel** solves this by providing curated, opinionated rules, specialized skills, and autonomous review agents built specifically for modern Android platform engineering across **any AI coding assistant**.

---

## ⚡ One-Line Universal Installation

Arm any Android workspace in seconds:

### Option A: Universal Shell Installer (Recommended)
Installs configuration for **Claude Code, Cursor, VS Code Copilot, Windsurf, Codex, and Antigravity** in one shot:
```bash
curl -fsSL https://raw.githubusercontent.com/kurians2006/androidsentinel/main/install.sh | bash
```

### Option B: Agent Skills Catalog (`npx skills`)
```bash
npx skills add kurians2006/androidsentinel --all
```

---

## 💻 Platform Compatibility Matrix

| AI Assistant / IDE | How AndroidSentinel Integrates | Target Configuration |
| :--- | :--- | :--- |
| **Claude Code** (CLI) | Read automatically at root | `CLAUDE.md` & `skills.json` |
| **Claude (VS Code)** | Claude extension reads project instructions | `CLAUDE.md` |
| **Cursor** | Reads modern MDC & legacy rules | `.cursor/rules/*.mdc` & `.cursorrules` |
| **OpenAI Codex & Open Agents** | Universal open agent specification | `AGENTS.md` |
| **VS Code / GitHub Copilot** | Copilot project instructions | `.github/copilot-instructions.md` |
| **Windsurf (Cascade)** | Windsurf rules manifest | `.windsurfrules` |
| **Google Antigravity** | Native subagents and skills | `.gemini/skills/` & `.gemini/agents/` |
| **GitHub Actions / CI** | Automated PR review bot | `packages/github-action/action.yml` |

---

## 🌟 Key Capabilities

* **Kotlin Coroutines & Flow**: Structured concurrency (`viewModelScope`), `StateFlow` vs `SharedFlow`, cooperative cancellation (`ensureActive()`), and zero `GlobalScope` leaks.
* **Jetpack Compose Performance**: Eliminates recomposition loops, enforces `@Stable` and `@Immutable` contracts, ensures lazy layout keys, and hoists state cleanly.
* **Android Security (OWASP MASVS)**: Enforces `EncryptedSharedPreferences` / Android KeyStore, flags cleartext traffic, audits `AndroidManifest.xml` exported components, and binds biometrics with `BiometricPrompt.CryptoObject`.
* **Architectures & SOLID**: Clean Architecture (Domain UseCases, Repositories), MVVM & MVI patterns, and dependency injection (Hilt / Koin).
* **Modern Android Testing**: Test suites with JUnit 5, Kotest/AssertK, MockK, `StandardTestDispatcher`, `runTest`, and Compose UI testing.
* **External PR & Repo Review**: CLI superpowers to review any external GitHub PR, GitLab MR, or remote Android repository.

---

## 📁 Repository Structure

```text
androidsentinel/
├── install.sh                   # Universal one-line installer script
├── CLAUDE.md                    # Claude Code & Claude VS Code manifest
├── AGENTS.md                    # OpenAI Codex & general agents manifest
├── .windsurfrules               # Windsurf Cascade configuration
├── skills.json                  # Agent Skills catalog registry manifest
├── package.json                 # Node/npx metadata & test scripts
├── .github/
│   └── copilot-instructions.md  # VS Code & GitHub Copilot instructions
├── .cursor/
│   └── rules/                   # Modern Cursor MDC rules
│       ├── kotlin-coroutines.mdc
│       ├── compose-performance.mdc
│       ├── android-security.mdc
│       └── android-architectures-solid.mdc
├── packages/
│   ├── rules/                   # Portable rules documentation
│   ├── skills/                  # SKILL.md specs (Antigravity & Agent Skills)
│   ├── agents/                  # Subagent personas (Reviewer, Auditor, Architect)
│   └── github-action/           # Automated PR review bot for CI/CD
└── examples/
    ├── .cursorrules             # Legacy Cursor configuration
    └── sample-android-app/      # Reference implementation (Clean Architecture, MVVM, Compose)
```

---

## ⚡ AndroidSentinel Special Superpowers

Beyond auditing local files, AndroidSentinel can review **external repositories, other people's PRs/MRs, and foreign codebases**:

```bash
# Review ANY external GitHub Pull Request or GitLab Merge Request URL
androidsentinel pr https://github.com/google/iosched/pull/123

# Audit an entire remote repository or local Android app
androidsentinel repo ./MyAndroidApp

# Deep OWASP MASVS security & tamper scan
androidsentinel security ./app/src/main

# Audit SOLID, MVVM, MVI & Clean Architecture boundaries
androidsentinel arch ./app/src/main

# Run Jetpack Compose recomposition hygiene scan
androidsentinel compose ./app/src/main/ui
```

---

## 🤝 Contributing

We welcome contributions! Please read our [CONTRIBUTING.md](CONTRIBUTING.md) to learn how to add new rules, improve security heuristics, or extend support to new platforms.

## 📄 License

This project is open-source under the [MIT License](LICENSE).
