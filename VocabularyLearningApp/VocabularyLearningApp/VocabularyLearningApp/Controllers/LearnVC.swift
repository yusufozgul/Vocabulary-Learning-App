//
//  FirstViewController.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit
import BLTNBoard

class LearnVC: UIViewController, WordScrollViewProtocol
{
//    Günlük doğru yanlış sayısını tutan yapı
    @IBOutlet weak var counterStack: UIStackView!
    @IBOutlet weak var correctCounter: UILabel!
    @IBOutlet weak var wrongCounter: UILabel!
    
    let wordPageScrollView: UIScrollView = UIScrollView() // kaydırılabilir sayfamız
    let blurredEffectView = UIVisualEffectView() // loading view'u
    
    var wordPages: [WordPage] = { () -> [WordPage] in // ScrollView sayfalarının oluşturulmasu
        let wordPage0: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Previous Page
        let wordPage1: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Current Page
        let wordPage2: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Next Page
        return [wordPage0, wordPage1, wordPage2] }()
    
    var wordDatas: [WordPageData] = [] // sayfalardaki verilerimiz
    let wordDataParser = LearnWordParser.parser // Api'daki kelimeyi işleyip veren static sınıf
    var dayCorrectAnswer: [String] = [] // günlük bilinen doğru kelimeler
    var dayWrongAnswer: [String] = [] // günlük yanlış bilinen kelimeler
    var solvedWords: [String] = [] // toplamda bilinen kelimeler
    
    private var isDragging = false // kaydırma kontrolü
    private var scrollViewSize: CGSize = .zero
    
    let authBoard = BLTNItemManager(rootItem: BulletinDataSource.splashBoard()) // Kaydol, giriş yap sayfası

    override func viewDidLoad()
    {
        super.viewDidLoad()

//        View ayarlamaları
        navigationItem.title = NSLocalizedString("LEARN_VC_TITLE", comment: "")
        wordPageScrollView.delegate = self
        wordPageScrollView.isPagingEnabled = true
        wordPageScrollView.showsHorizontalScrollIndicator = false
        wordPageScrollView.showsVerticalScrollIndicator = false
        view.addSubview(wordPageScrollView)
        
//        Verilerin çekilmesi, parse edilmesi ve local verilerin çekilmesi
        wordDataParser.fetchedLearnWord()
        prepareScrollView()
        loadData()
        
//        Giriş yapılıp yapılmadığının kontrolü. Giriş yapılmamışsa yönlendiriliyor.
        if UserDefaults.standard.object(forKey: "currentUser") == nil
        { showBulletin() }
        
//        Kelime geldiği zaman bilgi mesajını yakalayıp işlem yapımı
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "FetchWords"), object: nil, queue: OperationQueue.main, using: { _ in
            self.prepareScrollView()
            self.loadingView()
            self.counterStack.isHidden = false
            self.correctCounter.text = String(describing: self.dayCorrectAnswer.count)
            self.wrongCounter.text =  String(describing: self.dayWrongAnswer.count)
        })
    }
    override func viewWillAppear(_ animated: Bool)
    {
        loadingView()
    }
    internal func loadingView() // Loading sayfası gösterimi ve kontrolü
    {
        if wordDataParser.getLearnArrayCount() == 0
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
    internal func loadData()
    {
        let loader = LoadLocalData()
        dayCorrectAnswer.removeAll()
        dayWrongAnswer.removeAll()
        solvedWords.removeAll()
        dayCorrectAnswer = loader.loadCorrectAnswers()
        dayWrongAnswer = loader.loadWrongAnswers()
        solvedWords = loader.loadSolvedWords()
    }
    internal func prepareScrollView() // ScrollView'un ayarlanması ve kelimelerin yerleştirilmesi
    {
        var wordData = wordDataParser.getLearnWord()
        for page in wordPages
        {
            page.frame.size.width = view.frame.width / 1.2
            page.frame.size.height = view.frame.height / 1.5
        }
        wordDatas.removeAll()
        
        for i in 0 ..< 3
        {
            wordData = wordDataParser.getLearnWord()
            wordDatas.append(wordData)
            wordPageScrollView.addSubview(wordPages[i])
        }
        scrollViewSize = (wordPages.first?.frame.size)!
        wordPageScrollView.frame.size = scrollViewSize
        wordPageScrollView.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2)
        wordPageScrollView.contentSize = CGSize(width: scrollViewSize.width * 3, height: scrollViewSize.height)
        wordPageScrollView.contentOffset = CGPoint(x: scrollViewSize.width, y: 0)
        layoutWordPage()
    }
    internal func layoutWordPage() // ScrollView'a kelimelerin verilmesi
    {
        var index = 0
        for page in wordPages
        {
            let wordData = wordDatas[index]
            page.delegate = self
            
//            Sayfaların oluşturulmasında varsayılan ayarları yapılıyor
            page.answerBox1Image.image = UIImage(named: "BoxBackground")
            page.answerBox2Image.image = UIImage(named: "BoxBackground")
            page.answerBox3Image.image = UIImage(named: "BoxBackground")
            page.answerBox4Image.image = UIImage(named: "BoxBackground")
            
//            Kelimeleri ve şıkları yerleştirme
            page.wordLabel.text = wordData.wordInfo.word
            page.wordCategoryLabel.text = wordData.wordInfo.category
            page.wordSentence.text = wordData.wordInfo.sentence
            
            page.answerBox1Label.text = wordData.option1
            page.answerBox2Label.text = wordData.option2
            page.answerBox3Label.text = wordData.option3
            page.answerBox4Label.text = wordData.option4
            
            page.frame = CGRect(x: wordPageScrollView.frame.width * CGFloat(index), // frame ayarları
                                y: 0,
                                width: wordPageScrollView.frame.width,
                                height: wordPageScrollView.frame.height)
            index += 1
        }
    }
//    Giriş yapma, kaydolma, bildirim izinleri sayfaları başlatılıyor.
    func showBulletin()
    {
        authBoard.backgroundViewStyle = BLTNBackgroundViewStyle.dimmed
        authBoard.showBulletin(above: self)
    }
}

extension LearnVC: UIScrollViewDelegate
{
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // Kaydırma başladı
    { isDragging = true }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // Kaydırma sonlandırıldı
    { isDragging = false }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) // kaydırma bitince kaydırma sonlandırılmışsa sayfa geçiş işlemleri yapılıyor
    {
        if !isDragging
        { return }
        
        let offsetX = scrollView.contentOffset.x
        
        if (offsetX > scrollView.frame.size.width * 1.5)
        {
            let wordData = wordDataParser.getLearnWord()
            wordDatas.remove(at: 0)
            wordDatas.append(wordData)
            layoutWordPage()
            scrollView.contentOffset.x -= scrollViewSize.width
        }
        
        if (offsetX < scrollView.frame.size.width * 0.5)
        {
            let wordData = wordDataParser.getLearnWord()
            wordDatas.removeLast()
            wordDatas.insert(wordData, at: 0)
            layoutWordPage()
            scrollView.contentOffset.x += scrollViewSize.width
        }
    }
}
