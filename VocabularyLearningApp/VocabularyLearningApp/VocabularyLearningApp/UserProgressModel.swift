//
//  UserProgressModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

protocol UserProgressModelProtocol
{
    func saveLearnProgress(child: String, day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    func saveTestProgress(askDay: String, level: String, word: String, translate: String, sentence: String, category: String, id: String)
    func deleteSolvedTest(uid: String)
}
class UserProgressModel: UserProgressModelProtocol
{
    private let service: UserProgressProtocol = UserProgress()
    func saveLearnProgress(child: String, day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    {
        service.saveProgress(child: child, day: day, correctData: correctData, wrongData: wrongData, solvedWords: solvedWords)
    }
    
    func saveTestProgress(askDay: String, level: String, word: String, translate: String, sentence: String, category: String, id: String)
    {
        service.saveTestedProgress(askDay: askDay, level: level, word: word, translate: translate, sentence: sentence, category: category, id: id)
    }
    
    func deleteSolvedTest(uid: String)
    {
        let deleteService: FireBaseDeleteProtocol = FireBaseDelete()
        deleteService.deteleteChil(uid: uid)
    }
}
