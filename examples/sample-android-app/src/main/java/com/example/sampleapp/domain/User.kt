package com.example.sampleapp.domain

/**
 * Clean Architecture Domain Entity.
 * Pure Kotlin data class with zero Android framework dependencies.
 */
data class User(
    val id: String,
    val name: String,
    val email: String,
    val isVerified: Boolean
)
