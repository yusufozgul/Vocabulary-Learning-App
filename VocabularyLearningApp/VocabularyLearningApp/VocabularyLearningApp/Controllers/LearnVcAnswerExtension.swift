//
//  LearnVcAnswerExtension.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

extension LearnVC: AnsweredDelegate
{
//    Interface yardımıyla kelime kartından herhangi bir seçeneğe tıklanıldığında LearnVC delegate olduğundan haberdar oluyor.
//    Tıklanıldığı indisle gereken kontroller yapılıyor ve işlem devam ediyor.
    func selectAnswer(selected: Int)
    {
        let generator = UINotificationFeedbackGenerator()
        let page = wordPages[1]
        let wordData = wordDatas[1]
        var isKnown: Bool = false
        
        if selected == wordData.correctAnswer
        {
            generator.notificationOccurred(.success)
            isKnown = true
        }
        else
        {
            generator.notificationOccurred(.error)
            isKnown = false
        }
        
        switch selected
        {
        case 1:
            if selected != wordData.correctAnswer
            { page.answerBox1Image.image = UIImage(named: "answerA_Wrong") }
        case 2:
            if selected != wordData.correctAnswer
            { page.answerBox2Image.image = UIImage(named: "answerB_Wrong") }
        case 3:
            if selected != wordData.correctAnswer
            { page.answerBox3Image.image = UIImage(named: "answerC_Wrong") }
        case 4:
            if selected != wordData.correctAnswer
            { page.answerBox4Image.image = UIImage(named: "answerD_Wrong") }
        default:
            break
        }
        
        switch wordData.correctAnswer
        {
        case 1:
            page.answerBox1Image.image = UIImage(named: "answerA_True")
        case 2:
            page.answerBox2Image.image = UIImage(named: "answerB_True")
        case 3:
            page.answerBox3Image.image = UIImage(named: "answerC_True")
        case 4:
            page.answerBox4Image.image = UIImage(named: "answerD_True")
        default:
            break
        }
        saveData(isKnown: isKnown) // cevap verisinin kaydedilmesi
        correctCounter.text = String(describing: dayCorrectAnswer.count) // doğru sayacının arttırılması
        wrongCounter.text =  String(describing: dayWrongAnswer.count) // yanlış sayacının arttırılması
        goNextPage(delay: 1) // Otomatik sayfa geçişi
    }
}
