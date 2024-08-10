//
//  BirdsViewModelTest.swift
//  TakeHomeTests
//
//  Created by Josue Hernandez on 2024-08-10.
//

import XCTest
import Combine
@testable import TakeHome

final class BirdsViewModelTests: XCTestCase {

    var viewModel: BirdsViewModel!
    var mockFetchBirdsUseCase: MockFetchBirdsUseCase!
    var mockBirdRepository: MockBirdRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockBirdRepository = MockBirdRepository()
        mockFetchBirdsUseCase = MockFetchBirdsUseCase(repository: mockBirdRepository)
        viewModel = BirdsViewModel(fetchBirdsUseCase: mockFetchBirdsUseCase)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockFetchBirdsUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadBirdsSuccess() {
        // Arrange
        let expectedBirds = [
            Bird(id: "1", nameSpanish: "Halcón", nameEnglish: "Falcon", nameLatin: "Falco", thumbImageUrl: "", fullImageUrl: "", sortIndex: 1),
            Bird(id: "2", nameSpanish: "Águila", nameEnglish: "Eagle", nameLatin: "Aquila", thumbImageUrl: "", fullImageUrl: "", sortIndex: 2)
        ]
        mockFetchBirdsUseCase.result = .success(expectedBirds)

        let expectation = XCTestExpectation(description: "Birds should be loaded successfully")

        // Act
        viewModel.$birds
            .dropFirst()  // Ignore the initial empty value
            .sink { birds in
                // Assert
                XCTAssertNotNil(birds)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadBirds()

        wait(for: [expectation], timeout: 1.0)
    }
}

// Mock FetchBirdsUseCase

class MockFetchBirdsUseCase: FetchBirdsUseCase {
    var result: Result<[Bird], Error>!

    override func execute(completion: @escaping (Result<[Bird], Error>) -> Void) {
        completion(result)
    }
}

// Mock Repository

class MockBirdRepository: BirdRepository {
    func fetchBirds(completion: @escaping (Result<[Bird], Error>) -> Void) {
        // This method would be stubbed or mocked in tests
    }
}

