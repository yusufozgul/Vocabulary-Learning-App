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
    let wordPageScrollView: UIScrollView = UIScrollView() // kaydırılabilir sayfamız
    var blurredEffectView = UIVisualEffectView() // loading view'u
    let blurEffect = UIBlurEffect(style: .extraLight)
    let loadingIndicator = UIActivityIndicatorView()
    let wordDataParser = TestWordParser.parser // Api'daki kelimeyi işleyip veren static sınıf
    var wordDataArray: [WordTestPageData] = [] // sayfalardaki verilerimiz
    
    var wordPages: [WordPage] = { () -> [WordPage] in // ScrollView sayfalarının oluşturulmasu
        let wordPage0: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Previous Page
        let wordPage1: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Current Page
        let wordPage2: WordPage = Bundle.main.loadNibNamed("WordPage", owner: self, options: nil)?.first as! WordPage // Next Page
        return [wordPage0, wordPage1, wordPage2] }()
    
    private var isDragging = false // kaydırma kontrolü
    private var scrollViewSize: CGSize = .zero
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        View ayarlamaları
        navigationItem.title = NSLocalizedString("TEST_VC_TITLE", comment: "")
        wordPageScrollView.delegate = self
        wordPageScrollView.isPagingEnabled = true
        wordPageScrollView.showsHorizontalScrollIndicator = false
        wordPageScrollView.showsVerticalScrollIndicator = false
        view.addSubview(wordPageScrollView)
        
//        Kelime geldiği zaman bilgi mesajını yakalayıp işlem yapımı
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "FetchTestWords"), object: nil, queue: OperationQueue.main, using: { _ in
            self.prepareScrollView()
            self.loadingView()
        })
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "FailAlert"), object: nil, queue: OperationQueue.main, using: { (alert) in
            self.showAlert(alert: alert.object as! String)
        })
    }
    override func viewWillAppear(_ animated: Bool)
    {
//        Verilerin çekilmesi, parse edilmesi ve local verilerin çekilmesi
        wordDataParser.fetchedTestWord()
        prepareScrollView()
        loadingView()
    }
    internal func loadingView() // Loading sayfası gösterimi ve kontrolü
    {
        if wordDataParser.getTestArrayCount() == 0
        {
            blurredEffectView.effect = blurEffect
            blurredEffectView.frame = view.frame
            loadingIndicator.style = .whiteLarge
            loadingIndicator.color = .black
            loadingIndicator.center = view.center
            loadingIndicator.startAnimating()
            blurredEffectView.contentView.addSubview(loadingIndicator)
            view.addSubview(blurredEffectView)
        }
        else
        {
            blurredEffectView.removeFromSuperview() // Kelime varsa Loading ekranı view'dan siliniyor.
        }
    }
    internal func showAlert(alert: String)
    {
        let emptyAlert = UIAlertController(title: NSLocalizedString("ALERT_TITLE", comment: ""), message: alert, preferredStyle: .alert)
        let emptyAlertButton = UIAlertAction(title: NSLocalizedString("OKAY", comment: ""), style: .cancel, handler: nil)
        emptyAlert.addAction(emptyAlertButton)
        present(emptyAlert, animated: true, completion: nil)
    }
    internal func prepareScrollView() // ScrollView'un ayarlanması ve kelimelerin yerleştirilmesi
    {
        var wordData = wordDataParser.getTestWord()
        for page in wordPages
        {
            page.frame.size.width = view.frame.width / 1.2
            page.frame.size.height = view.frame.height / 1.5
        }
        wordDataArray.removeAll()
        
        for i in 0 ..< 3
        {
            wordData = wordDataParser.getTestWord()
            wordDataArray.append(wordData)
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
            let wordData = wordDataArray[index]
            page.delegate = self
            
//            Sayfaların oluşturulmasında varsayılan ayarları yapılıyorç
            page.answerBox1Image.image = UIImage(named: "BoxBackground")
            page.answerBox2Image.image = UIImage(named: "BoxBackground")
            page.answerBox3Image.image = UIImage(named: "BoxBackground")
            page.answerBox4Image.image = UIImage(named: "BoxBackground")
            
//            Kelimeleri ve şıkları yerleştirme
            page.wordLabel.text = wordData.wordPage.wordInfo.word
            page.wordCategoryLabel.text = wordData.wordPage.wordInfo.category
            page.wordSentence.text = wordData.wordPage.wordInfo.sentence
            
            page.answerBox1Label.text = wordData.wordPage.option1
            page.answerBox2Label.text = wordData.wordPage.option2
            page.answerBox3Label.text = wordData.wordPage.option3
            page.answerBox4Label.text = wordData.wordPage.option4
            
            page.frame = CGRect(x: wordPageScrollView.frame.width * CGFloat(index),
                                y: 0,
                                width: wordPageScrollView.frame.width,
                                height: wordPageScrollView.frame.height)
            index += 1
        }
    }
}

extension TestVC: UIScrollViewDelegate
{
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // Kaydırma başladı
    {
        isDragging = true
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // Kaydırma sonlandırıldı
    {
        isDragging = false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) // kaydırma bitince kaydırma sonlandırılmışsa sayfa geçiş işlemleri yapılıyor
    {
        if !isDragging
        { return }
        
        let offsetX = scrollView.contentOffset.x
        
        if (offsetX > scrollView.frame.size.width * 1.5)
        {
            let wordData = wordDataParser.getTestWord()
            wordDataArray.remove(at: 0)
            wordDataArray.append(wordData)
            layoutWordPage()
            scrollView.contentOffset.x -= scrollViewSize.width
        }
        
        if (offsetX < scrollView.frame.size.width * 0.5)
        {
            let wordData = wordDataParser.getTestWord()
            wordDataArray.removeLast()
            wordDataArray.insert(wordData, at: 0)
            layoutWordPage()
            scrollView.contentOffset.x += scrollViewSize.width
        }
    }
}
