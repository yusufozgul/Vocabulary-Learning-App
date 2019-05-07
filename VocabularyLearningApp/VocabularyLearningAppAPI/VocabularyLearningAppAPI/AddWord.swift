//
//  AddWord.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

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
        dbRef = Database.database().reference().child("Words").child(uid)
        
        dbRef.setValue(["word": word, "translate": translate, "sentence": sentence, "category": category, "uid": uid]) { (errorDB, DBRef) in
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

