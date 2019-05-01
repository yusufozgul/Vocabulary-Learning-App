//
//  TestVcAnswerExtension.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 30.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import UIKit

extension TestVC: AnsweredDelegate
{
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
        saveData(isKnown: isKnown)
        goNextPage(delay: 0.6)
    }
}
