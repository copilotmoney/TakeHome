//
//  NoteRepository.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-13.
//

import Foundation
import Firebase

protocol NoteRepository {
    func addNoteToBird(birdID: String, note: Note, completion: @escaping (Result<Void, Error>) -> Void)
}

class NoteRepositoryImpl: NoteRepository {
    private let firestore = Firestore.firestore()
    
    func addNoteToBird(birdID: String, note: Note, completion: @escaping (Result<Void, Error>) -> Void) {
        let birdDocRef = firestore.collection("birds").document(birdID)
        
        // Convert the note to a dictionary format that Firestore can accept
        let noteData: [String: Any] = [
            "user_id": note.userID,
            "content": note.content,
            "timestamp": note.timestamp
        ]
        
        birdDocRef.updateData([
            "notes": FieldValue.arrayUnion([noteData])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}
