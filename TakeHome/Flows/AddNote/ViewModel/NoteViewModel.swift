//
//  NoteViewModel.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-13.
//

import Foundation

import Combine
import Foundation

class NoteViewModel: ObservableObject {
    @Published var birsSelected: Bird?
    @Published var error: String?
    
    private let addNoteUseCase: AddNoteUseCase
    private var currentBirdID: String? // Add this to store the current bird ID

    init(addNoteUseCase: AddNoteUseCase) {
        self.addNoteUseCase = addNoteUseCase
    }

    func addNote(content: String, userID: String, birdSelected: Bird?) {
        guard let bird = birdSelected else { return }
        
        let timestamp = Date().timeIntervalSince1970
        let newNote = Note(userID: userID, content: content, timestamp: timestamp)
        
        addNoteUseCase.execute(birdID: bird.id, note: newNote) { [weak self] result in
            switch result {
            case .success:
                print("Success")
                self?.birsSelected?.notes?.insert(newNote, at: 0) // Insert at the top (most recent)
            case .failure(let error):
                self?.error = error.localizedDescription
                print("Error adding note: \(error)")
            }
        }
    }
}
