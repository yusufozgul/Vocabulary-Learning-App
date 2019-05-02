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
        
        switch selected {
        case 1:
            if selected == wordData.correctAnswer
            {
                page.answerBox1Image.image = UIImage(named: "correctBoxBackground")
                solvedWords.append(wordData.wordInfo.uid)
                dayCorrectAnswer.append(wordData.wordInfo.uid)
                isKnown = true
            }
            else
            {
                page.answerBox1Image.image = UIImage(named: "WrongBoxBackground")
                dayWrongAnswer.append(wordData.wordInfo.uid)
            }
            break
        case 2:
            if selected == wordData.correctAnswer
            {
                page.answerBox2Image.image = UIImage(named: "correctBoxBackground")
                solvedWords.append(wordData.wordInfo.uid)
                dayCorrectAnswer.append(wordData.wordInfo.uid)
                isKnown = true
            }
            else
            {
                page.answerBox2Image.image = UIImage(named: "WrongBoxBackground")
                dayWrongAnswer.append(wordData.wordInfo.uid)
            }
            break
        case 3:
            if selected == wordData.correctAnswer
            {
                page.answerBox3Image.image = UIImage(named: "correctBoxBackground")
                solvedWords.append(wordData.wordInfo.uid)
                dayCorrectAnswer.append(wordData.wordInfo.uid)
                isKnown = true
            }
            else
            {
                page.answerBox3Image.image = UIImage(named: "WrongBoxBackground")
                dayWrongAnswer.append(wordData.wordInfo.uid)
            }
            break
        case 4:
            if selected == wordData.correctAnswer
            {
                page.answerBox4Image.image = UIImage(named: "correctBoxBackground")
                solvedWords.append(wordData.wordInfo.uid)
                dayCorrectAnswer.append(wordData.wordInfo.uid)
                isKnown = true
            }
            else
            {
                page.answerBox4Image.image = UIImage(named: "WrongBoxBackground")
                dayWrongAnswer.append(wordData.wordInfo.uid)
            }
            break
        default:
            break
        }
        correctCounter.text = String(describing: dayCorrectAnswer.count) // doğru sayacının arttırılması
        wrongCounter.text =  String(describing: dayWrongAnswer.count) // yanlış sayacının arttırılması
        saveData(isKnown: isKnown) // cevap verisinin kaydedilmesi
        goNextPage(delay: 0.6) // Otomatik sayfa geçişi
    }
}
