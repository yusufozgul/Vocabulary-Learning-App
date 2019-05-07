//
//  AddNewWordVC.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

class AddNewWordVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
//  View elemanları
    @IBOutlet weak var wordTextFiled: UITextField!
    @IBOutlet weak var wordTranslate: UITextField!
    @IBOutlet weak var wordDescription: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addButtonLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField! 
    
    let categoryPickerView = UIPickerView() // Kategori seçici
    let categories = [NSLocalizedString("CATEGORY_BUTTON", comment: ""),"İsim","Fiil","Sıfat", "Zamir","Zarf","Edat","Bağlaç"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        View ayarlamaları
        
        navigationItem.title = NSLocalizedString("ADD_WORD_TITLE", comment: "")
        wordTextFiled.placeholder = NSLocalizedString("WORD_TEXTFILED_PLACEHOLDER", comment: "")
        wordTranslate.placeholder = NSLocalizedString("WORD_TRANSLATE_TEXTFILED_PLACEHOLDER", comment: "")
        wordDescription.textColor = .lightGray
        wordDescription.text = NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "")
        addButtonLabel.text = NSLocalizedString("ADD_BUTTON", comment: "")
        categoryTextField.placeholder = NSLocalizedString("CATEGORY_BUTTON", comment: "")
        wordDescription.layer.cornerRadius = 6
        createPickerView()
        
//        Bir kelime eklendiğinde işlem sonucu ekranda gösterilir.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "FireBaseMessage"), object: nil, queue: .main) { (notification) in
            let firebaseResultAlert: UIAlertController
            if String(describing: notification.object!) == "1"
            {
                firebaseResultAlert = UIAlertController(title: NSLocalizedString("FIREBASE_SUCCES_TITLE", comment: ""), message: NSLocalizedString("FIREBASE_SUCCES", comment: ""), preferredStyle: .alert)
            }
            else
            {
                firebaseResultAlert = UIAlertController(title: NSLocalizedString("FIREBASE_ALERT_TITLE", comment: ""), message: String(describing: notification.object!), preferredStyle: .alert)
            }
            let alertButton = UIAlertAction(title: NSLocalizedString("OKAY", comment: ""), style: .cancel, handler: nil)
            firebaseResultAlert.addAction(alertButton)
            self.present(firebaseResultAlert, animated: true, completion: nil)
            self.addButtonLabel.text = NSLocalizedString("ADD_BUTTON", comment: "")
        }
    }
    func createPickerView() // Kategori seçim ekranı
    {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.delegate?.pickerView?(categoryPickerView, didSelectRow: 0, inComponent: 0)
        categoryTextField.inputView = categoryPickerView
    }
    func addWord() // Girilen kelime verilerini alıp model'e iletiyor. Eğer veriler boş ise hata mesajı çıkartıyor.
    {
        var wordData: WordData = WordData(word: "", translate: "", sentence: "", category: "", uid: "")
        if !wordTextFiled.text!.isEmpty && !wordTranslate.text!.isEmpty && wordDescription.text != NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "") && !categoryTextField.text!.isEmpty
        {
            let addWord: AddNewWordProtocol = AddNewWord()
            wordData.word = wordTextFiled.text!
            wordData.translate = wordTranslate.text!
            wordData.category = categoryTextField.text!
            wordData.sentence = wordDescription.text!
            addWord.AddNewWord(data: wordData)
            
            wordTextFiled.text = ""
            wordTranslate.text = ""
            wordDescription.text = ""
            categoryTextField.text = ""
            categoryPickerView.selectedRow(inComponent: 0)
            wordDescription.text = NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "")
            wordDescription.textColor = .lightGray
            view.endEditing(true)
            addButtonLabel.text = NSLocalizedString("PLEASE_WAIT", comment: "")
        }
        else
        {
            let emptyAlert = UIAlertController(title: NSLocalizedString("EMPTY_ALERT_TITLE", comment: ""), message: NSLocalizedString("EMPTY_ALERT_MESSAGE", comment: ""), preferredStyle: .alert)
            let emptyAlertButton = UIAlertAction(title: NSLocalizedString("OKAY", comment: ""), style: .cancel, handler: nil)
            emptyAlert.addAction(emptyAlertButton)
            present(emptyAlert, animated: true, completion: nil)
        }
    }
    @IBAction func addButton(_ sender: Any)
    {
        addWord()
    }
    @IBAction func infoButton(_ sender: Any) // Kelime kategori detayları bilgilendirmesi
    {
        let emptyAlert = UIAlertController(title: NSLocalizedString("INFO_TITLE", comment: ""), message: NSLocalizedString("WORD_INFO", comment: ""), preferredStyle: .alert)
        let emptyAlertButton = UIAlertAction(title: NSLocalizedString("OKAY", comment: ""), style: .cancel, handler: nil)
        emptyAlert.addAction(emptyAlertButton)
        present(emptyAlert, animated: true, completion: nil)
    }
}

extension AddNewWordVC: UITextViewDelegate
{
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if wordDescription.text.isEmpty
        {
            wordDescription.text = NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "")
            wordDescription.textColor = .lightText
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        wordDescription.text = ""
        wordDescription.textColor = .black
    }
}
extension AddNewWordVC // Kategori seçici ayarları
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if row == 0
        {
            categoryTextField.text = ""
        }
        else
        {
            categoryTextField.text =  categories[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 150.0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label:UILabel
        if let category = view as? UILabel{
            label = category
        }
        else{
            label = UILabel()
        }
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 17)
        label.text = categories[row]
        return label
    }
}
