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
        let page = wordPages[1]
        let wordData = wordDataArray[1]
        var isKnown: Bool = false
        
        switch selected {
        case 1:
            if selected == wordData.wordPage.correctAnswer
            {
                page.answerBox1Image.image = UIImage(named: "correctBoxBackground")
                isKnown = true
            }
            else
            {
                page.answerBox1Image.image = UIImage(named: "WrongBoxBackground")
            }
            break
        case 2:
            if selected == wordData.wordPage.correctAnswer
            {
                page.answerBox2Image.image = UIImage(named: "correctBoxBackground")
                isKnown = true
            }
            else
            {
                page.answerBox2Image.image = UIImage(named: "WrongBoxBackground")
            }
            break
        case 3:
            if selected == wordData.wordPage.correctAnswer
            {
                page.answerBox3Image.image = UIImage(named: "correctBoxBackground")
                isKnown = true
            }
            else
            {
                page.answerBox3Image.image = UIImage(named: "WrongBoxBackground")
            }
            break
        case 4:
            if selected == wordData.wordPage.correctAnswer
            {
                page.answerBox4Image.image = UIImage(named: "correctBoxBackground")
                isKnown = true
            }
            else
            {
                page.answerBox4Image.image = UIImage(named: "WrongBoxBackground")
            }
            break
        default:
            break
        }
        saveData(isKnown: isKnown) // cevap verisinin kaydedilmesi
        goNextPage(delay: 0.6) // Otomatik sayfa geçişi
    }
    func goNextPage(delay: TimeInterval) // Otomatik sayfa geçiş fonksiyonu, gönderilen zamana göre geçiş yapılıyor.
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay)
        {
            let wordData = self.wordDataParser.getTestWord()
            self.wordDataArray.remove(at: 0)
            self.wordDataArray.append(wordData)
            self.layoutWordPage()
            self.wordPageScrollView.scrollToPage(index: 2, animated: true)
        }
    }
}
