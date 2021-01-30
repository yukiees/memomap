//
//  SearchViewController.swift
//  memomap
//
//  Created by 水谷彩葉 on 2020/11/27.
//  Copyright © 2020 Mizutani Mozuku. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    
    var pickerView1 = UIPickerView()
    var pickerView2 = UIPickerView()
    var pickerView3 = UIPickerView()
    var data1 = ["飲食店","観光地","お店","その他"]
    var data2 = ["和食","洋食","中華","イタリアン","フレンチ","パン・サンドイッチ","弁当","焼肉","カレー","カフェ・スイーツ","その他"]
    var data3 = ["歴史・文化","アウトドア","景観","宿泊","温泉","公園","その他"]
    var data4 = ["コンビニ","スーパー","ドラッグストア","書店","銀行","カラオケ","その他"]
    var data5 = ["駐車場","その他"]
    var data6 = ["5分","10分","15分","30分"]
    var word1 = String()
    var word2 = String()
    var word3 = String()
    

    @IBOutlet weak var searchbutton: UIButton!
    
    @IBAction func searchButtonTapped() {
        let mapViewController = presentingViewController as! MapViewController
        //徒歩何分圏内かによってそれぞれnumberに判定値を代入
        if textField3.text == data6[0]{
            mapViewController.number = 1
        }else if textField3.text == data6[1]{
            mapViewController.number = 2
        }else if textField3.text == data6[2]{
            mapViewController.number = 3
        }else if textField3.text == data6[3]{
            mapViewController.number = 4
        }
        
        //MapViewControllerのradiusBoolにtureを代入
        mapViewController.radiusBool = true
        
        
        if textField1.text == "" || textField2.text == "" || textField3.text == ""{
            alert()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        
        //角丸
        searchbutton.layer.cornerRadius = 25.0
        
        // Do any additional setup after loading the view.
    }
    
    
    func createPickerView() {
        
        //PickerView1
        pickerView1.delegate = self
        textField1.inputView = pickerView1
        
        //PickerView2
        pickerView2.delegate = self
        textField2.inputView = pickerView2
        
        //PickerView3
        pickerView3.delegate = self
        textField3.inputView = pickerView3
        
        //toolbar1
        let toolbar1 = UIToolbar()
        toolbar1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton1))
        toolbar1.setItems([doneButtonItem1], animated: true)
        textField1.inputAccessoryView = toolbar1
        
        // toolbar2
        let toolbar2 = UIToolbar()
        toolbar2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton2))
        toolbar2.setItems([doneButtonItem2], animated: true)
        textField2.inputAccessoryView = toolbar2
        
        //toolbar3
        let toolbar3 = UIToolbar()
        toolbar3.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        //        let doneButtonItem3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PreserveViewController.doneButton3))
        let doneButtonItem3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton3))
        toolbar3.setItems([doneButtonItem3], animated: true)
        textField3.inputAccessoryView = toolbar3
        
    }
    
    
    @objc func doneButton1(){
        textField1.endEditing(true)
        textField1.text = word1
        textField2.text = ""
    }
    
    
    @objc func doneButton2() {
        textField2.endEditing(true)
        textField2.text = word2
    }
    
    
    @objc func doneButton3() {
        textField3.endEditing(true)
        textField3.text = word3
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField1.endEditing(true)
        textField2.endEditing(true)
        textField3.endEditing(true)
        //テキスト入力画面の外側をタップしたら編集が終了
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        //1画面に対するクルクル(PickerView)の数
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //候補の数
        if pickerView == pickerView1{
            return data1.count
        }else if pickerView == pickerView3{
            return data6.count
        }else {
            if textField1.text == data1[0]{
                return data2.count
                
            }else if textField1.text == data1[1]{
                return data3.count
                
            }else if textField1.text == data1[2]{
                return data4.count
                
            }else{
                return data5.count
            }
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1{
            return data1[row]
        }else if pickerView == pickerView3{
            return data6[row]
        }else {
            if textField1.text == data1[0]{
                return data2[row]
            }else if textField1.text == data1[1]{
                return data3[row]
            }else if textField1.text == data1[2]{
                return data4[row]
            }else if textField1.text == data1[3]{
                return data5[row]
            }else{
                return ""
            }
        }
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            if pickerView == pickerView1{
                word1 = data1[row]
            }else if pickerView == pickerView3{
                word3 = data6[row]
            }else{
                if textField1.text == data1[0]{
                    word2 = data2[row]
                }else if textField1.text == data1[1]{
                    word2 = data3[row]
                }else if textField1.text == data1[2]{
                    word2 =  data4[row]
                }else if textField1.text == data1[3]{
                    word2 =  data5[row]
                }else{
                    
                }
            }
        
    }
    
    func alert(){
        let alert = UIAlertController(title: "タイトル", message: "本文", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { action in
                    print("OK")
                }
            )
        )
        present(alert, animated: true, completion: nil)
        
    }

}



