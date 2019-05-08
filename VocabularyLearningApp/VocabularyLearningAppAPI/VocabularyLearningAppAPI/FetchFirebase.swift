//
//  FetchWord.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Firebase'den kelime çeker ve parse edip gönderir.

public protocol fetchServiceProtocol
{
    func fetchAllWord(completion: @escaping (Result<FetchWordResponse>) -> Void)
    func fetchTestWord(userID: String, completion: @escaping (Result<FetchTestWordReponse>) -> Void)
    func fetchChilds(userID: String)
}

public class FetchWords: fetchServiceProtocol
{
    private var dbRef: DatabaseReference!
    private var wordDbRef: DatabaseReference!
    public var childs: [String] = []
    
    public static let fetchWords = FetchWords()
    private init() { }
    
    public func fetchAllWord(completion: @escaping (Result<FetchWordResponse>) -> Void)
    {
        var dataArray: FetchWordResponse = FetchWordResponse(results: [])
        dataArray.results.removeAll()
        dbRef = Database.database().reference().child("Words")
        
        let words = dbRef.queryOrderedByKey()
        words.observe(.value) { (snap) in
            words.observe(.childAdded, with: { snaphot in
                if let firebaseData = snaphot.value as? [String:String]
                {
                    let wordData: WordData = WordData(word: firebaseData["word"]!, translate: firebaseData["translate"]!, sentence: firebaseData["sentence"]!, category: firebaseData["category"]!, uid: firebaseData["uid"]!)
                    dataArray.results.append(wordData)
                    
                    if  dataArray.results.count == snap.childrenCount
                    { completion(.success(dataArray)) }
                }
                else
                { completion(.failure(NSLocalizedString("WORD_NOT_FOUND", comment: ""))) }
            })
        }
    }
    public func fetchChilds(userID: String)
    {
        var count = 0
        childs.removeAll()

        wordDbRef = Database.database().reference().child("UserData").child(userID).child("TestableWords")
        let testRef = wordDbRef.queryOrderedByKey()
        testRef.observe(.value, with: { snapshot in
            
            if snapshot.children.allObjects.count == 0
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchedChildERROR"), object: nil)
            }
            if let result = snapshot.children.allObjects as? [DataSnapshot]
            {
                for child in result
                {
                    count += 1
                    if Date().dateFormatter(date: child.key) <= NSDate() as Date
                    {
                        self.childs.append(child.key)
                    }
                    
                    if count == snapshot.childrenCount
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchedChild"), object: nil) // Kelimeler çekilip hazır edildiğinde alt fonksiyon haberdar ediliyor.
                    }
                }
                if self.childs.count == 0
                { NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchedChildERROR"), object: nil) }
            }
        })
    }
    
    public func fetchTestWord(userID: String, completion: @escaping (Result<FetchTestWordReponse>) -> Void)
    {
        fetchChilds(userID: userID)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fetchedChild"), object: nil, queue: OperationQueue.main, using: { (_) in

            let wordDetail: WordData = WordData(word: "", translate: "", sentence: "", category: "", uid: "")
            var testableWordData: TestedWordData = TestedWordData(word: wordDetail, level: "")
            
            var testableWords: FetchTestWordReponse = FetchTestWordReponse(results: [])
            var snapCount = 0
            for child in self.childs
            {
                self.dbRef = Database.database().reference().child("UserData").child(userID).child("TestableWords").child(child)
                let testRef = self.dbRef.queryOrderedByKey()
                testRef.observe(.value, with: { (snap) in snapCount += Int(snap.childrenCount) })
                
                testRef.observe(.childAdded, with: { snaphot in
                    
                    if let firebaseData = snaphot.value! as? [String:String]
                    {
                        testableWordData.word.word = firebaseData["word"]!
                        testableWordData.word.translate = firebaseData["translate"]!
                        testableWordData.word.sentence = firebaseData["sentence"]!
                        testableWordData.word.category = firebaseData["category"]!
                        testableWordData.word.uid = firebaseData["uid"]!
                        testableWordData.level = firebaseData["level"]!
                        testableWords.results.append(testableWordData)
                        
                        if (child == self.childs.last) && (testableWords.results.count == snapCount)
                        {
                            completion(.success(testableWords))
                        }
                    }
                    else
                    {  completion(.failure(NSLocalizedString("TEST_DATA_ERROR", comment: ""))) }
                })
            }
        })
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fetchedChildERROR"), object: nil, queue: OperationQueue.main, using: { (_) in
            completion(.failure(NSLocalizedString("NULL_TEST_WORDS", comment: "")))
        })
    }
}
