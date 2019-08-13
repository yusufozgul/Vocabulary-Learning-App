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
    @IBOutlet weak var vcTitle: UILabel!
    
    let addWordModel = AddNewWord()
    let messageService: MessageViewerProtocol = MessageViewer.messageViewer
    
    let categoryPickerView = UIPickerView() // Kategori seçici
    let wordCategories = [NSLocalizedString("CATEGORY_BUTTON", comment: ""),"İsim","Fiil","Sıfat", "Zamir","Zarf","Edat","Bağlaç"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        View ayarlamaları
        
        vcTitle.text = NSLocalizedString("ADD_WORD_TITLE", comment: "")
        wordTextFiled.placeholder = NSLocalizedString("WORD_TEXTFILED_PLACEHOLDER", comment: "")
        wordTranslate.placeholder = NSLocalizedString("WORD_TRANSLATE_TEXTFILED_PLACEHOLDER", comment: "")
        wordDescription.textColor = .lightGray
        wordDescription.text = NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "")
        wordDescription.delegate = self
        addButtonLabel.text = NSLocalizedString("ADD_BUTTON", comment: "")
        categoryTextField.placeholder = NSLocalizedString("CATEGORY_BUTTON", comment: "")
        wordDescription.layer.cornerRadius = 6
        createPickerView()
        
        addWordModel.delegate = self
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
            addButton.isEnabled = false
            wordData.word = wordTextFiled.text!.capitalizingFirstLetter()
            wordData.translate = wordTranslate.text!.capitalizingFirstLetter()
            wordData.category = categoryTextField.text!.capitalizingFirstLetter()
            wordData.sentence = wordDescription.text!.capitalizingFirstLetter()
            addWordModel.AddNewWord(data: wordData)
            addButtonLabel.text = NSLocalizedString("PLEASE_WAIT", comment: "")
        }
        else
        {
            messageService.failMessage(title: NSLocalizedString("EMPTY_ALERT_TITLE", comment: ""), body: NSLocalizedString("EMPTY_ALERT_MESSAGE", comment: ""))
        }
    }
    @IBAction func addButton(_ sender: Any)
    { addWord() }
    
    @IBAction func infoButton(_ sender: Any) // Kelime kategori detayları bilgilendirmesi
    {
        messageService.infoView(title: NSLocalizedString("INFO_TITLE", comment: ""), body: NSLocalizedString("WORD_INFO", comment: ""))
    }
}

extension AddNewWordVC: AddWordDelegate
{
    func addWordResult(result: Bool) // Kelime ekleme işleminin sonucuna göre ayarların yapılması
    {
        switch result {
        case true:
            addButton.isEnabled = true
            wordTextFiled.text = ""
            wordTranslate.text = ""
            wordDescription.text = ""
            categoryTextField.text = ""
            categoryPickerView.selectedRow(inComponent: 0)
            wordDescription.text = NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "")
            wordDescription.textColor = .lightGray
            view.endEditing(true)
            self.addButtonLabel.text = NSLocalizedString("ADD_BUTTON", comment: "")
        default:
            addButton.isEnabled = true
            break
        }
    }
}

extension AddNewWordVC: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        textView.text = ""
        textView.textColor = .black
    }
}
extension AddNewWordVC // Kategori seçici ayarları
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    { return wordCategories.count }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if row == 0
        { categoryTextField.text = "" }
        else
        { categoryTextField.text =  wordCategories[row] }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    { return 150.0 }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        var label:UILabel
        if let category = view as? UILabel{ label = category }
        else
        { label = UILabel() }
        
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.text = wordCategories[row]
        return label
    }
}
