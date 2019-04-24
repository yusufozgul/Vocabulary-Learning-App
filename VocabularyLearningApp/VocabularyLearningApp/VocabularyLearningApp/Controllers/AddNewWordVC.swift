//
//  AddNewWordVC.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

class AddNewWordVC: UIViewController
{

    @IBOutlet weak var wordTextFiled: UITextField!
    @IBOutlet weak var wordTranslate: UITextField!
    @IBOutlet weak var wordDescription: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addButtonLabel: UILabel!
//    @IBOutlet weak var categoryButton: UIButton!
//    @IBOutlet weak var categoryButtonLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("ADD_WORD_TITLE", comment: "")
        wordTextFiled.placeholder = NSLocalizedString("WORD_TEXTFILED_PLACEHOLDER", comment: "")
        wordTranslate.placeholder = NSLocalizedString("WORD_TRANSLATE_TEXTFILED_PLACEHOLDER", comment: "")
        wordDescription.textColor = .lightGray
        wordDescription.text = NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "")
        addButtonLabel.text = NSLocalizedString("ADD_BUTTON", comment: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationItem.largeTitleDisplayMode = .always
    }

    @IBAction func addButton(_ sender: Any)
    {
        var wordData: WordData = WordData(word: "", translate: "", sentence: "", category: "")
        if !wordTextFiled.text!.isEmpty && !wordTranslate.text!.isEmpty && wordDescription.text != NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "")
        {
            wordData.word = wordTextFiled.text!
            wordData.translate = wordTranslate.text!
            wordData.category = ""
            wordData.sentence = wordDescription.text!
            AddNewWord.init().AddNewWord(data: wordData)
            wordTextFiled.text = ""
            wordTranslate.text = ""
            wordDescription.text = ""
            view.endEditing(true)
        }
        else
        {
            let emptyAlert = UIAlertController(title: NSLocalizedString("EMPTY_ALERT_TITLE", comment: ""), message: NSLocalizedString("EMPTY_ALERT_MESSAGE", comment: ""), preferredStyle: .alert)
            let emptyAlertButton = UIAlertAction(title: NSLocalizedString("OKAY", comment: ""), style: .cancel, handler: nil)
            emptyAlert.addAction(emptyAlertButton)
            present(emptyAlert, animated: true, completion: nil)
        }
    }
    
}

extension AddNewWordVC: UITextViewDelegate
{
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if wordDescription.text.isEmpty
        {
            wordDescription.text = NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "")
            wordDescription.textColor = .lightGray
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        wordDescription.text = ""
        wordDescription.textColor = .black
    }
}
