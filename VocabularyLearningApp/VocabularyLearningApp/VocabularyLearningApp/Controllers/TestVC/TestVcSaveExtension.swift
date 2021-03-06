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
//    Bir kelime test edildiğinde eğer doğru bilindiyse kelime şimdiki yerinden alınıp bir sonraki test edilecek tarihe eklenir.
//    Bir kelime eğer yanlış bilindiyse yarın tekrar test etmek için level'i 1 yapılır.
    func saveData(isKnown: Bool)
    {
        let wordData = wordDataArray[1]
        let userProgressModel: UserProgressModelProtocol = UserProgressModel()
        
        if isKnown
        {
            wordDataParser.deleteTest(deleteID: wordData.wordPage.wordInfo.uid) // Test için gelen soru çözüldüğünde tekrar etmemesi için siliniyor
            let messageService: MessageViewerProtocol = MessageViewer.messageViewer
            
            switch wordData.level
            {
            case 1:
                userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 7, byAdding: DateInterval.day.rawValue), level: "2", word: wordData.wordPage.wordInfo.word, translate: wordData.wordPage.wordInfo.translate, sentence: wordData.wordPage.wordInfo.sentence, category: wordData.wordPage.wordInfo.category, id: wordData.wordPage.wordInfo.uid)
                userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
            case 2:
                userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 1, byAdding: DateInterval.month.rawValue), level: "3", word: wordData.wordPage.wordInfo.word, translate: wordData.wordPage.wordInfo.translate, sentence: wordData.wordPage.wordInfo.sentence, category: wordData.wordPage.wordInfo.category, id: wordData.wordPage.wordInfo.uid)
                userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
            case 3:
                userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 6, byAdding: DateInterval.month.rawValue), level: "4", word: wordData.wordPage.wordInfo.word, translate: wordData.wordPage.wordInfo.translate, sentence: wordData.wordPage.wordInfo.sentence, category: wordData.wordPage.wordInfo.category, id: wordData.wordPage.wordInfo.uid)
                userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
            case 4:
                userProgressModel.saveLearnedWord(day: Date().currentDate(), uid: wordData.wordPage.wordInfo.uid)
                userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
                messageService.succesMessage(title: NSLocalizedString("CONGRATULATIONS", comment: ""), body: NSLocalizedString("COMPLETED_WORDS", comment: ""))
            default:
                break
            }
        }
        else
        {
            userProgressModel.deleteSolvedTest(uid: wordData.wordPage.wordInfo.uid)
            userProgressModel.saveTestProgress(askDay: Date().addCurrentDate(value: 1, byAdding: DateInterval.day.rawValue), level: "1", word: wordData.wordPage.wordInfo.word, translate: wordData.wordPage.wordInfo.translate, sentence: wordData.wordPage.wordInfo.sentence, category: wordData.wordPage.wordInfo.category, id: wordData.wordPage.wordInfo.uid)
        }
    }
}
