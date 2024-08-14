//
//  FetchBirdsUseCase.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-09.
//

class FetchBirdsUseCase {
    private let repository: BirdRepository

    init(repository: BirdRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[Bird], Error>) -> Void) {
        repository.fetchBirds(completion: completion)
    }
}
