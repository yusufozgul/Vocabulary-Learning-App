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
    func saveLearnedWord(userID: String, day: String, uid: [String])
}

public class UserProgress: UserProgressProtocol
{
    // Kullanıcının ilerlemesini kaydeder. Günlük çözülen kelimeler ve test verileri.
    var dbRef: DatabaseReference!
    public init() { }
    
    public func saveProgress(userID: String, day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    {
        dbRef = Database.database().reference().child(FirebaseChilds.UserData.rawValue).child(userID).child(FirebaseChilds.LearnedWords.rawValue).child(String(describing: day))
        dbRef.setValue([FirebaseChilds.Correct.rawValue: correctData, FirebaseChilds.Wrong.rawValue: wrongData]) { (errorDB, DBRef) in
            if errorDB != nil
            {
                print("FireBase Save Error")
            }
        }
        dbRef.child(FirebaseChilds.SolvedWords.rawValue).setValue(solvedWords)
    }
    public func saveTestedProgress(userID: String, askDay: String, level: String, word: String, translate: String, sentence: String, category: String, id: String)
    {
        dbRef = Database.database().reference().child(FirebaseChilds.UserData.rawValue).child(userID).child(FirebaseChilds.TestableWords.rawValue).child(String(describing: askDay)).child(id)
        dbRef.setValue([FirebaseChilds.word.rawValue: word, FirebaseChilds.translate.rawValue: translate, FirebaseChilds.sentence.rawValue: sentence, FirebaseChilds.category.rawValue: category, FirebaseChilds.uid.rawValue: id, FirebaseChilds.level.rawValue: level]) { (errorDB, DBRef) in
            if errorDB != nil
            {
                print("FireBase Save Error")
            }
        }
    }
    public func saveLearnedWord(userID: String, day: String, uid: [String])
    {
        dbRef = Database.database().reference().child(FirebaseChilds.UserData.rawValue).child(userID).child(FirebaseChilds.Completed.rawValue).child(day)
        dbRef.setValue(uid) { (errorDB, DBRef) in
            if errorDB != nil
            {
                print("FireBase Save Error")
            }
        }
    }
}
