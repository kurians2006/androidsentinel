package com.example.sampleapp.domain

/**
 * Clean Architecture UseCase enforcing Single Responsibility Principle (SRP).
 */
class GetUserProfileUseCase(
    private val repository: UserReadableRepository
) {
    suspend operator fun invoke(userId: String): Result<User> {
        val trimmed = userId.trim()
        if (trimmed.isEmpty()) {
            return Result.failure(IllegalArgumentException("User ID cannot be empty"))
        }
        return runCatching {
            repository.getUser(trimmed)
        }
    }
}
