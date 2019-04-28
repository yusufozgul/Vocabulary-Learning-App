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
    func selectAnswer(selected: Int)
    {
        let page = wordPage[1]
        let wordData = wordDataArray[1]
        
        switch selected {
        case 1:
            if selected == wordData.correctAnswer
            {
                page.answerBox1Image.image = UIImage(named: "correctBoxBackground")
                correctAnswer.append(wordData.wordInfo.uid)
            }
            else
            {
                page.answerBox1Image.image = UIImage(named: "WrongBoxBackground")
                wrongAnswer.append(wordData.wordInfo.uid)
            }
            break
        case 2:
            if selected == wordData.correctAnswer
            {
                page.answerBox2Image.image = UIImage(named: "correctBoxBackground")
                correctAnswer.append(wordData.wordInfo.uid)
            }
            else
            {
                page.answerBox2Image.image = UIImage(named: "WrongBoxBackground")
                wrongAnswer.append(wordData.wordInfo.uid)
            }
            break
        case 3:
            if selected == wordData.correctAnswer
            {
                page.answerBox3Image.image = UIImage(named: "correctBoxBackground")
                correctAnswer.append(wordData.wordInfo.uid)
            }
            else
            {
                page.answerBox3Image.image = UIImage(named: "WrongBoxBackground")
                wrongAnswer.append(wordData.wordInfo.uid)
            }
            break
        case 4:
            if selected == wordData.correctAnswer
            {
                page.answerBox4Image.image = UIImage(named: "correctBoxBackground")
                correctAnswer.append(wordData.wordInfo.uid)
            }
            else
            {
                page.answerBox4Image.image = UIImage(named: "WrongBoxBackground")
                wrongAnswer.append(wordData.wordInfo.uid)
            }
            break
        default:
            break
        }
        correctCounter.text = String(describing: correctAnswer.count)
        wrongCounter.text =  String(describing: wrongAnswer.count)
        saveData()
        goNextPage(delay: 0.6)
    }
}
