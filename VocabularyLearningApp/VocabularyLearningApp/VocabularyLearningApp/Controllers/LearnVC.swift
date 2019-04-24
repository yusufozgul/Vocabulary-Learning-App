//
//  FirstViewController.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit
import BLTNBoard

class LearnVC: UIViewController {
    var bltnBoard = BLTNItemManager(rootItem: BulletinDataSource.splashBoard())

    override func viewDidLoad() {
        super.viewDidLoad()
        showBulletin()
        
        if let data: [String] = (UserDefaults.standard.object(forKey: "currentUser") as? [String])
        {
            print(data[0])
            print(data[1])
        }
    }

    func showBulletin()
    {
        bltnBoard.backgroundViewStyle = BLTNBackgroundViewStyle.dimmed
        bltnBoard.showBulletin(above: self)
    }

}

