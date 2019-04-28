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
    @IBOutlet weak var counterStack: UIStackView!
    @IBOutlet weak var correctCounter: UILabel!
    @IBOutlet weak var wrongCounter: UILabel!
    let wordPageScroll: UIScrollView = UIScrollView()
    
    var wordPage: [WordPage] = { ( ) -> [WordPage] in
        let wordPage0: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Previous Page
        let wordPage1: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Current Page
        let wordPage2: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Next Page
        return [wordPage0, wordPage1, wordPage2] }()
    
    var wordDataArray: [WordPageData] = []
    let wordDataParser = WordDataParser()
    var correctAnswer: [String] = []
    var wrongAnswer: [String] = []

    private var dragging = false
    private var scrollViewSize: CGSize = .zero
    let bltnBoard = BLTNItemManager(rootItem: BulletinDataSource.splashBoard())
    let skeletonGradient = SkeletonGradient(baseColor: .asbestos, secondaryColor: .silver)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("LEARN_VC_TITLE", comment: "")
        wordPageScroll.delegate = self
        wordPageScroll.isPagingEnabled = true
        wordPageScroll.showsHorizontalScrollIndicator = false
        wordPageScroll.showsVerticalScrollIndicator = false
        
        wordDataParser.fetchWord()
        prepareScrollView()
        
//        Giriş yapılıp yapılmadığının kontrolü. Giriş yapılmamışsa yönlendiriliyor.
        if UserDefaults.standard.object(forKey: "currentUser") == nil
        { showBulletin() }
        if Date().currentDate() == UserDefaults.standard.value(forKey: "day") as? String
        {
            correctAnswer = UserDefaults.standard.value(forKey: "correctAnswer") as! [String]
            wrongAnswer = UserDefaults.standard.value(forKey: "wrongAnswer") as! [String]
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "FetchWords"), object: nil, queue: OperationQueue.main, using: { _ in
            self.prepareScrollView()
            self.showHideSketlon()
            self.counterStack.isHidden = false
            self.correctCounter.text = String(describing: self.correctAnswer.count)
            self.wrongCounter.text =  String(describing: self.wrongAnswer.count)
        })
    }
    override func viewWillAppear(_ animated: Bool)
    {
        showHideSketlon()
    }
    func showHideSketlon()
    {
        if wordDataParser.getArrayCount() == 0
        {
        }
        else
        {
        }
    }
    private func prepareScrollView()
    {
        for page in wordPage {
            page.frame.size.width = view.frame.width / 1.2
            page.frame.size.height = view.frame.height / 1.5
        }
        
        wordDataArray.removeAll()
        (0..<3).forEach { i in
            let wordData = wordDataParser.getword()
            wordDataArray.append(wordData)
            wordPage[i].wordLabel.text = wordData.wordInfo.word
            wordPageScroll.addSubview(wordPage[i])
        }
        scrollViewSize = (wordPage.first?.frame.size)!
        wordPageScroll.frame.size = scrollViewSize
        wordPageScroll.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2)
        wordPageScroll.contentSize = CGSize(width: scrollViewSize.width * 3, height: scrollViewSize.height)
        wordPageScroll.contentOffset = CGPoint(x: scrollViewSize.width, y: 0)
        view.addSubview(wordPageScroll)
        layoutPages()
    }
    private func layoutPages()
    {
        var index = 0
        for page in wordPage
        {
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
            index += 1
        }
    }
//    Giriş yapma, kaydolma, bildirim izinleri sayfaları başlatılıyor.
    func showBulletin()
    {
        bltnBoard.backgroundViewStyle = BLTNBackgroundViewStyle.dimmed
        bltnBoard.showBulletin(above: self)
    }
}
extension LearnVC
{
    func saveData()
    {
        UserDefaults.standard.setValue(Date().currentDate(), forKey: "day")
        UserDefaults.standard.setValue(correctAnswer, forKey: "correctAnswer")
        UserDefaults.standard.setValue(wrongAnswer, forKey: "wrongAnswer")
        UserProgress().saveProgress(day: Date().currentDate(), correctData: correctAnswer, wrongData: wrongAnswer)
    }
}
extension LearnVC: UIScrollViewDelegate
{
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
    func goNextPage(delay: TimeInterval)
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
