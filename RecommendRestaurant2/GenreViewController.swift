//
//  GenreViewController.swift
//  RecommendRestaurant2
//
//  Created by 安井春輝 on 2017/06/27.
//  Copyright © 2017 haruki yasui. All rights reserved.
//

import UIKit
import MapKit


class GenreViewController: UIViewController, CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate {

    
    
//    UICollectionViewDataSource,UICollectionViewDelegate
    
    
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var longitudeLabel: UILabel!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    @IBOutlet weak var genreNavigation: UINavigationItem!
    

    
    
    
    
    
    //選択した行が何番目かを保存するための数字
    var selectedIndex = -1
    
    //グローバル変数を使うために定義
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //struct Itemのインスタンス作成
    var Items : [Item] = []
    
    
    var myLocationManager: CLLocationManager!
    
    var latitude:Double = 0
    
    var longitude:Double = 0

    var genrePictures:[String] =
        
        ["izakaya",
         "diningbar",
         "sousakuryouri",
         "wasyoku",
         "nihonnryouri",
         "suhsi",
         "syabusyabu",
         "udon",
         "yousyoku",
         "steak",
         "italian",
         "french",
         "pasta",
         "bistoro",
         "tyuka",
         "kanntouryouri",
         "shisenn",
         "shanhai",
         "pekinn",
         "yakiniku",
         "kannkokuryouri",
         "ajian",
         "thai",
         "indo",
         "spein",
         "karaoke",
         "bar",
         "ramenn",
         "cafe",
         "okonomiyaki"]

    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        

        genreNavigation.accessibilityElementsHidden = true
        
        
        
        
        
        
        
        
        
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.denied{
            return
        }
        
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        
        if status == CLAuthorizationStatus.notDetermined {
            myLocationManager.requestWhenInUseAuthorization()
        }
        
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = kCLDistanceFilterNone
        
        myLocationManager.requestLocation()
        
        
        
        
        
        
        
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        
        
        
        
//        myTableView.delegate = self
//        myTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        //hotpepperの情報を取ってくる
        let url = URL(string: "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=847b52fd31d7b663&lat=35.0334&lng=135.7906&range=5&order=4&format=json&count=100")
        let request = URLRequest(url: url!)
        let jsondata = (try! NSURLConnection.sendSynchronousRequest(request, returning: nil))
        let jsonDic = (try! JSONSerialization.jsonObject(with: jsondata, options: [])) as! NSDictionary
        
