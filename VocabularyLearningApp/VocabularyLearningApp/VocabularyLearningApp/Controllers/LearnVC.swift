//
//  FirstViewController.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit
import BLTNBoard
import SkeletonView

class LearnVC: UIViewController
{
    @IBOutlet weak var wordPageScroll: UIScrollView!
    
    var wordPage: [WordPage] = { ( ) -> [WordPage] in
        let wordPage0: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Previous Page
        let wordPage1: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Current Page
        let wordPage2: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Next Page
        return [wordPage0, wordPage1, wordPage2]
    }()
    var wordDataArray: [WordPageData] = []
    let wordDataParser = WordDataParser()

    private var dragging = false
    private var scrollViewSize: CGSize = .zero
    let bltnBoard = BLTNItemManager(rootItem: BulletinDataSource.splashBoard())
    let skeletonGradient = SkeletonGradient(baseColor: .asbestos, secondaryColor: .silver)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        
//        Giriş yapılıp yapılmadığının kontrolü. Giriş yapılmamışsa yönlendiriliyor.
//        if UserDefaults.standard.object(forKey: "currentUser") == nil
//        { showBulletin() }
        
        prepareScrollView()
        
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if wordDataParser.getArrayCount() == 0
        {
            wordPage[1].wordLabel.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            wordPage[1].answerBox1Image.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            wordPage[1].answerBox2Image.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            wordPage[1].answerBox3Image.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
            wordPage[1].answerBox4Image.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
        }
    }
    
    private func prepareScrollView()
    {
        (0..<3).forEach { i in
            let wordData = wordDataParser.getword()
            wordDataArray.append(wordData)
            wordPage[i].wordLabel.text = wordData.wordInfo.word
            wordPageScroll.addSubview(wordPage[i])
        }
        scrollViewSize = wordPageScroll.frame.size
        wordPageScroll.contentSize = CGSize(width: scrollViewSize.width * 3, height: scrollViewSize.height)
        wordPageScroll.contentOffset = CGPoint(x: scrollViewSize.width, y: 0)
        layoutPages()
    }
    
    private func layoutPages()
    {
        wordPage.enumerated().forEach { (arg0) in
            let (index, page) = arg0
            let wordData = wordDataArray[index]
            page.delegate = self
            
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
        }
    }

//    Giriş yapma, kaydolma, bildirim izinleri sayfaları başlatılıyor.
    func showBulletin()
    {
        bltnBoard.backgroundViewStyle = BLTNBackgroundViewStyle.dimmed
        bltnBoard.showBulletin(above: self)
    }

}
extension LearnVC: AnsweredDelegate
{
    func selectAnswer(selected: Int)
    {
        let page = wordPage[1]
        
        
        switch selected {
        case 1:
            if selected == wordDataArray[1].correctAnswer
            {
                page.answerBox1Image.image = UIImage(named: "correctBoxBackground")
            }
            break
        case 2:
            page.answerBox2Image.image = UIImage(named: "WrongBoxBackground")
            break
        case 3:
            print("c")
            break
        case 4:
            print("d")
            break
        default:
            break
        }
        goNextPage(0.6)
        
    }
}
extension LearnVC: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        dragging = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        dragging = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if !dragging {
            return
        }
        
        let offsetX = scrollView.contentOffset.x
        
        if (offsetX > scrollView.frame.size.width * 1.5)
        {
            let wordData = wordDataParser.getword()
            wordDataArray.remove(at: 0)
            wordDataArray.append(wordData)
            layoutPages()
            scrollView.contentOffset.x -= scrollViewSize.width
        }
        
        if (offsetX < scrollView.frame.size.width * 0.5)
        {
            let wordData = wordDataParser.getword()
            wordDataArray.removeLast()
            wordDataArray.insert(wordData, at: 0)
            layoutPages()
            scrollView.contentOffset.x += scrollViewSize.width
        }
    }
    func goNextPage(_ delay: TimeInterval)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay)
        {
            let wordData = self.wordDataParser.getword()
            self.wordDataArray.remove(at: 0)
            self.wordDataArray.append(wordData)
            self.layoutPages()
            self.wordPageScroll.scrollToPage(index: 2, animated: true)
        }
    }
}
extension UIScrollView {
    func scrollToPage(index: UInt8, animated: Bool)
    {
        let offset: CGPoint = CGPoint(x: CGFloat(index) * frame.size.width, y: 0)
        self.setContentOffset(offset, animated: animated)
        self.contentOffset.x -= self.frame.width
    }
}


