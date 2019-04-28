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
    func saveProgress(day: String, correctData: [String], wrongData: [String])
    {
        SaveUserProgress.init().saveProgress(day: day, correctData: correctData, wrongData: wrongData)
    }
}
