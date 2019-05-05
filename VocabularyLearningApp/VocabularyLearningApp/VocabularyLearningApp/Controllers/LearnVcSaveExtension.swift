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
        let userProgressModel: UserProgressModelProtocol = UserProgressModel()
//        Bir soru çözüldüğünde bugünün tarihine göre kelime Firebase'de ilgili yere kaydedilir. Eğer doğru bilinmişse test için gerekli yerede kayıt işlemini yapıyor.
        UserDefaults.standard.setValue(Date().currentDate(), forKey: "day")
        UserDefaults.standard.setValue(dayCorrectAnswer, forKey: "correctAnswer")
        UserDefaults.standard.setValue(dayWrongAnswer, forKey: "wrongAnswer")
        UserDefaults.standard.setValue(solvedWords, forKey: "SolvedWords")
        userProgressModel.saveLearnProgress(child: "LearnedWords", day: Date().currentDate(), correctData: dayCorrectAnswer, wrongData: dayWrongAnswer, solvedWords: solvedWords)
        if isKnown
        {
            let wordData = wordDatas[1]
            wordDataParser.deleteLearn(index: wordData.wordIndex) // Bir kelime doğru bilindiyse tekrar etmemesi için siliniyor.
            userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 1, byAdding: "day"), level: "1", word: wordData.wordInfo.word, translate: wordData.wordInfo.translate, sentence: wordData.wordInfo.sentence, category: wordData.wordInfo.category, id: wordData.wordInfo.uid)
        }
    }
}
