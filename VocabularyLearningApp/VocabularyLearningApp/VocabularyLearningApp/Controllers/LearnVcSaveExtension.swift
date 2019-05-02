//
//  LearnVcSaveExtension.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 30.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

extension LearnVC
{
    func saveData(isKnown: Bool)
    {
//        Verileri lokalde ve Firebasede kaydetme adımları.
        UserDefaults.standard.setValue(Date().currentDate(), forKey: "day")
        UserDefaults.standard.setValue(dayCorrectAnswer, forKey: "correctAnswer")
        UserDefaults.standard.setValue(dayWrongAnswer, forKey: "wrongAnswer")
        UserDefaults.standard.setValue(solvedWords, forKey: "SolvedWords")
        UserProgress().saveLearnProgress(child: "LearnedWords", day: Date().currentDate(), correctData: dayCorrectAnswer, wrongData: dayWrongAnswer, solvedWords: solvedWords)
        if isKnown
        {
            let wordData = wordDatas[1]
            UserProgress().saveTestProgress(askDay: Date().addCurrentDate(value: 1, byAdding: "day"), level: "1", word: wordData.wordInfo.word, translate: wordData.wordInfo.translate, sentence: wordData.wordInfo.sentence, category: wordData.wordInfo.category, id: wordData.wordInfo.uid)
        }
    }
}
