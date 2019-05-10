//
//  UserProgressModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI


/*
 Kullanıcının ilerlemesinin kaydedilmesini sağlayan model. Kullanıcıya ait, test verileri, çözüm verileri öğrenme verileri.
 */
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
    let authdata = UserData.userData
    func saveLearnProgress(day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    {
        authdata.reloadData()
        if authdata.isSign
        {
            service.saveProgress(userID: authdata.userID, day: day, correctData: correctData, wrongData: wrongData, solvedWords: solvedWords)
        }
    }
    
    func saveTestProgress(askDay: String, level: String, word: String, translate: String, sentence: String, category: String, id: String)
    {
        authdata.reloadData()
        if authdata.isSign
        {
            service.saveTestedProgress(userID: authdata.userID, askDay: askDay, level: level, word: word, translate: translate, sentence: sentence, category: category, id: id)
        }
    }
    public func saveLearnedWord(day: String, uid: String)
    {
        authdata.reloadData()
        if authdata.isSign
        {
            var words: [String] = []
            if Date().currentDate() == UserDefaults.standard.value(forKey: "LearnedDate") as? String
            {
                if let wordsArray: [String] =  UserDefaults.standard.value(forKey: "LearnedWords") as? [String]
                {
                    words = wordsArray
                }
            }
            
            words.append(uid)
            UserDefaults.standard.setValue(words, forKey: "LearnedWords")
            UserDefaults.standard.setValue(Date().currentDate(), forKey: "LearnedDate")
            service.saveLearnedWord(userID: authdata.userID, day: day, uid: words)
        }
    }
    func deleteSolvedTest(uid: String)
    {
        authdata.reloadData()
        if authdata.isSign
        {
            let deleteService: FireBaseDeleteProtocol = FireBaseDelete()
            deleteService.deteleteChil(userID: authdata.userID, uid: uid)
        }
    }
}
