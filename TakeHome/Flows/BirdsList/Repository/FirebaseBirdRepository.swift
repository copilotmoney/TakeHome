//
//  FirebaseBirdRepository.swift
//  TakeHome
//
//  Created by Josue Hernandez on 2024-08-09.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseBirdRepository: BirdRepository {
    private let firestore = Firestore.firestore()
    
    func fetchBirds(completion: @escaping (Result<[Bird], Error>) -> Void) {
        // First, sign in anonymously
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            if let error = error {
                // Handle sign-in error
                print("Anonymous sign-in error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            // Sign-in succeeded, proceed to fetch the birds data
            self?.fetchBirdsData(completion: completion)
        }
    }
    
    private func fetchBirdsData(completion: @escaping (Result<[Bird], Error>) -> Void) {
        firestore.collection("birds").order(by: "sort").getDocuments { (snapshot, error) in
            if let error = error {
                // Log the error to check if it's a permissions issue
                print("Firestore error: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let birds = snapshot.documents.compactMap { document -> Bird? in
                    let data = document.data()
                    guard let uid = data["uid"] as? String,
                          let name = data["name"] as? [String: String],
                          let nameSpanish = name["spanish"],
                          let nameEnglish = name["english"],
                          let nameLatin = name["latin"],
                          let images = data["images"] as? [String: String],
                          let thumbImageUrl = images["thumb"],
                          let fullImageUrl = images["full"],
                          let sortIndex = data["sort"] as? Int else {
                        return nil
                    }
                    
                    // Handle the notes field, defaulting to an empty array if it's nil
                    let notesData = data["notes"] as? [[String: Any]] ?? []
                    
                    let notes = notesData.compactMap { noteData -> Note? in
                        guard let userID = noteData["user_id"] as? String,
                              let content = noteData["content"] as? String,
                              let timestamp = noteData["timestamp"] as? TimeInterval else {
                            return nil
                        }
                        return Note(userID: userID, content: content, timestamp: timestamp)
                    }
                    
                    return Bird(id: uid,
                                nameSpanish: nameSpanish,
                                nameEnglish: nameEnglish,
                                nameLatin: nameLatin,
                                thumbImageUrl: thumbImageUrl,
                                fullImageUrl: fullImageUrl,
                                sortIndex: sortIndex,
                                notes: notes)
                }
                completion(.success(birds))
            }
        }
    }
    
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
