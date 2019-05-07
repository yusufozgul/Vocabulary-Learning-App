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
        saveData(isKnown: isKnown) // cevap verisinin kaydedilmesi
        correctCounter.text = String(describing: dayCorrectAnswer.count) // doğru sayacının arttırılması
        wrongCounter.text =  String(describing: dayWrongAnswer.count) // yanlış sayacının arttırılması
        goNextPage(delay: 0.6) // Otomatik sayfa geçişi
    }
    func goNextPage(delay: TimeInterval) // Otomatik sayfa geçiş fonksiyonu, gönderilen zamana göre geçiş yapılıyor.
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay)
        {
            self.wordPages[1].buttonSet()
            let wordData = self.wordDataParser.getLearnWord()
            self.wordDatas.remove(at: 0)
            self.wordDatas.append(wordData)
            self.layoutWordPage()
            self.wordPageScrollView.scrollToPage(index: 2, animated: true)
        }
    }
}