        do{
        //resultsキーを指定して全ての情報を取得
        var result:NSDictionary
        result = jsonDic["results"] as! NSDictionary
        
        //店の情報を取得
        var resultArray:NSArray
        resultArray = result["shop"] as! NSArray
            
        //店の情報がarray型で入ってるので、whileで回して全ての情報を取得
        var number = 0
        var izakayaStoreNames: [String] = []
        var izakayaPhotos: [URL] = []
        
        
        while number < resultArray.count {
            
            //それぞれの店の情報をeachStoreInforamtionに保存
            var eachStoreInfomation:NSDictionary
            eachStoreInfomation = resultArray[number] as! NSDictionary
        
            //店の名前をstoreNameとして保存
            let storeName: String = eachStoreInfomation["name"] as! String

            //店の住所をaddressとして保存
            let address: String = eachStoreInfomation["address"] as! String
            
            //ジャンルの名前をgenreNameとして保存
            let genreDictionary:NSDictionary = eachStoreInfomation["genre"] as! NSDictionary
            let genreName :String = genreDictionary["name"] as! String
            
            //店のcatch文をcatchInformationとして保存
            let catchInformaton:String = genreDictionary["catch"] as! String
            
            //営業時間をopenTimeとして保存
            let openTime:String = eachStoreInfomation["open"] as! String
            
            
            //平均価格をpriccとして保存
            let budget:NSDictionary = eachStoreInfomation["budget"] as! NSDictionary
            let price:String = budget["average"] as! String
            
            
            //写真の情報をAPIから取ってくる
            let photoDictionary:NSDictionary = eachStoreInfomation["photo"] as! NSDictionary
            let photoDictionaryPc:NSDictionary = photoDictionary["pc"] as! NSDictionary
            let photoDataString:String = photoDictionaryPc["l"] as! String
            let photoDataURL:URL = URL(string: photoDataString)!
            
            
            //配列の要素数取り出すための処理
            number += 1
            
            
            var items: [Item] = []

                
            //データをジャンルごとに保存する
            switch genreName {
            case "居酒屋":
                appDelegate.izakaya["storename"]?.append(storeName)
                appDelegate.izakaya["address"]?.append(address)
                appDelegate.izakaya["photo"]?.append(photoDataURL)
                appDelegate.izakaya["catch"]?.append(catchInformaton)
                appDelegate.izakaya["price"]?.append(price)
                appDelegate.izakaya["openTime"]?.append(openTime)
            case "ダイニングバー":
                appDelegate.diningbar["storename"]?.append(storeName)
                appDelegate.diningbar["address"]?.append(address)
                appDelegate.diningbar["photo"]?.append(photoDataURL)
                appDelegate.diningbar["catch"]?.append(catchInformaton)
                appDelegate.diningbar["price"]?.append(price)
                appDelegate.diningbar["openTime"]?.append(openTime)
            case "創作料理":
                appDelegate.sousakuryouri["storename"]?.append(storeName)
                appDelegate.sousakuryouri["address"]?.append(address)
                appDelegate.sousakuryouri["photo"]?.append(photoDataURL)
                appDelegate.sousakuryouri["catch"]?.append(catchInformaton)
                appDelegate.sousakuryouri["price"]?.append(price)
                appDelegate.sousakuryouri["openTime"]?.append(openTime)
            case "和食":
                appDelegate.wasyoku["storename"]?.append(storeName)
                appDelegate.wasyoku["address"]?.append(address)
                appDelegate.wasyoku["photo"]?.append(photoDataURL)
                appDelegate.wasyoku["catch"]?.append(catchInformaton)
                appDelegate.wasyoku["price"]?.append(price)
                appDelegate.wasyoku["openTime"]?.append(openTime)
            case "日本料理・懐石":
                appDelegate.nihonnryouri["storename"]?.append(storeName)
                appDelegate.nihonnryouri["address"]?.append(address)
                appDelegate.nihonnryouri["photo"]?.append(photoDataURL)
                appDelegate.nihonnryouri["catch"]?.append(catchInformaton)
                appDelegate.nihonnryouri["price"]?.append(price)
                appDelegate.nihonnryouri["openTime"]?.append(openTime)
            case "寿司":
                appDelegate.suhsi["storename"]?.append(storeName)
                appDelegate.suhsi["address"]?.append(address)
                appDelegate.suhsi["photo"]?.append(photoDataURL)
                appDelegate.suhsi["catch"]?.append(catchInformaton)
                appDelegate.suhsi["price"]?.append(price)
                appDelegate.suhsi["openTime"]?.append(openTime)
            case "しゃぶしゃぶ・すき焼き":
                appDelegate.syabusyabu["storename"]?.append(storeName)
                appDelegate.syabusyabu["address"]?.append(address)
                appDelegate.syabusyabu["photo"]?.append(photoDataURL)
                appDelegate.syabusyabu["catch"]?.append(catchInformaton)
                appDelegate.syabusyabu["price"]?.append(price)
                appDelegate.syabusyabu["openTime"]?.append(openTime)
            case "うどん・そば":
                appDelegate.udon["storename"]?.append(storeName)
                appDelegate.udon["address"]?.append(address)
                appDelegate.udon["photo"]?.append(photoDataURL)
                appDelegate.udon["catch"]?.append(catchInformaton)
                appDelegate.udon["price"]?.append(price)
                appDelegate.udon["openTime"]?.append(openTime)
            case "洋食":
                appDelegate.yousyoku["storename"]?.append(storeName)
                appDelegate.yousyoku["address"]?.append(address)
                appDelegate.yousyoku["photo"]?.append(photoDataURL)
                appDelegate.yousyoku["catch"]?.append(catchInformaton)
                appDelegate.yousyoku["price"]?.append(price)
                appDelegate.yousyoku["openTime"]?.append(openTime)
            case "ステーキ・ハンバーグ・カレー":
                appDelegate.steak["storename"]?.append(storeName)
                appDelegate.steak["address"]?.append(address)
                appDelegate.steak["photo"]?.append(photoDataURL)
                appDelegate.steak["catch"]?.append(catchInformaton)
                appDelegate.steak["price"]?.append(price)
                appDelegate.steak["openTime"]?.append(openTime)
            case "イタリアン・フレンチ":
                appDelegate.italian["storename"]?.append(storeName)
                appDelegate.italian["address"]?.append(address)
                appDelegate.italian["photo"]?.append(photoDataURL)
                appDelegate.italian["catch"]?.append(catchInformaton)
                appDelegate.italian["price"]?.append(price)
                appDelegate.italian["openTime"]?.append(openTime)
            case "パスタ・ピザ":
                appDelegate.pasta["storename"]?.append(storeName)
                appDelegate.pasta["address"]?.append(address)
                appDelegate.pasta["photo"]?.append(photoDataURL)
                appDelegate.pasta["catch"]?.append(catchInformaton)
                appDelegate.pasta["price"]?.append(price)
                appDelegate.pasta["openTime"]?.append(openTime)
            case "ビストロ":
                appDelegate.bistoro["storename"]?.append(storeName)
                appDelegate.bistoro["address"]?.append(address)
                appDelegate.bistoro["photo"]?.append(photoDataURL)
                appDelegate.bistoro["catch"]?.append(catchInformaton)
                appDelegate.bistoro["price"]?.append(price)
                appDelegate.bistoro["openTime"]?.append(openTime)
            case "中華":
                appDelegate.tyuka["storename"]?.append(storeName)
                appDelegate.tyuka["address"]?.append(address)
                appDelegate.tyuka["photo"]?.append(photoDataURL)
                appDelegate.tyuka["catch"]?.append(catchInformaton)
                appDelegate.tyuka["price"]?.append(price)
                appDelegate.tyuka["openTime"]?.append(openTime)
            case "広東料理":
                appDelegate.kanntouryouri["storename"]?.append(storeName)
                appDelegate.kanntouryouri["address"]?.append(address)
                appDelegate.kanntouryouri["photo"]?.append(photoDataURL)
                appDelegate.kanntouryouri["catch"]?.append(catchInformaton)
                appDelegate.kanntouryouri["price"]?.append(price)
                appDelegate.kanntouryouri["openTime"]?.append(openTime)
            case "四川料理":
                appDelegate.shisenn["storename"]?.append(storeName)
                appDelegate.shisenn["address"]?.append(address)
                appDelegate.shisenn["photo"]?.append(photoDataURL)
                appDelegate.shisenn["catch"]?.append(catchInformaton)
                appDelegate.shisenn["price"]?.append(price)
                appDelegate.shisenn["openTime"]?.append(openTime)
            case "上海料理":
                appDelegate.shanhai["storename"]?.append(storeName)
                appDelegate.shanhai["address"]?.append(address)
                appDelegate.shanhai["photo"]?.append(photoDataURL)
                appDelegate.shanhai["catch"]?.append(catchInformaton)
                appDelegate.shanhai["price"]?.append(price)
                appDelegate.shanhai["openTime"]?.append(openTime)
            case "北京料理":
                appDelegate.pekinn["storename"]?.append(storeName)
                appDelegate.pekinn["address"]?.append(address)
                appDelegate.pekinn["photo"]?.append(photoDataURL)
                appDelegate.pekinn["catch"]?.append(catchInformaton)
                appDelegate.pekinn["price"]?.append(price)
                appDelegate.pekinn["openTime"]?.append(openTime)
            case "焼肉・韓国料理":
                appDelegate.yakiniku["storename"]?.append(storeName)
                appDelegate.yakiniku["address"]?.append(address)
                appDelegate.yakiniku["photo"]?.append(photoDataURL)
                appDelegate.yakiniku["catch"]?.append(catchInformaton)
                appDelegate.yakiniku["price"]?.append(price)
                appDelegate.yakiniku["openTime"]?.append(openTime)
            case "アジアン":
                appDelegate.ajian["storename"]?.append(storeName)
                appDelegate.ajian["address"]?.append(address)
                appDelegate.ajian["photo"]?.append(photoDataURL)
                appDelegate.ajian["catch"]?.append(catchInformaton)
                appDelegate.ajian["price"]?.append(price)
                appDelegate.ajian["openTime"]?.append(openTime)
            case "タイ・ベトナム料理":
                appDelegate.thai["storename"]?.append(storeName)
                appDelegate.thai["address"]?.append(address)
                appDelegate.thai["photo"]?.append(photoDataURL)
                appDelegate.thai["catch"]?.append(catchInformaton)
                appDelegate.thai["price"]?.append(price)
                appDelegate.thai["openTime"]?.append(openTime)
            case "インド料理":
                appDelegate.indo["storename"]?.append(storeName)
                appDelegate.indo["address"]?.append(address)
                appDelegate.indo["photo"]?.append(photoDataURL)
                appDelegate.indo["catch"]?.append(catchInformaton)
                appDelegate.indo["price"]?.append(price)
                appDelegate.indo["openTime"]?.append(openTime)
            case "スペイン・地中海料理":
                appDelegate.spein["storename"]?.append(storeName)
                appDelegate.spein["address"]?.append(address)
                appDelegate.spein["photo"]?.append(photoDataURL)
                appDelegate.spein["catch"]?.append(catchInformaton)
                appDelegate.spein["price"]?.append(price)
                appDelegate.spein["openTime"]?.append(openTime)
            case "カラオケ":
                appDelegate.karaoke["storename"]?.append(storeName)
                appDelegate.karaoke["address"]?.append(address)
                appDelegate.karaoke["photo"]?.append(photoDataURL)
                appDelegate.karaoke["catch"]?.append(catchInformaton)
                appDelegate.karaoke["price"]?.append(price)
                appDelegate.karaoke["openTime"]?.append(openTime)
            case "バー・カクテル":
                appDelegate.bar["storename"]?.append(storeName)
                appDelegate.bar["address"]?.append(address)
                appDelegate.bar["photo"]?.append(photoDataURL)
                appDelegate.bar["catch"]?.append(catchInformaton)
                appDelegate.bar["price"]?.append(price)
                appDelegate.bar["openTime"]?.append(openTime)
            case "ラーメン":
                appDelegate.ramenn["storename"]?.append(storeName)
                appDelegate.ramenn["address"]?.append(address)
                appDelegate.ramenn["photo"]?.append(photoDataURL)
                appDelegate.ramenn["catch"]?.append(catchInformaton)
                appDelegate.ramenn["price"]?.append(price)
                appDelegate.ramenn["openTime"]?.append(openTime)
            case "カフェ・スイーツ":
                appDelegate.cafe["storename"]?.append(storeName)
                appDelegate.cafe["address"]?.append(address)
                appDelegate.cafe["photo"]?.append(photoDataURL)
                appDelegate.cafe["catch"]?.append(catchInformaton)
                appDelegate.cafe["price"]?.append(price)
                appDelegate.cafe["openTime"]?.append(openTime)
            case "お好み焼き・もんじゃ・鉄板焼き":
                appDelegate.okonomiyaki["storename"]?.append(storeName)
                appDelegate.okonomiyaki["address"]?.append(address)
                appDelegate.okonomiyaki["photo"]?.append(photoDataURL)
                appDelegate.okonomiyaki["catch"]?.append(catchInformaton)
                appDelegate.okonomiyaki["price"]?.append(price)
                appDelegate.okonomiyaki["openTime"]?.append(openTime)
            default:
            print("不明のジャンルが入りました")
            print(genreName)
            }
            }
        
            //並べ替えのため作成(店名)
            var amountArray: NSArray =
                
                [appDelegate.izakaya["storename"]!,
                 appDelegate.diningbar["storename"]!,
                 appDelegate.sousakuryouri["storename"]!,
                 appDelegate.wasyoku["storename"]!,
                 appDelegate.nihonnryouri["storename"]!,
                 appDelegate.suhsi["storename"]!,
                 appDelegate.syabusyabu["storename"]!,
                 appDelegate.udon["storename"]!,
                 appDelegate.yousyoku["storename"]!,
                 appDelegate.steak["storename"]!,
                 appDelegate.italian["storename"]!,
                 appDelegate.french["storename"]!,
                 appDelegate.pasta["storename"]!,
                 appDelegate.bistoro["storename"]!,
                 appDelegate.tyuka["storename"]!,
                 appDelegate.kanntouryouri["storename"]!,
                 appDelegate.shisenn["storename"]!,
                 appDelegate.shanhai["storename"]!,
                 appDelegate.pekinn["storename"]!,
                 appDelegate.yakiniku["storename"]!,
                 appDelegate.kannkokuryouri["storename"]!,
                 appDelegate.ajian["storename"]!,
                 appDelegate.thai["storename"]!,
                 appDelegate.indo["storename"]!,
                 appDelegate.spein["storename"]!,
                 appDelegate.karaoke["storename"]!,
                 appDelegate.bar["storename"]!,
                 appDelegate.ramenn["storename"]!,
                 appDelegate.cafe["storename"]!,
                 appDelegate.okonomiyaki["storename"]!]
            
            
            //並べ替えのため作成(写真)
            var amountArray1: NSArray =
            
                [appDelegate.izakaya["photo"]!,
                 appDelegate.diningbar["photo"]!,
                 appDelegate.sousakuryouri["photo"]!,
                 appDelegate.wasyoku["photo"]!,
                 appDelegate.nihonnryouri["photo"]!,
                 appDelegate.suhsi["photo"]!,
                 appDelegate.syabusyabu["photo"]!,
                 appDelegate.udon["photo"]!,
                 appDelegate.yousyoku["photo"]!,
                 appDelegate.steak["photo"]!,
                 appDelegate.italian["photo"]!,
                 appDelegate.french["photo"]!,
                 appDelegate.pasta["photo"]!,
                 appDelegate.bistoro["photo"]!,
                 appDelegate.tyuka["photo"]!,
                 appDelegate.kanntouryouri["photo"]!,
                 appDelegate.shisenn["photo"]!,
                 appDelegate.shanhai["photo"]!,
                 appDelegate.pekinn["photo"]!,
                 appDelegate.yakiniku["photo"]!,
                 appDelegate.kannkokuryouri["photo"]!,
                 appDelegate.ajian["photo"]!,
                 appDelegate.thai["photo"]!,
                 appDelegate.indo["photo"]!,
                 appDelegate.spein["photo"]!,
                 appDelegate.karaoke["photo"]!,
                 appDelegate.bar["photo"]!,
                 appDelegate.ramenn["photo"]!,
                 appDelegate.cafe["photo"]!,
                 appDelegate.okonomiyaki["photo"]!]
            
            var amountArray2: NSArray =
                
                [appDelegate.izakaya["address"]!,
                 appDelegate.diningbar["address"]!,
                 appDelegate.sousakuryouri["address"]!,
                 appDelegate.wasyoku["address"]!,
                 appDelegate.nihonnryouri["address"]!,
                 appDelegate.suhsi["address"]!,
                 appDelegate.syabusyabu["address"]!,
                 appDelegate.udon["address"]!,
                 appDelegate.yousyoku["address"]!,
                 appDelegate.steak["address"]!,
                 appDelegate.italian["address"]!,
                 appDelegate.french["address"]!,
                 appDelegate.pasta["address"]!,
                 appDelegate.bistoro["address"]!,
                 appDelegate.tyuka["address"]!,
                 appDelegate.kanntouryouri["address"]!,
                 appDelegate.shisenn["address"]!,
                 appDelegate.shanhai["address"]!,
                 appDelegate.pekinn["address"]!,
                 appDelegate.yakiniku["address"]!,
                 appDelegate.kannkokuryouri["address"]!,
                 appDelegate.ajian["address"]!,
                 appDelegate.thai["address"]!,
                 appDelegate.indo["address"]!,
                 appDelegate.spein["address"]!,
                 appDelegate.karaoke["address"]!,
                 appDelegate.bar["address"]!,
                 appDelegate.ramenn["address"]!,
                 appDelegate.cafe["address"]!,
                 appDelegate.okonomiyaki["address"]!]

            //並べ替えのため作成(catch文)
            var amountArray3: NSArray =
            
                [appDelegate.izakaya["catch"]!,
                 appDelegate.diningbar["catch"]!,
                 appDelegate.sousakuryouri["catch"]!,
                 appDelegate.wasyoku["catch"]!,
                 appDelegate.nihonnryouri["catch"]!,
                 appDelegate.suhsi["catch"]!,
                 appDelegate.syabusyabu["catch"]!,
                 appDelegate.udon["catch"]!,
                 appDelegate.yousyoku["catch"]!,
                 appDelegate.steak["catch"]!,
                 appDelegate.italian["catch"]!,
                 appDelegate.french["catch"]!,
                 appDelegate.pasta["catch"]!,
                 appDelegate.bistoro["catch"]!,
                 appDelegate.tyuka["catch"]!,
                 appDelegate.kanntouryouri["catch"]!,
                 appDelegate.shisenn["catch"]!,
                 appDelegate.shanhai["catch"]!,
                 appDelegate.pekinn["catch"]!,
                 appDelegate.yakiniku["catch"]!,
                 appDelegate.kannkokuryouri["catch"]!,
                 appDelegate.ajian["catch"]!,
                 appDelegate.thai["catch"]!,
                 appDelegate.indo["catch"]!,
                 appDelegate.spein["catch"]!,
                 appDelegate.karaoke["catch"]!,
                 appDelegate.bar["catch"]!,
                 appDelegate.ramenn["catch"]!,
                 appDelegate.cafe["catch"]!,
                 appDelegate.okonomiyaki["catch"]!]

            //並べ替えのため作成(平均価格)
            var amountArray4: NSArray =
                
                [appDelegate.izakaya["price"]!,
                 appDelegate.diningbar["price"]!,
                 appDelegate.sousakuryouri["price"]!,
                 appDelegate.wasyoku["price"]!,
                 appDelegate.nihonnryouri["price"]!,
                 appDelegate.suhsi["price"]!,
                 appDelegate.syabusyabu["price"]!,
                 appDelegate.udon["price"]!,
                 appDelegate.yousyoku["price"]!,
                 appDelegate.steak["price"]!,
                 appDelegate.italian["price"]!,
                 appDelegate.french["price"]!,
                 appDelegate.pasta["price"]!,
                 appDelegate.bistoro["price"]!,
                 appDelegate.tyuka["price"]!,
                 appDelegate.kanntouryouri["price"]!,
                 appDelegate.shisenn["price"]!,
                 appDelegate.shanhai["price"]!,
                 appDelegate.pekinn["price"]!,
                 appDelegate.yakiniku["price"]!,
                 appDelegate.kannkokuryouri["price"]!,
                 appDelegate.ajian["price"]!,
                 appDelegate.thai["price"]!,
                 appDelegate.indo["price"]!,
                 appDelegate.spein["price"]!,
                 appDelegate.karaoke["price"]!,
                 appDelegate.bar["price"]!,
                 appDelegate.ramenn["price"]!,
                 appDelegate.cafe["price"]!,
                 appDelegate.okonomiyaki["price"]!]
            
            
            //並べ替えのため作成(営業時間)
            var amountArray5: NSArray =
                
                [appDelegate.izakaya["openTime"]!,
                 appDelegate.diningbar["openTime"]!,
                 appDelegate.sousakuryouri["openTime"]!,
                 appDelegate.wasyoku["openTime"]!,
                 appDelegate.nihonnryouri["openTime"]!,
                 appDelegate.suhsi["openTime"]!,
                 appDelegate.syabusyabu["openTime"]!,
                 appDelegate.udon["openTime"]!,
                 appDelegate.yousyoku["openTime"]!,
                 appDelegate.steak["openTime"]!,
                 appDelegate.italian["openTime"]!,
                 appDelegate.french["openTime"]!,
                 appDelegate.pasta["openTime"]!,
                 appDelegate.bistoro["openTime"]!,
                 appDelegate.tyuka["openTime"]!,
                 appDelegate.kanntouryouri["openTime"]!,
                 appDelegate.shisenn["openTime"]!,
                 appDelegate.shanhai["openTime"]!,
                 appDelegate.pekinn["openTime"]!,
                 appDelegate.yakiniku["openTime"]!,
                 appDelegate.kannkokuryouri["openTime"]!,
                 appDelegate.ajian["openTime"]!,
                 appDelegate.thai["openTime"]!,
                 appDelegate.indo["openTime"]!,
                 appDelegate.spein["openTime"]!,
                 appDelegate.karaoke["openTime"]!,
                 appDelegate.bar["openTime"]!,
                 appDelegate.ramenn["openTime"]!,
                 appDelegate.cafe["openTime"]!,
                 appDelegate.okonomiyaki["openTime"]!]
            

            
            
        //並べ替えのための作成(ジャンル名)
        var genreNames =
            
            ["居酒屋",
             "ダイニングバー",
             "創作料理",
             "和食",
             "日本料理・懐石",
             "寿司",
             "しゃぶしゃぶ・すき焼き",
             "うどん・そば",
             "洋食",
             "ステーキ・ハンバーグ・カレー",
             "イタリアン" ,
             "フレンチ" ,
             "パスタ・ピザ" ,
             "ビストロ",
             "中華",
             "広東料理",
             "四川料理",
             "上海料理",
             "北京料理",
             "焼肉",
             "韓国料理",
             "アジアン",
             "タイ・ベトナム料理",
             "インド料理",
             "スペイン・地中海料理",
             "カラオケ",
             "バー・カクテル",
             "ラーメン",
             "カフェ・スイーツ",
             "お好み焼き・もんじゃ・鉄板焼き"]
            
            
            
            
            
        //Items配列にItemインスタンスを入れていく
        for n in 0...genreNames.count - 1 {
            
            if (amountArray[n] as AnyObject).count != 0 {
                Items.append(Item(genreName: genreNames[n], storeNames: amountArray[n] as! [String], storeCount: (amountArray[n] as AnyObject).count, photoURLs: amountArray1[n] as! [URL],address:  amountArray2[n] as! [String],catchInformation: amountArray3[n] as! [String], price: amountArray4[n] as! [String], openTime: amountArray5[n] as! [String], genrePicture: genrePictures[n])
            )}
            
        }
            
            
            

            
        //配列の順番をsortする準備
        typealias SortDescriptor<Value> = (Value, Value) -> Bool
            
        //create method to combine some sort conditions
        func combine<Value>(sortDescriptors: [SortDescriptor<Value>]) -> SortDescriptor<Value> {

            return { lhs, rhs in
                for isOrderedBefore in sortDescriptors {
                    if isOrderedBefore(lhs,rhs) { return true }
                    if isOrderedBefore(rhs,lhs) { return false }
                }
                return false
            }
        }
        
        //店の店数の多い順に並べ替える
        let sortedByCount: SortDescriptor<Item> = { $0.storeCount > $1.storeCount }
            
            Items = Items.sorted(by: sortedByCount)
            
            print(Items)
            
            
     
        }catch{
            print("エラーが起きました")
            return
        }
    }
