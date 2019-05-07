//
//  WordScrollViewPageProtocol.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 29.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
protocol WordScrollViewProtocol // Kelime kartı için interface
{
    func prepareScrollView()
    func layoutWordPage()
    func saveData(isKnown: Bool)
    func goNextPage(delay: TimeInterval)
}
