//
//  TestVcSaveExtension.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 2.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

extension TestVC
{
    func saveData(isKnown: Bool)
    {
        let wordData = wordDatas[1]
        let userProgressModel: UserProgress = UserProgress()
        if isKnown
        {
            switch wordData.level
            {
            case "1":
                userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 7, byAdding: "day"), level: "2", word: wordData.wordPage.wordInfo.word, translate: wordData.wordPage.wordInfo.translate, sentence: wordData.wordPage.wordInfo.sentence, category: wordData.wordPage.wordInfo.category, id: wordData.wordPage.wordInfo.uid)
                userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
            case "2":
                userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 1, byAdding: "month"), level: "3", word: wordData.wordPage.wordInfo.word, translate: wordData.wordPage.wordInfo.translate, sentence: wordData.wordPage.wordInfo.sentence, category: wordData.wordPage.wordInfo.category, id: wordData.wordPage.wordInfo.uid)
                userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
            case "3":
                userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 6, byAdding: "month"), level: "4", word: wordData.wordPage.wordInfo.word, translate: wordData.wordPage.wordInfo.translate, sentence: wordData.wordPage.wordInfo.sentence, category: wordData.wordPage.wordInfo.category, id: wordData.wordPage.wordInfo.uid)
                userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
            case "4":
                userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 1, byAdding: "year"), level: "5", word: wordData.wordPage.wordInfo.word, translate: wordData.wordPage.wordInfo.translate, sentence: wordData.wordPage.wordInfo.sentence, category: wordData.wordPage.wordInfo.category, id: wordData.wordPage.wordInfo.uid)
                userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
            default:
                break
            }
        }
        if !isKnown
        {
            userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
            userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 1, byAdding: "day"), level: "1", word: wordData.wordPage.wordInfo.word, translate: wordData.wordPage.wordInfo.translate, sentence: wordData.wordPage.wordInfo.sentence, category: wordData.wordPage.wordInfo.category, id: wordData.wordPage.wordInfo.uid)
        }
    }
}
