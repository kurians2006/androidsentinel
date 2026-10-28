package com.example.sampleapp.domain

/**
 * Interface Segregation (ISP) and Dependency Inversion (DIP) contracts.
 */
interface UserReadableRepository {
    suspend fun getUser(id: String): User
}

interface UserWritableRepository {
    suspend fun saveUser(user: User)
}
