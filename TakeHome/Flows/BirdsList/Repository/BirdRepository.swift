//
//  BirdRepository.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-09.
//

protocol BirdRepository {
    func fetchBirds(completion: @escaping (Result<[Bird], Error>) -> Void)
}
