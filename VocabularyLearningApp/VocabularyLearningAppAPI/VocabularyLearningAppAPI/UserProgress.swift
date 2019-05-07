//
//  SaveUserProgress.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

public protocol UserProgressProtocol
{
    func saveProgress(userID: String, day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    func saveTestedProgress(userID: String, askDay: String, level: String, word: String, translate: String, sentence: String, category: String, id: String)
    func saveLearnedWord(userID: String, day: String, uid: String)
}

public class UserProgress: UserProgressProtocol
{
    // Kullanıcının ilerlemesini kaydeder. Günlük çözülen kelimeler ve test verileri.
    var dbRef: DatabaseReference!
    public init() { }
    
    public func saveProgress(userID: String, day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    {
        dbRef = Database.database().reference().child("UserData").child(userID).child("LearnedWords").child(String(describing: day))
        dbRef.setValue(["Correct": correctData, "Wrong": wrongData]) { (errorDB, DBRef) in
            if errorDB != nil
            {
                print("FireBase Save Error")
            }
        }
        dbRef.child("SolvedWords").setValue(solvedWords)
    }
    public func saveTestedProgress(userID: String, askDay: String, level: String, word: String, translate: String, sentence: String, category: String, id: String)
    {
        dbRef = Database.database().reference().child("UserData").child(userID).child("TestableWords").child(String(describing: askDay)).child(id)
        dbRef.setValue(["word": word, "translate": translate, "sentence": sentence, "category": category, "uid": id, "level": level]) { (errorDB, DBRef) in
            if errorDB != nil
            {
                print("FireBase Save Error")
            }
        }
    }
    public func saveLearnedWord(userID: String, day: String, uid: String)
    {
        dbRef = Database.database().reference().child("UserData").child(userID).child("Completed").child(day)
        dbRef.setValue(["word": uid]) { (errorDB, DBRef) in
            if errorDB != nil
            {
                print("FireBase Save Error")
            }
        }
    }
}
