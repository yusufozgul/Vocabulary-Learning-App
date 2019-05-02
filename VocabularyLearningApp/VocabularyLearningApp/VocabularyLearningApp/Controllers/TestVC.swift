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
    let wordPageScroll: UIScrollView = UIScrollView() // kaydırılabilir sayfamız
    let blurredEffectView = UIVisualEffectView() // loading view'u
    let wordDataParser = WordDataParser.parser // Api'daki kelimeyi işleyip veren static sınıf
    var wordDatas: [WordTestPageData] = [] // sayfalardaki verilerimiz
    
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
        wordPageScroll.delegate = self
        wordPageScroll.isPagingEnabled = true
        wordPageScroll.showsHorizontalScrollIndicator = false
        wordPageScroll.showsVerticalScrollIndicator = false
        view.addSubview(wordPageScroll)
        
//        Verilerin çekilmesi, parse edilmesi ve local verilerin çekilmesi
        wordDataParser.fetchedTestWord()
        prepareScrollView()
        
//        Kelime geldiği zaman bilgi mesajını yakalayıp işlem yapımı
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "FetchTestWords"), object: nil, queue: OperationQueue.main, using: { _ in
            self.prepareScrollView()
            self.loadingView()
        })
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        loadingView()
    }
    internal func loadingView() // Loading sayfası gösterimi ve kontrolü
    {
        if wordDataParser.getTestArrayCount() == 0
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
    internal func prepareScrollView() // ScrollView'un ayarlanması ve kelimelerin yerleştirilmesi
    {
        var wordData = wordDataParser.getTestWord()
        for page in wordPages
        {
            page.frame.size.width = view.frame.width / 1.2
            page.frame.size.height = view.frame.height / 1.5
        }
        wordDatas.removeAll()
        
        for i in 0 ..< 3
        {
            wordData = wordDataParser.getTestWord()
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
    internal func layoutPages() // ScrollView'a kelimelerin verilmesi
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
            
//            Kelimeleri ve şıkları yerleştirme
            page.wordLabel.text = wordData.wordPage.wordInfo.word
            page.wordCategoryLabel.text = wordData.wordPage.wordInfo.category
            page.wordSentence.text = wordData.wordPage.wordInfo.sentence
            
            page.answerBox1Label.text = wordData.wordPage.option1
            page.answerBox2Label.text = wordData.wordPage.option2
            page.answerBox3Label.text = wordData.wordPage.option3
            page.answerBox4Label.text = wordData.wordPage.option4
            
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
        if !isDragging {
            return
        }
        let offsetX = scrollView.contentOffset.x
        
        if (offsetX > scrollView.frame.size.width * 1.5)
        {
            let wordData = wordDataParser.getTestWord()
            wordDatas.remove(at: 0)
            wordDatas.append(wordData)
            layoutPages()
            scrollView.contentOffset.x -= scrollViewSize.width
        }
        
        if (offsetX < scrollView.frame.size.width * 0.5)
        {
            let wordData = wordDataParser.getTestWord()
            wordDatas.removeLast()
            wordDatas.insert(wordData, at: 0)
            layoutPages()
            scrollView.contentOffset.x += scrollViewSize.width
        }
    }
    func goNextPage(delay: TimeInterval) // Otomatik sayfa geçiş fonksiyonu, gönderilen zamana göre geçiş yapılıyor.
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay)
        {
            let wordData = self.wordDataParser.getTestWord()
            self.wordDatas.remove(at: 0)
            self.wordDatas.append(wordData)
            self.layoutPages()
            self.wordPageScroll.scrollToPage(index: 2, animated: true)
        }
    }
}
