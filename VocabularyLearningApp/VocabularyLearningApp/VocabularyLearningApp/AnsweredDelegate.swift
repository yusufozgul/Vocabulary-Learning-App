//
//  AnsweredDelegate.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 27.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

protocol AnsweredDelegate: class // Butona tıklandığında veri taşımada görev alan interface.
{
    func selectAnswer(selected: Int)
}