//
//    //cellの個数を決める
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Items.count + 1
//    
//    }
//    
//    //cellの中身を決める
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        switch indexPath.row{
//            
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//            
//            //cell accesoryType decision
//            cell.accessoryType = .none
//            
//            //top cell text 料理ジャンルを選択
//            cell.textLabel?.text = "料理ジャンルを選択"
//            
//            //top cell textcolor change
//            cell.textLabel?.textColor = UIColor.white
//            
//            //top cell backgournd color change
//            cell.backgroundColor = UIColor.blue
//            
//            return cell
//            
//        default:
//            
//            //cell create
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        
//            //cell accesoryType decision
//            cell.accessoryType = .disclosureIndicator
//        
//            cell.textLabel?.text = Items[indexPath.row - 1].genreName + "                           \(Items[indexPath.row - 1].storeCount)"
//            
//            return cell
//            
//        }
//    }
    
//    //cellが押された時に実行するメソッド
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        //選択された行番号をメンバ変数に格納
//        selectedIndex = indexPath.row
//        
//        if selectedIndex == 0 {
//            return
//        }
//        else {
//        //セグエを指定して画面移動
//        self.performSegue(withIdentifier: "showDetail", sender: nil)
//        }
//    }
//    
    
    //segueを使って画面移動する時に実行される（そのメソッドをoverrideで書き換えてる）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //次の画面をインスタンス化(as:ダウンキャスト型変換)
        var vc = segue.destination as! ViewController
        
        //次の画面のプロパティに選択された行番号を指定
        vc.item = Items[selectedIndex]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            latitudeLabel.text = "緯度:\(location.coordinate.latitude)"
            longitudeLabel.text = "経度:\(location.coordinate.longitude)"
            
            //メンバ変数に現在地の経度と緯度を代入
            appDelegate.latitude = location.coordinate.latitude
            appDelegate.longitude = location.coordinate.longitude
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print("エラー")
    }
    

    
    
    
    
    
    
    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.title.text = Items[indexPath.row].genreName
        cell.image.image = UIImage(named: Items[indexPath.row].genrePicture + ".jpeg")
        cell.backgroundColor = UIColor.orange
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Items.count
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //選択された行番号をメンバ変数に格納
        selectedIndex = indexPath.row
        
//        if selectedIndex == 0 {
//            return
//        }
//        else {
            //セグエを指定して画面移動
            self.performSegue(withIdentifier: "showDetail", sender: nil)
//        }

    }
    
    
    
    
    
    
    
    
    
    
    
    
    

}
