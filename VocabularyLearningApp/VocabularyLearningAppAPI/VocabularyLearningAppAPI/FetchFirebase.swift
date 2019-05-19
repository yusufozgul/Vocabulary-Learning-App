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
    func fetchSolvedWords(userID: String, completion: @escaping (Result<solvedWordsResponse>) -> Void)
    func fetchChilds(userID: String, completion: @escaping (Result<Any>) -> Void)
}

public class FetchWords: fetchServiceProtocol
{
    private var dbRef: DatabaseReference!
    private var wordDbRef: DatabaseReference!
    public var childs: [String] = []
    
    public static let fetchWords = FetchWords()
    private init() { }
    
    public func fetchSolvedWords(userID: String, completion: @escaping (Result<solvedWordsResponse>) -> Void) // Çözülmüş kelimeler çekilir.
    {
        var solvedWordsArray: [String] = []
        dbRef = Database.database().reference().child(FirebaseChilds.UserData.rawValue).child(userID).child(FirebaseChilds.SolvedWords.rawValue)
        let solvedWords = dbRef.queryOrderedByKey()
        solvedWords.observe(.value) { (snapshot) in
            if let result = snapshot.value as? [String]
            {
                solvedWordsArray = result
            }
            if solvedWordsArray.count == snapshot.childrenCount
            {
                let solvedResponse: solvedWordsResponse = solvedWordsResponse(result: solvedWordsArray)
                completion(.success(solvedResponse))
            }
        }
    }
    
    public func fetchAllWord(completion: @escaping (Result<FetchWordResponse>) -> Void) // Tüm kelimeler çekilir.
    {
        var dataArray: FetchWordResponse = FetchWordResponse(results: [])
        dataArray.results.removeAll()
        dbRef = Database.database().reference().child(FirebaseChilds.Words.rawValue)
        
        let words = dbRef.queryOrderedByKey()
        words.observe(.value) { (snap) in
            words.observe(.childAdded, with: { snaphot in
                if let firebaseData = snaphot.value as? [String:String]
                {
                    let wordData: WordData = WordData(word: firebaseData[FirebaseChilds.word.rawValue]!, translate: firebaseData[FirebaseChilds.translate.rawValue]!, sentence: firebaseData[FirebaseChilds.sentence.rawValue]!, category: firebaseData[FirebaseChilds.category.rawValue]!, uid: firebaseData[FirebaseChilds.uid.rawValue]!)
                    dataArray.results.append(wordData)
                    
                    if  dataArray.results.count == snap.childrenCount
                    { completion(.success(dataArray)) }
                }
                else
                { completion(.failure(NSLocalizedString("WORD_NOT_FOUND", comment: ""))) }
            })
        }
    }
    public func fetchChilds(userID: String, completion: @escaping (Result<Any>) -> Void) // Test için kelimelerin klasör isimleri çekilir yani tarihleri
    {
        var isFetched = false
        var count = 0
        childs.removeAll()
        wordDbRef = Database.database().reference().child(FirebaseChilds.UserData.rawValue).child(userID).child(FirebaseChilds.TestableWords.rawValue)
        let testRef = wordDbRef.queryOrderedByKey()
        
        testRef.observe(.value, with: { snapshot in
            if !isFetched
            {
                if snapshot.children.allObjects.count == 0
                {
                    completion(.failure(NSLocalizedString("NULL_TEST_WORDS", comment: "")))
                    isFetched = true
                }
                if let result = snapshot.children.allObjects as? [DataSnapshot]
                {
                    for child in result
                    {
                        count += 1
                        if Date().dateFormatter(date: child.key) <= NSDate() as Date
                        {  self.childs.append(child.key) }
                        
                        if count == snapshot.childrenCount
                        {
                            completion(.success(""))
                            isFetched = true
                        } // Kelimeler çekilip hazır edildiğinde alt fonksiyon haberdar ediliyor.
                    }
                    if self.childs.count == 0
                    {
                        completion(.failure(NSLocalizedString("NULL_TEST_WORDS", comment: "")))
                        isFetched = true
                    }
                }
                else
                {
                    completion(.failure(NSLocalizedString("TEST_DATA_ERROR", comment: "")))
                    isFetched = true
                }
            }
        })
    }
    
    public func fetchTestWord(userID: String, completion: @escaping (Result<FetchTestWordReponse>) -> Void) // Gelen klasör isimlerine göre veriler çekilip gönderilir.
    {
        fetchChilds(userID: userID) { (result) in
            switch result
            {
            case .success(_):
                let wordDetail: WordData = WordData(word: "", translate: "", sentence: "", category: "", uid: "")
                var testableWordData: TestedWordData = TestedWordData(word: wordDetail, level: 0)
                
                var testableWords: FetchTestWordReponse = FetchTestWordReponse(results: [])
                var snapCount = 0
                for child in self.childs
                {
                    self.dbRef = Database.database().reference().child(FirebaseChilds.UserData.rawValue).child(userID).child(FirebaseChilds.TestableWords.rawValue).child(child)
                    let testRef = self.dbRef.queryOrderedByKey()
                    testRef.observe(.value, with: { (snap) in snapCount += Int(snap.childrenCount) })
                    
                    testRef.observe(.childAdded, with: { snaphot in
                        
                        if let firebaseData = snaphot.value! as? [String:String]
                        {
                            testableWordData.word.word = firebaseData[FirebaseChilds.word.rawValue]!
                            testableWordData.word.translate = firebaseData[FirebaseChilds.translate.rawValue]!
                            testableWordData.word.sentence = firebaseData[FirebaseChilds.sentence.rawValue]!
                            testableWordData.word.category = firebaseData[FirebaseChilds.category.rawValue]!
                            testableWordData.word.uid = firebaseData[FirebaseChilds.uid.rawValue]!
                            testableWordData.level = Int(firebaseData[FirebaseChilds.level.rawValue]!)!
                            testableWords.results.append(testableWordData)
                            
                            if (child == self.childs.last) && (testableWords.results.count == snapCount)
                            { completion(.success(testableWords)) }
                        }
                        else
                        {  completion(.failure(NSLocalizedString("TEST_DATA_ERROR", comment: ""))) }
                    })
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
