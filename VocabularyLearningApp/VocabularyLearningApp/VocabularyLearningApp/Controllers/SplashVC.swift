//
//  SplashVC.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 14.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit
import paper_onboarding

class SplashVC: UIViewController
{

    @IBOutlet weak var splashView: PaperOnboarding!
    @IBOutlet weak var skipButton: UIButton!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "icon")!,
                           title: NSLocalizedString("SPLASH_TITLE", comment: ""),
                           description: NSLocalizedString("SPLASH_DESC", comment: ""),
                           pageIcon: UIImage(named: "logoPageIcon")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: .white,
                           descriptionColor: .white,
                           titleFont: UIFont.boldSystemFont(ofSize: 35),
                           descriptionFont: UIFont.systemFont(ofSize: 17.0)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "learn")!,
                           title: NSLocalizedString("SPLASH_LEARN_TITLE", comment: ""),
                           description: NSLocalizedString("SPLASH_LEARN_DESC", comment: ""),
                           pageIcon: UIImage(named: "learnPageIcon")!,
                           color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                           titleColor: .white,
                           descriptionColor: .white,
                           titleFont: UIFont.boldSystemFont(ofSize: 35),
                           descriptionFont: UIFont.systemFont(ofSize: 17.0)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "test")!,
                           title: NSLocalizedString("SPLASH_TEST_TITLE", comment: ""),
                           description: NSLocalizedString("SPLASH_TEST_DESC", comment: ""),
                           pageIcon: UIImage(named: "testPageIcon")!,
                           color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                           titleColor: .white,
                           descriptionColor: .white,
                           titleFont: UIFont.boldSystemFont(ofSize: 35),
                           descriptionFont: UIFont.systemFont(ofSize: 17.0)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "chart")!,
                           title: NSLocalizedString("SPLASH_CHART_TITLE", comment: ""),
                           description: NSLocalizedString("SPLASH_CHART_DESC", comment: ""),
                           pageIcon: UIImage(named: "chartPageIcon")!,
                           color: UIColor(red: 0.71, green: 0.30, blue: 0.27, alpha: 1.0),
                           titleColor: .white,
                           descriptionColor: .white,
                           titleFont: UIFont.boldSystemFont(ofSize: 35),
                           descriptionFont: UIFont.systemFont(ofSize: 17.0)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "add")!,
                           title: NSLocalizedString("SPLASH_ADD_TITLE", comment: ""),
                           description: NSLocalizedString("SPLASH_ADD_DESC", comment: ""),
                           pageIcon: UIImage(named: "addPageIcon")!,
                           color: UIColor(red: 0.47, green: 0.79, blue: 0.76, alpha: 1.0),
                           titleColor: .white,
                           descriptionColor: .white,
                           titleFont: UIFont.boldSystemFont(ofSize: 35),
                           descriptionFont: UIFont.systemFont(ofSize: 17.0))
    ]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupPaperOnboardingView()
        skipButton.isHidden = true
        skipButton.layer.cornerRadius = 5
    }

    private func setupPaperOnboardingView()
    {
        splashView.delegate = self
        splashView.dataSource = self
    }
    
    
    @IBAction func skipButton(_ sender: Any)
    {
        UserDefaults.standard.setValue(true, forKey: "isEntry")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "toMainApp", sender: nil)
    }
}
extension SplashVC: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return items.count
    }
}
extension SplashVC: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == onboardingItemsCount() - 1 ? false : true
    }
}
