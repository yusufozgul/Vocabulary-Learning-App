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
        let page = wordPages[1]
        let wordData = wordDatas[1]
        var isKnown: Bool = false
        
        if selected == wordData.correctAnswer
        { isKnown = true }
        
        switch selected {
        case 1:
            if selected != wordData.correctAnswer
            { page.answerBox1Image.image = UIImage(named: "WrongBoxBackground") }
            break
        case 2:
            if selected != wordData.correctAnswer
            { page.answerBox1Image.image = UIImage(named: "WrongBoxBackground") }
            break
        case 3:
            if selected != wordData.correctAnswer
            { page.answerBox1Image.image = UIImage(named: "WrongBoxBackground") }
            break
        case 4:
            if selected != wordData.correctAnswer
            { page.answerBox1Image.image = UIImage(named: "WrongBoxBackground") }
            break
        default:
            break
        }
        switch wordData.correctAnswer
        {
        case 1:
            page.answerBox1Image.image = UIImage(named: "correctBoxBackground")
        case 2:
            page.answerBox2Image.image = UIImage(named: "correctBoxBackground")
        case 3:
            page.answerBox3Image.image = UIImage(named: "correctBoxBackground")
        case 4:
            page.answerBox4Image.image = UIImage(named: "correctBoxBackground")
        default:
            break
        }
        saveData(isKnown: isKnown) // cevap verisinin kaydedilmesi
        correctCounter.text = String(describing: dayCorrectAnswer.count) // doğru sayacının arttırılması
        wrongCounter.text =  String(describing: dayWrongAnswer.count) // yanlış sayacının arttırılması
        goNextPage(delay: 0.8) // Otomatik sayfa geçişi
    }
}
