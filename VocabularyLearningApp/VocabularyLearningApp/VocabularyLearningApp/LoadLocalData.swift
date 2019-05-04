//
//  LoadLocalData.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 2.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

public class LoadLocalData
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
        if UserDefaults.standard.value(forKey: "SolvedWords") != nil
        {
            return UserDefaults.standard.value(forKey: "SolvedWords") as! [String]
        }
        return []
    }
}
