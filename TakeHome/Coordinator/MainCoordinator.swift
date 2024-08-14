//
//  MainCoordinator.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-09.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repository = FirebaseBirdRepository()
        let fetchBirdsUseCase = FetchBirdsUseCase(repository: repository)
        let viewModel = BirdsViewModel(fetchBirdsUseCase: fetchBirdsUseCase)
        let mainViewController = MainViewController()
        mainViewController.viewModel = viewModel
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func presentBirdDetailSheet(for bird: Bird) {
        let repository = NoteRepositoryImpl()
        let useCase = AddNoteUseCaseImpl(repository: repository)
        let viewModel = NoteViewModel(addNoteUseCase: useCase)
        viewModel.birsSelected = bird
        let detailViewController = BirdDetailViewController(bird: bird, viewModel: viewModel)
        detailViewController.viewModel = viewModel
        detailViewController.modalPresentationStyle = .pageSheet
        navigationController.present(detailViewController, animated: true, completion: nil)
    }
}
