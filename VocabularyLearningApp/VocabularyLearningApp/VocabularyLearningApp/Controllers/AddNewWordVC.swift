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

    @IBOutlet weak var wordTextFiled: UITextField!
    @IBOutlet weak var wordTranslate: UITextField!
    @IBOutlet weak var wordDescription: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addButtonLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    
    let categoryPickerView = UIPickerView()
    let categories = [NSLocalizedString("CATEGORY_BUTTON", comment: ""),"İsim","Fiil","Sıfat", "Zamir","Zarf","Bağlaç","Ünlem"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("ADD_WORD_TITLE", comment: "")
        wordTextFiled.placeholder = NSLocalizedString("WORD_TEXTFILED_PLACEHOLDER", comment: "")
        wordTranslate.placeholder = NSLocalizedString("WORD_TRANSLATE_TEXTFILED_PLACEHOLDER", comment: "")
        wordDescription.textColor = .lightGray
        wordDescription.text = NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "")
        addButtonLabel.text = NSLocalizedString("ADD_BUTTON", comment: "")
        categoryTextField.placeholder = NSLocalizedString("CATEGORY_BUTTON", comment: "")
        createPickerView()
        createToolbar()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "FireBaseMessage"), object: nil, queue: .main) { (notification) in
            let emptyAlert: UIAlertController
            
            if String(describing: notification.object!) == "1"
            {
                emptyAlert = UIAlertController(title: NSLocalizedString("FIREBASE_SUCCES_TITLE", comment: ""), message: NSLocalizedString("FIREBASE_SUCCES", comment: ""), preferredStyle: .alert)
            }
            else
            {
                emptyAlert = UIAlertController(title: NSLocalizedString("FIREBASE_ALERT_TITLE", comment: ""), message: String(describing: notification.object!), preferredStyle: .alert)
            }
            let emptyAlertButton = UIAlertAction(title: NSLocalizedString("OKAY", comment: ""), style: .cancel, handler: nil)
            emptyAlert.addAction(emptyAlertButton)
            self.present(emptyAlert, animated: true, completion: nil)
            self.addButtonLabel.text = NSLocalizedString("ADD_BUTTON", comment: "")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationItem.largeTitleDisplayMode = .always
    }
    func createPickerView()
    {
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.delegate?.pickerView?(categoryPickerView, didSelectRow: 0, inComponent: 0)
        categoryTextField.inputView = categoryPickerView
    }
    func createToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.red
        toolbar.backgroundColor = UIColor.blue
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePickerView))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
    }
    @objc func closePickerView()
    {
        view.endEditing(true)
    }
    func addWord()
    {
        var wordData: WordData = WordData(word: "", translate: "", sentence: "", category: "")
        if !wordTextFiled.text!.isEmpty && !wordTranslate.text!.isEmpty && wordDescription.text != NSLocalizedString("WORD_DESC_TEXTVIEW_PLACEHOLDER", comment: "") && !categoryTextField.text!.isEmpty
        {
            wordData.word = wordTextFiled.text!
            wordData.translate = wordTranslate.text!
            wordData.category = categoryTextField.text!
            wordData.sentence = wordDescription.text!
            AddNewWord.init().AddNewWord(data: wordData)
            wordTextFiled.text = ""
            wordTranslate.text = ""
            wordDescription.text = ""
            categoryTextField.text = ""
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
    @IBAction func infoButton(_ sender: Any)
    {
        let emptyAlert = UIAlertController(title: NSLocalizedString("INFO_TITLE", comment: ""), message: """
Kelimenizin Türünden emin değilseniz aşağıdaki bilgilere göre girebilirsiniz.

• İsim (Ad): Canlı ve cansız varlıkları, duygu ve düşünceleri, durumları, bütün bunların birbiriyle ilgilerini karşılayan sözcüklerdir: kuş, ağaç, ağlama, düşünce, yargı, bilgi gibi.

• Sıfat (Önad): Adların niteliklerini, ne durumda olduklarını sayılarını, ölçülerini, gösteren, soran ya da belirten sözcüklerdir.

• Fiil (Eylem): Oluş, kılınış, durum gösteren sözcüklerdir.

• Zamir (Adıl): Adların yerini tutan, bu görevi yerine getirirken kişi, soru, gösterme ve belgisizlik kavramları da taşıyan sözcüklerdir.

• Zarf (Belirteç): Eylemlerin, sıfatların ya da görevce kendisi ne benzeyen sözcüklerin anlamlarını zaman bildirerek, güçlendirerek ya da kısıtlayarak etkileyen sözcüklerdir.

• Bağlaç: Eş görevli ya da birbiriyle ilgili sözcükleri, sözcük öbeklerini, özellikle cümleleri bağlamaya yarayan; bunlar arasında anlam ve biçim bakımından bağlantı kuran sözcüklerdir.

• Ünlem: Sevinme, kızma, korku, acıma, şaşma, gibi ansızın beliren duyguları yansıtmaya yarayan sözcüklerdir.
""", preferredStyle: .alert)
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
            wordDescription.textColor = .lightGray
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        wordDescription.text = ""
        wordDescription.textColor = .black
    }
}
extension AddNewWordVC
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
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
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
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
