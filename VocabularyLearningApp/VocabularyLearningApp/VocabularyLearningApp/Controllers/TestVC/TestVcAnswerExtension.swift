//
//  TestVcAnswerExtension.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 2.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

extension TestVC: AnsweredDelegate
{
//    Interface yardımıyla kelime kartından herhangi bir seçeneğe tıklanıldığında TestVC delegate olduğundan haberdar oluyor.
//    Tıklanıldığı indisle gereken kontroller yapılıyor ve işlem devam ediyor.
    func selectAnswer(selected: Int)
    {
        let generator = UINotificationFeedbackGenerator()
        let page = wordPages[1]
        let wordData = wordDataArray[1]
        var isKnown: Bool = false
        
        if selected == wordData.wordPage.correctAnswer
        {
            generator.notificationOccurred(.success)
            isKnown = true
        }
        else
        {
            generator.notificationOccurred(.error)
            isKnown = false
        }
        
        switch selected {
        case 1:
            if selected == wordData.wordPage.correctAnswer
            { page.answerBox1Image.image = UIImage(named: "TrueAnswer") }
                
            else
            { page.answerBox1Image.image = UIImage(named: "WrongAnswer") }
        case 2:
            if selected == wordData.wordPage.correctAnswer
            { page.answerBox2Image.image = UIImage(named: "TrueAnswer") }
                
            else
            { page.answerBox2Image.image = UIImage(named: "WrongAnswer") }
        case 3:
            if selected == wordData.wordPage.correctAnswer
            { page.answerBox3Image.image = UIImage(named: "TrueAnswer") }
                
            else
            { page.answerBox3Image.image = UIImage(named: "WrongAnswer") }
        case 4:
            if selected == wordData.wordPage.correctAnswer
            { page.answerBox4Image.image = UIImage(named: "TrueAnswer") }
                
            else
            { page.answerBox4Image.image = UIImage(named: "WrongAnswer") }
        default:
            break
        }
        saveData(isKnown: isKnown) // cevap verisinin kaydedilmesi
        goNextPage(delay: 1) // Otomatik sayfa geçişi
    }
}
