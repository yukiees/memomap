//
//  MapViewController.swift
//  memomap
//
//  Created by 水谷彩葉 on 2020/11/27.
//  Copyright © 2020 Mizutani Mozuku. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var pointAno = MKPointAnnotation()
    var locationManager: CLLocationManager!
    var genre = "タイトル"
    var subTitle = "メモ"
    var pinBool: Bool = false
    var radiusBool: Bool = false
    var radius = Int()
    var number = Int()
    var loadLatitude = [Double]()
    var loadLongitude = [Double]()
    var loadTitle = [String]()
    var loadMemo = [String]()
    var loaded: Bool = false
    
    // ピンを生成
    let myPin = MKPointAnnotation()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //ロケーションマネージャーのセットアップ
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //mapViewDelegate
        mapView.delegate = self
        
        //中心点の設定
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        
        //縮尺の設計
        let mySpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: mySpan)
        
        //regionの追加
        mapView.region = myRegion
        
        //現在地追従
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        //viewに表示
        self.view.addSubview(mapView)
        
        //長押し機能
        let myLongPress: UILongPressGestureRecognizer =  UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(MapViewController.recognizeLongPress(sender:)))
        
        //myMapに長押し機能を追加
        if pinBool == true {
            mapView.addGestureRecognizer(myLongPress)
        }
        
        
    }
    
    
    @objc func recognizeLongPress(sender: UILongPressGestureRecognizer) {
        
        
        if pinBool == true {
            
            
            // 長押しした地点の座標を取得.
            let location = sender.location(in: mapView)
            
            // locationをCLLocationCoordinate2Dに変換.
            let myCoordinate: CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
            
            // 座標を設定.
            myPin.coordinate = myCoordinate
            
            // タイトルを設定.
            myPin.title = genre
            
            // サブタイトルを設定.
            myPin.subtitle = subTitle
            
            
            if loaded == false{
                // MapViewにピンを追加.
                mapView.addAnnotation(myPin)
                print("こっちはきてるで！")
            }else if loaded == true{
                
                print("ここじゃないみたい")
                for i in 0..<loadLatitude.count{
                    addAnnotation(latitude: loadLatitude[i],longitude: loadLongitude[i],title: loadTitle[i],subtitle: loadMemo[i])
                }
                loaded = false
            }
            
            // 長押しの最中に何度もピンを生成しないようにする.
            if sender.state != UIGestureRecognizer.State.began {
                return
            }
            
            
            print(myPin.coordinate.latitude)
            print(myPin.coordinate.longitude)
            //ピンを追加したらそれ以上ピンを打てないようにする
            pinBool = false
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let myPinIdentifier = "PinAnnotationIdentifier"
        //ピンの生成
        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
        
        //ピンの登場時のアニメーション
        myPinView.animatesDrop = true
        
        //コールアウト(吹き出し)の表示
        myPinView.canShowCallout = true
        
        //左ボタンをアノテーションビューに追加する。
        let button = UIButton()
        button.frame = CGRect(x: 0,y: 0,width: 40,height: 40)
        button.setTitle("色", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 15/255, green: 110/255, blue: 164/255, alpha: 1)
        myPinView.leftCalloutAccessoryView = button
        
        //annnotationの設定
        myPinView.annotation = annotation
        
        let btn = UIButton(type: .detailDisclosure)
        
        btn.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
        myPinView.rightCalloutAccessoryView = btn
        
        return myPinView
    }
    
    
    //吹き出しアクササリー押下時の呼び出しメソッド
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if(control == view.leftCalloutAccessoryView) {
            
            //左のボタンが押された場合はピンの色をランダムに変更する。
            if let pinView = view as? MKPinAnnotationView {
                pinView.pinTintColor = UIColor(red: CGFloat(drand48()),
                                               green: CGFloat(drand48()),
                                               blue: CGFloat(drand48()),
                                               alpha: 1.0)
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        //許可されていない場合
        case .notDetermined:
            //許可を求める
            manager.requestWhenInUseAuthorization()
        //拒否されている場合
        case .denied, .restricted:
            break
        //許可されている場合
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
            
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next"{
            let preserveVC = segue.destination as! PreserveViewController
            preserveVC.latitude = self.myPin.coordinate.latitude
            preserveVC.longitude = self.myPin.coordinate.longitude
        }
        
    }
    
    @objc func buttonEvent(_ sender: UIButton) {
        self.performSegue(withIdentifier: "next", sender: nil)
    }
    
    
    @IBAction func mapViewDidTap(sender: UITapGestureRecognizer) {
        //長押し機能
        let myLongPress =  UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(MapViewController.recognizeLongPress(sender:)))
        
        if sender.state == UIGestureRecognizer.State.ended {
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            //numaberをもとに半径を指定
            if number == 1{
                radius = 400
            }else if number == 2{
                radius = 800
            }else if number == 3{
                radius = 1200
            }else if number == 4{
                radius = 1600
            }
            
            print(number)
            
            let circle = MKCircle(center: center, radius: CLLocationDistance(radius)) //半径100m　1分＝80m
            
            //myMapに徒歩圏内機能を追加
            if radiusBool == true {
                mapView.addOverlay(circle)
                radiusBool = false
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        circleRenderer.strokeColor = UIColor(red: 15/255, green: 110/255, blue: 164/255, alpha: 1)
        circleRenderer.fillColor = UIColor(red: 0/255, green: 174/255, blue: 192/255, alpha: 0.2)
        circleRenderer.lineWidth = 2.0
        return circleRenderer
    }
    
    
    //検索用メソッド
    func addAnnotation( latitude: CLLocationDegrees,longitude: CLLocationDegrees,title:String, subtitle:String) {
        
        // ピンの生成
        let annotation = MKPointAnnotation()
        
        // 緯度経度を指定
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        // タイトル、サブタイトルを設定
        annotation.title = title
        annotation.subtitle = subtitle
        
        let btn = UIButton(type: .detailDisclosure)
        
        btn.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
        
        
        // mapViewに追加
        mapView.addAnnotation(annotation)
    }
    
}






