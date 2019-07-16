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
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var miniImage: UIImageView!
    @IBOutlet weak var vcTitle: UILabel!
    
    let wordPageScrollView: UIScrollView = UIScrollView() // kaydırılabilir sayfamız
    let blurredEffectView = UIVisualEffectView() // loading view'u
    let authdata = CurrentUserData.userData
    
    
    var wordPages: [WordPage] = { () -> [WordPage] in // ScrollView sayfalarının oluşturulmasu
        let wordPage0: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Previous Page
        let wordPage1: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Current Page
        let wordPage2: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Next Page
        return [wordPage0, wordPage1, wordPage2] }()
    
    var wordDatas: [WordPageData] = [] // sayfalardaki verilerimiz
    let wordDataParser = LearnWordParser.parser // Api'daki kelimeyi işleyip veren static sınıf
    var dayCorrectAnswer: [String] = [] // günlük bilinen doğru kelimeler
    var dayWrongAnswer: [String] = [] // günlük yanlış bilinen kelimeler
    
    var isDragging = false // kaydırma kontrolü
    var scrollViewSize: CGSize = .zero
    
    lazy var authBoard: BLTNItemManager = {
        let rootItem: BLTNItem = BulletinDataSource().splashBoard()
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    var accountBoard: BLTNItemManager = BLTNItemManager(rootItem: BulletinDataSource().accountBoard())

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let fetchSolvedWords = FecthSolvedWords()
        fetchSolvedWords.delegate = self
        fetchSolvedWords.fetchSolvedWord()
        wordDataParser.fetchedDelegate = self
        
//        İnternet Bağlantı Kontrolü
        networkCheck(isConnected: Reachability.isConnectedToNetwork())
        
//        View ayarlamaları
        vcTitle.text = NSLocalizedString("LEARN_VC_TITLE", comment: "")
        wordPageScrollView.delegate = self
        wordPageScrollView.isPagingEnabled = true
        wordPageScrollView.showsHorizontalScrollIndicator = false
        wordPageScrollView.showsVerticalScrollIndicator = false
        questionView.addSubview(wordPageScrollView)
        
//        Verilerin çekilmesi, parse edilmesi ve local verilerin çekilmesi
        wordDataParser.fetchedLearnWord()
        prepareScrollView()
        loadData()
        
//        Giriş yapılıp yapılmadığının kontrolü. Giriş yapılmamışsa yönlendiriliyor.
        if !authdata.isSign
        { showBulletin() }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        loadData()
        loadingView()
        
        questionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        questionView.layer.cornerRadius = 30
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
        let loader = LoadData()
        dayCorrectAnswer.removeAll()
        dayWrongAnswer.removeAll()
        dayCorrectAnswer = loader.loadCorrectAnswers()
        dayWrongAnswer = loader.loadWrongAnswers()
    }
    internal func prepareScrollView() // ScrollView'un ayarlanması ve kelimelerin yerleştirilmesi
    {
        var wordData = wordDataParser.getLearnWord() // random olarak bir sayfa için veri alma sınıfı.
        for page in wordPages
        {
            page.frame.size.width = view.frame.width / 1.2
            page.frame.size.height = view.frame.height / 1.5
        }
        wordDatas.removeAll()
        
        for i in 0 ..< 3 // oluşturulan 3 sayfa için ayrı ayrı ayarı yapılır.
        {
            wordData = wordDataParser.getLearnWord()
            wordDatas.append(wordData)
            wordPageScrollView.addSubview(wordPages[i])
        }
        scrollViewSize = (wordPages.first?.frame.size)!
        wordPageScrollView.frame.size = scrollViewSize
        wordPageScrollView.frame = CGRect(x: questionView.center.x - (wordPageScrollView.frame.width / 2),
                                          y: 30,
                                          width: wordPageScrollView.frame.width,
                                          height: wordPageScrollView.frame.height)
        
        wordPageScrollView.contentSize = CGSize(width: scrollViewSize.width * 3,
                                                height: scrollViewSize.height)
        wordPageScrollView.contentOffset = CGPoint(x: scrollViewSize.width, y: 0)
        layoutWordPage()
    }
    internal func layoutWordPage() // ScrollView'a kelimelerin verilmesi ve düzen ayarları
    {
        var index = 0
        for page in wordPages
        {
            let wordData = wordDatas[index]
            page.delegate = self
            page.buttonUnlock()
            
//            Sayfaların oluşturulmasında varsayılan ayarları yapılıyor
            page.answerBox1Image.image = UIImage(named: "answerA")
            page.answerBox2Image.image = UIImage(named: "answerB")
            page.answerBox3Image.image = UIImage(named: "answerC")
            page.answerBox4Image.image = UIImage(named: "answerD")
            
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
    @IBAction func accountButton(_ sender: Any)
    {
        accountBoard = BLTNItemManager(rootItem: BulletinDataSource().accountBoard())
        accountBoard.backgroundViewStyle = .dimmed
        accountBoard.showBulletin(above: self)
    }
}
extension LearnVC: SolvedWordDelegate
{
    func getSolved(solvedArray: [String])
    {
        wordDataParser.solvedWords = solvedArray
    }
}
extension LearnVC: FetchedDelegate
{
    func fetched()
    {
        prepareScrollView()
        loadingView()
//        counterStack.isHidden = false
        correctCounter.text = String(describing: self.dayCorrectAnswer.count)
        wrongCounter.text =  String(describing: self.dayWrongAnswer.count)
    }
}
