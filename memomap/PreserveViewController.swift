//
//  PreserveViewController.swift
//  memomap
//
//  Created by 水谷彩葉 on 2020/11/27.
//  Copyright © 2020 Mizutani Mozuku. All rights reserved.
//

import UIKit
import Accounts

class PreserveViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    
    //UserDefaultsの内容
    var saveMemo: UserDefaults = UserDefaults.standard
    var memoArray :[String] = []
    
    //ここまで
    var pickerView1 = UIPickerView()
    var pickerView2 = UIPickerView()
    var data1 = ["飲食店","観光地","お店","その他"]
    var data2 = ["和食","洋食","中華","イタリアン","フレンチ","パン・サンドイッチ","弁当","焼肉","カレー","カフェ・スイーツ","その他"]
    var data3 = ["歴史・文化","アウトドア","景観","宿泊","温泉","公園","その他"]
    var data4 = ["コンビニ","スーパー","ドラッグストア","書店","銀行","カラオケ","その他"]
    var data5 = ["駐車場","その他"]
    var word1 = String()
    var word2 = String()
    var latitude = Double()
    var longitude = Double()
    
    let image0 = UIImage(named: "mymap0.png")!
    let image1 = UIImage(named: "mymap.png")!
    let image2 = UIImage(named: "sharemap0.png")!
    let image3 = UIImage(named: "sharemap.png")!
    
    
    @IBOutlet weak var mymapbutton: UIButton!
    @IBOutlet weak var sharemapbutton: UIButton!
    
    @IBAction func mymapButtonTapped(_ sender: Any){
        if mymapbutton.imageView?.image == image0 {
            mymapbutton.setImage(image1, for: .normal)
        }else if mymapbutton.imageView?.image == image1{
            mymapbutton.setImage(image0, for: .normal)
        }
    }
    
    @IBAction func sharemapButtonTapped(_ sender: Any){
        
        if sharemapbutton.imageView?.image == image3{
            shareMap()
        }else{
            //何もしない
        }
    }
    
    
    
    @IBOutlet weak var preservebutton: UIButton!
    @IBOutlet weak var delatebutton: UIButton!
    
    @IBAction func preserveButtonTapped() {
        
        if latitude == 0.00{
            // mapViewControllerの取得
            if let mapVC = presentingViewController as? MapViewController{
                //MapViewControllerのgenreにtextfieldの値を代入
                mapVC.genre = textField3.text!
                print(textField3.text as Any)
                print(mapVC.genre)
                
                //MapViewControllerのsubtitleにtextfieldの値を代入
                mapVC.subTitle = textField4.text!
                print(textField4.text as Any)
                print(mapVC.subTitle)
                
                //MapViewControllerのpinBoolにtrueを代入
                mapVC.pinBool = true
                
            }
            
            if textField1.text == "" || textField2.text == "" || textField3.text == "" || textField4.text == ""{
                alert()
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            
            preserve()
            
        }else{
            //値が渡されて保存するとき
            //保存するメソッド(後ほど)
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func delateBuuttonTapped() {
        // mapViewControllerの取得
        if let mapVC = presentingViewController as? MapViewController{
            //ピンを削除
            mapVC.mapView.removeAnnotation(mapVC.myPin)
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPickerView()
        textEnabled()
        
        //画像を設定
        mymapbutton.setImage(image0, for: .normal)
        sharemapbutton.setImage(image2, for: .normal)
        
        
        //角丸
        preservebutton.layer.cornerRadius = 25.0
        delatebutton.layer.cornerRadius = 25.0
        
        if latitude != 0.00 {
            print(latitude)
            sharemapbutton.setImage(image3, for: .normal)
            delatebutton.isHidden = false
            preservebutton.setTitle("保存する", for: .normal)
        }else{
            sharemapbutton.setImage(image2, for: .normal)
            delatebutton.isHidden = true
            preservebutton.setTitle("ピンを置く", for: .normal)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if latitude == 0.00{
            
        }else{
            memoArray = saveMemo.object(forKey: "memo") as! [String]
            
            textField1.text = memoArray[0]
            textField2.text = memoArray[1]
            textField3.text = memoArray[2]
            textField4.text = memoArray[3]
            
        }
        
    }
    
    
    
    @objc func keyboardWillShow(notifiction :NSNotification){
        if let keyboardSize = (notifiction.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            //キーボードの高さを分Viewを上に移動する
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    //Viewの位置を戻す
    @objc func keyboardWillHide(){
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dissmissKeyboard(){
        self.view.endEditing(true)
    }
    
    
    
    func createPickerView() {
        
        //PickerView1
        pickerView1.delegate = self
        textField1.inputView = pickerView1
        
        //PickerView2
        pickerView2.delegate = self
        textField2.inputView = pickerView2
        
        //toolbar1
        let toolbar1 = UIToolbar()
        toolbar1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PreserveViewController.doneButton1))
        toolbar1.setItems([doneButtonItem1], animated: true)
        textField1.inputAccessoryView = toolbar1
        
        // toolbar2
        let toolbar2 = UIToolbar()
        toolbar2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let doneButtonItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PreserveViewController.doneButton2))
        toolbar2.setItems([doneButtonItem2], animated: true)
        textField2.inputAccessoryView = toolbar2
        
    }
    
    
    @objc func doneButton1(){
        textField1.endEditing(true)
        textField1.text = word1
        textField2.text = ""
        textEnabled()
    }
    
    
    @objc func doneButton2() {
        textField2.endEditing(true)
        textField2.text = word2
        textEnabled()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField1.endEditing(true)
        textField2.endEditing(true)
        textField3.endEditing(true)
        textField4.endEditing(true)
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
        }else if pickerView == pickerView2{
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
    
    func textEnabled(){
        textField3.isEnabled = false
        textField4.isEnabled = false
        if textField1.text != "" && textField2.text != ""{
            textField3.isEnabled = true
            textField4.isEnabled = true
        }
    }
    
    func shareMap(){
        let address = String(format: "%f,%f", latitude, longitude)
        //テストlat,lot = 36.030354, 138.120793
        
        let urlString = "http://maps.apple.com/?address=\(address)"
        //let urlString = "myapplication://first/?param1=\(latitude)&param2=\(longitude)"
        print(address)
        //マップの種類の変更可(&t = m or k or h or r)
        
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = NSURL(string: encodedUrl)!
        
        //UIApplication.shared.open(url as URL, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: true], completionHandler: nil)
        
        //UIApplication.shared.open(URL(string: encodedUrl)!, options: [:], completionHandler: nil)
        print(latitude)
        print(longitude)
        print(urlString)
        
        //ここからシェア内容
        let shareText = "ここがすごい！"
        let shareWebsite = url
        //let shareImage = UIImage(named: "ムック5.png")!
        
        let activityItems = [shareText, shareWebsite] as [Any]
        //shareImageの追加！
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
        
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
    
    func preserve(){
        memoArray.append(textField1.text!)
        memoArray.append(textField2.text!)
        memoArray.append(textField3.text!)
        memoArray.append(textField4.text!)
        print(memoArray)

        saveMemo.setValue(memoArray, forKey: "memo")
    }
    
}

