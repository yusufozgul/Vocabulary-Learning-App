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
    func saveLearnProgress(day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    func saveTestProgress(askDay: String, level: String, word: String, translate: String, sentence: String, category: String, id: String)
    func saveLearnedWord(day: String, uid: String)
    func deleteSolvedTest(uid: String)
}
class UserProgressModel: UserProgressModelProtocol
{
    private let service: UserProgressProtocol = UserProgress()
    func saveLearnProgress(day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            service.saveProgress(userID: currentUserId[1], day: day, correctData: correctData, wrongData: wrongData, solvedWords: solvedWords)
        }
    }
    
    func saveTestProgress(askDay: String, level: String, word: String, translate: String, sentence: String, category: String, id: String)
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            service.saveTestedProgress(userID: currentUserId[1], askDay: askDay, level: level, word: word, translate: translate, sentence: sentence, category: category, id: id)
        }
    }
    public func saveLearnedWord(day: String, uid: String)
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            service.saveLearnedWord(userID: currentUserId[1], day: day, uid: uid)
        }
    }
    func deleteSolvedTest(uid: String)
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            let deleteService: FireBaseDeleteProtocol = FireBaseDelete()
            deleteService.deteleteChil(userID: currentUserId[1], uid: uid)
        }
    }
}
