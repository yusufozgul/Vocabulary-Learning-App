//
//  WordPage.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 27.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

class WordPage: UIView
{
//    Kelime kartları, bir kelime gösterilirken buradan oluşturulan sayfa gösterilir.
    weak var delegate: AnsweredDelegate?

    @IBOutlet weak var pageBackground: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordCategoryLabel: UILabel!
    @IBOutlet weak var wordSentence: UITextView!
    
    @IBOutlet weak var answerBox1Image: UIImageView!
    @IBOutlet weak var answerBox2Image: UIImageView!
    @IBOutlet weak var answerBox3Image: UIImageView!
    @IBOutlet weak var answerBox4Image: UIImageView!

    @IBOutlet weak var answerBox1Label: UILabel!
    @IBOutlet weak var answerBox2Label: UILabel!
    @IBOutlet weak var answerBox3Label: UILabel!
    @IBOutlet weak var answerBox4Label: UILabel!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    @IBAction func answerBox1Button(_ sender: Any)
    {
        delegate?.selectAnswer(selected: 1)
        buttonSet()
    }
    
    @IBAction func answerBox2Button(_ sender: Any)
    {
        delegate?.selectAnswer(selected: 2)
        buttonSet()
    }
    
    @IBAction func answerBox3Button(_ sender: Any)
    {
        delegate?.selectAnswer(selected: 3)
        buttonSet()
    }
    
    @IBAction func answerBox4Button(_ sender: Any)
    {
        delegate?.selectAnswer(selected: 4)
        buttonSet()
    }
    
    func buttonSet() // Cevap verildikten sonra butonların açılıp kapanması
    {
        answerButton1.isEnabled = !answerButton1.isEnabled
        answerButton2.isEnabled = !answerButton2.isEnabled
        answerButton3.isEnabled = !answerButton3.isEnabled
        answerButton4.isEnabled = !answerButton4.isEnabled
    }
}
