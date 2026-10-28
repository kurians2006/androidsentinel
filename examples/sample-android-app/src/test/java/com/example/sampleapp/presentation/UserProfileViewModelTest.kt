package com.example.sampleapp.presentation

import com.example.sampleapp.domain.GetUserProfileUseCase
import com.example.sampleapp.domain.User
import com.example.sampleapp.domain.UserReadableRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.*
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

// Fake repository for hermetic testing
class FakeUserRepository : UserReadableRepository {
    var stubbedUser: User? = null
    var shouldFail: Boolean = false

    override suspend fun getUser(id: String): User {
        if (shouldFail || stubbedUser == null) {
            throw NoSuchElementException("User not found")
        }
        return stubbedUser!!
    }
}

@OptIn(ExperimentalCoroutinesApi::class)
class UserProfileViewModelTest {

    private val testDispatcher = StandardTestDispatcher()
    private lateinit var fakeRepository: FakeUserRepository
    private lateinit var useCase: GetUserProfileUseCase
    private lateinit var viewModel: UserProfileViewModel

    @BeforeEach
    fun setUp() {
        Dispatchers.setMain(testDispatcher)
        fakeRepository = FakeUserRepository()
        useCase = GetUserProfileUseCase(fakeRepository)
        viewModel = UserProfileViewModel(useCase)
    }

    @AfterEach
    fun tearDown() {
        Dispatchers.resetMain()
    }

    @Test
    fun `loadUserProfile sets user on success`() = runTest(testDispatcher) {
        val expected = User(id = "usr_1", name = "Naeem", email = "naeem@example.com", isVerified = true)
        fakeRepository.stubbedUser = expected

        viewModel.loadUserProfile("usr_1")
        testScheduler.advanceUntilIdle()

        val state = viewModel.uiState.value
        assertEquals("Naeem", state.user?.name)
        assertFalse(state.isLoading)
        assertNull(state.errorMessage)
    }

    @Test
    fun `loadUserProfile sets error on failure`() = runTest(testDispatcher) {
        fakeRepository.shouldFail = true

        viewModel.loadUserProfile("usr_999")
        testScheduler.advanceUntilIdle()

        val state = viewModel.uiState.value
        assertNull(state.user)
        assertFalse(state.isLoading)
        assertNotNull(state.errorMessage)
    }
}
