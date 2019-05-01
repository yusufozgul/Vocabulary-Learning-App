//
//  UserProgressModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

class UserProgress
{
    func saveLearnProgress(child: String, day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    {
        SaveUserProgress.init().saveProgress(child: child, day: day, correctData: correctData, wrongData: wrongData, solvedWords: solvedWords)
    }
    
    func saveTestProgress(child: String, askDay: String, word: String, level: String)
    {
        SaveUserProgress.init().saveTestedProgress(child: child, askDay: askDay, word: word, level: level)
    }
    
}
