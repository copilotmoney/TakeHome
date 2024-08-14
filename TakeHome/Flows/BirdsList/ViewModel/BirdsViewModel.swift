//
//  BirdsViewModel.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-09.
//

import Combine
import Foundation

class BirdsViewModel: ObservableObject {
    @Published var birds: [Bird] = []
    @Published var error: String?

    private let fetchBirdsUseCase: FetchBirdsUseCase

    init(fetchBirdsUseCase: FetchBirdsUseCase) {
        self.fetchBirdsUseCase = fetchBirdsUseCase
    }

    func loadBirds() {
        fetchBirdsUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let birds):
                    self?.birds = birds
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            }
        }
    }
}
