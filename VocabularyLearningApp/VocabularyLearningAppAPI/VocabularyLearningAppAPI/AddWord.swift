//
//  AddWord.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

/*
 Kullanıcılar tarafından kelime ekleme, gelen kelime veri tabanının ilgili yerine eklenir.
 */

public protocol AddWordProtocol
{
    func AddNewWord(word: String, translate: String, sentence: String, category: String, completion: @escaping (Result<AddWordResponse>) -> Void)
}
//  Gelen kelimeyi Firebase'e ekler
public class AddWord: AddWordProtocol
{
    public init() { }
    
    public func AddNewWord(word: String, translate: String, sentence: String, category: String, completion: @escaping (Result<AddWordResponse>) -> Void)
    {
        var dbRef: DatabaseReference!
        let uid = NSUUID().uuidString
        dbRef = Database.database().reference().child(FirebaseChilds.Words.rawValue).child(uid)
        
        dbRef.setValue([FirebaseChilds.word.rawValue: word, FirebaseChilds.translate.rawValue: translate, FirebaseChilds.sentence.rawValue: sentence, FirebaseChilds.category.rawValue: category, FirebaseChilds.uid.rawValue: uid]) { (errorDB, DBRef) in
            if errorDB != nil
            {
                completion(.failure(errorDB!.localizedDescription))                
            }
            else
            {
                let result = AddWordResponse(result: true)
                completion(.success(result))
            }
        }
    }
}

