//
//  SecondViewController.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

class TestVC: UIViewController, WordScrollViewProtocol
{
    let wordPageScroll: UIScrollView = UIScrollView()
    let blurredEffectView = UIVisualEffectView()
    
    var wordPages: [WordPage] = { () -> [WordPage] in // ScrollView sayfalarının oluşturulmasu
        let wordPage0: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Previous Page
        let wordPage1: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Current Page
        let wordPage2: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Next Page
        return [wordPage0, wordPage1, wordPage2] }()
    
    var wordDatas: [WordPageData] = [] // sayfalardaki verilerimiz
    let wordDataParser = LearnWordDataParser() // Api'daki kelimeyi işleyip veren sınıf
    var dayCorrectAnswer: [String] = [] // günlük bilinen doğru kelimeler
    var dayWrongAnswer: [String] = [] // günlük yanlış bilinen kelimeler
    var solvedWords: [String] = [] // toplamda bilinen kelimeler
    
    private var isDragging = false
    private var scrollViewSize: CGSize = .zero

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("LEARN_VC_TITLE", comment: "")
        wordPageScroll.delegate = self
        wordPageScroll.isPagingEnabled = true
        wordPageScroll.showsHorizontalScrollIndicator = false
        wordPageScroll.showsVerticalScrollIndicator = false
        view.addSubview(wordPageScroll)
    }
    
    internal func loadingView()
    {
        if wordDataParser.getArrayCount() == 0
        {
            let blurEffect = UIBlurEffect(style: .extraLight)
            blurredEffectView.effect = blurEffect
            blurredEffectView.frame = view.frame
            let loadingIndicator = UIActivityIndicatorView()
            loadingIndicator.style = .whiteLarge
            loadingIndicator.color = .black
            loadingIndicator.center = view.center
            loadingIndicator.startAnimating()
            blurredEffectView.contentView.addSubview(loadingIndicator)
            view.addSubview(blurredEffectView)
        }
        else
        {
            blurredEffectView.removeFromSuperview()
        }
    }
    internal func prepareScrollView()
    {
        var wordData = wordDataParser.getword()
        for page in wordPages
        {
            page.frame.size.width = view.frame.width / 1.2
            page.frame.size.height = view.frame.height / 1.5
        }
        wordDatas.removeAll()
        
        for i in 0 ..< 3
        {
            wordData = wordDataParser.getword()
            wordDatas.append(wordData)
            wordPageScroll.addSubview(wordPages[i])
        }
        scrollViewSize = (wordPages.first?.frame.size)!
        wordPageScroll.frame.size = scrollViewSize
        wordPageScroll.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2)
        wordPageScroll.contentSize = CGSize(width: scrollViewSize.width * 3, height: scrollViewSize.height)
        wordPageScroll.contentOffset = CGPoint(x: scrollViewSize.width, y: 0)
        layoutPages()
    }
    
    internal func layoutPages()
    {
        var index = 0
        for page in wordPages
        {
            let wordData = wordDatas[index]
            page.delegate = self
            
            //            Sayfaların oluşturulmasında varsayılan ayarları yapılıyorç
            page.answerBox1Image.image = UIImage(named: "BoxBackground")
            page.answerBox2Image.image = UIImage(named: "BoxBackground")
            page.answerBox3Image.image = UIImage(named: "BoxBackground")
            page.answerBox4Image.image = UIImage(named: "BoxBackground")
            
            page.wordLabel.text = wordData.wordInfo.word
            page.wordCategoryLabel.text = wordData.wordInfo.category
            page.wordSentence.text = wordData.wordInfo.sentence
            
            page.answerBox1Label.text = wordData.option1
            page.answerBox2Label.text = wordData.option2
            page.answerBox3Label.text = wordData.option3
            page.answerBox4Label.text = wordData.option4
            
            page.frame = CGRect(x: wordPageScroll.frame.width * CGFloat(index),
                                y: 0,
                                width: wordPageScroll.frame.width,
                                height: wordPageScroll.frame.height)
            index += 1
        }
    }


}
extension TestVC: UIScrollViewDelegate
{
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        isDragging = true
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        isDragging = false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if !isDragging {
            return
        }
        let offsetX = scrollView.contentOffset.x
        
        if (offsetX > scrollView.frame.size.width * 1.5)
        {
            let wordData = wordDataParser.getword()
            wordDatas.remove(at: 0)
            wordDatas.append(wordData)
            layoutPages()
            scrollView.contentOffset.x -= scrollViewSize.width
        }
        
        if (offsetX < scrollView.frame.size.width * 0.5)
        {
            let wordData = wordDataParser.getword()
            wordDatas.removeLast()
            wordDatas.insert(wordData, at: 0)
            layoutPages()
            scrollView.contentOffset.x += scrollViewSize.width
        }
    }
    func goNextPage(delay: TimeInterval)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay)
        {
            let wordData = self.wordDataParser.getword()
            self.wordDatas.remove(at: 0)
            self.wordDatas.append(wordData)
            self.layoutPages()
            self.wordPageScroll.scrollToPage(index: 2, animated: true)
        }
    }
}


