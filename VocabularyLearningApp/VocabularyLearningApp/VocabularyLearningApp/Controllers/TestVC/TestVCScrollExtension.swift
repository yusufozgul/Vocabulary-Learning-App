//
//  TestVCScrollExtension.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 15.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

// kaydırma işlemleri
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
    func goNextPage(delay: TimeInterval) // Otomatik sayfa geçiş fonksiyonu, gönderilen zamana göre geçiş yapılıyor.
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay)
        {
            let wordData = self.wordDataParser.getTestWord()
            self.wordDataArray.remove(at: 0)
            self.wordDataArray.append(wordData)
            self.layoutWordPage()
            self.wordPageScrollView.scrollToPage(index: 2, animated: true)
        }
    }
}

