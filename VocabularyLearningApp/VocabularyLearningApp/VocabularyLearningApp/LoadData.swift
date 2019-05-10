//
//  LoadLocalData.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 2.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

/*
 Kullanıcıya ait veriler geri yüklenir.
 */
public class LoadData
{
    public func loadCorrectAnswers() -> [String]
    {
        if Date().currentDate() == UserDefaults.standard.value(forKey: "day") as? String
        {
            return UserDefaults.standard.value(forKey: "correctAnswer") as! [String]
        }
        return []
    }
    public func loadWrongAnswers() -> [String]
    {
        if Date().currentDate() == UserDefaults.standard.value(forKey: "day") as? String
        {
            return UserDefaults.standard.value(forKey: "wrongAnswer") as! [String]
        }
        return []
    }
    public func loadSolvedWords() -> [String]
    {
        if UserData.userData.isSign
        {
            let firebaseService: fetchServiceProtocol = FetchWords.fetchWords // Firebase service
            firebaseService.fetchSolvedWords(userID: UserData.userData.userID) { (result) in
                switch result {
                case .success(let value):
                   UserDefaults.standard.setValue(value.result, forKey: "SolvedWords")
                    
                case .failure(_):
                    break
                }
            }
        }
        if UserDefaults.standard.value(forKey: "SolvedWords") != nil
        {
            return UserDefaults.standard.value(forKey: "SolvedWords") as! [String]
        }
        return []
    }
}
