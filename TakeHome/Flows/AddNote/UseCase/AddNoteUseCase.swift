//
//  AddNoteUseCase.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-13.
//

import Foundation

protocol AddNoteUseCase {
    func execute(birdID: String, note: Note, completion: @escaping (Result<Void, Error>) -> Void)
}

class AddNoteUseCaseImpl: AddNoteUseCase {
    private let repository: NoteRepository
    
    init(repository: NoteRepository) {
        self.repository = repository
    }
    
    func execute(birdID: String, note: Note, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.addNoteToBird(birdID: birdID, note: note, completion: completion)
        
    }
}
