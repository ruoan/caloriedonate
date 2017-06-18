//
//  HistoryViewController.swift
//  caloriedonate
//
//  Created by y-okada on 2017/06/17.
//  Copyright © 2017年 cobol. All rights reserved.
//

import Foundation
import UIKit
import Charts

import Alamofire
import SwiftyJSON

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var btn1:UIButton!
    // chart
    var barChartView: BarChartView!
    // chartの高さ
    var ch: CGFloat = 200

    // 履歴データ
    var tableView: UITableView!
    
    // ステータスバーの高さを取得
    let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    
    var rireki: [[String: String]] = []
    
    let unitsCal = [1200.0,1600.0,2200.0,1000.0,1800.0,1100.0,1500.0]
    let uptime  = ["06/17 08:12","06/16 08:35","06/16 12:27","06/16 15:24","06/16 18:49"]
    let foodcal = [400.0,350.0,450.0,550.0,360.0]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ナビゲーションバーの高さを取得
        //let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let bgColor:UIColor = UIColor.rgb(r: 245, g: 245, b: 245, alpha: 1.0);
        let btnColor:UIColor = UIColor.rgb(r: 19, g: 144, b: 255, alpha: 1.0);
        
        self.view.backgroundColor = bgColor
        
        //戻るボタン
        btn1 = UIButton()
        btn1.frame = CGRect(x: 0,
                            y: statusBarHeight + 5,
                            width: 80,
                            height: 15)
        
        btn1.titleLabel?.font = UIFont(name: "HiraKakuProN-W6",size: 14)
        btn1.setTitle("戻る", for: .normal)
        btn1.setTitleColor(btnColor, for: UIControlState.normal)
        
    
        btn1.addTarget(self, action: #selector(self.gotoBack), for: .touchUpInside)
        
        self.view.addSubview(btn1)

        // チャート
        barChartView = BarChartView(frame:CGRect(x:0,y:statusBarHeight + 25,width:self.view.bounds.width,height:ch))
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.axisMaximum = unitsCal.max()! * 1.25

        // Y軸ラベルを非表示
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        // Y軸の目盛りを非表示
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        // X軸の目盛りを非表示
        barChartView.xAxis.drawGridLinesEnabled = false
        // 凡例を消す
        barChartView.legend.enabled = false
        // チャートをアニメーションで表示
        barChartView.animate(yAxisDuration: 2.0)
        // ピンチでズームが可能か
        barChartView.pinchZoomEnabled = false
        // ダブルタップでズームが可能か
        barChartView.doubleTapToZoomEnabled = false
        // ドラッグ可能か
        barChartView.dragEnabled = false
        //
        barChartView.drawBarShadowEnabled = false
        barChartView.drawBordersEnabled = true
            
        setChart(values: unitsCal)
        self.view.addSubview(barChartView)
        
        self.getJson()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func gotoBack(sender: UIButton){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func getJson() -> JSON{
        var json:JSON = JSON("")
        let URL = "https://74sgw22ebg.execute-api.ap-northeast-1.amazonaws.com/dev/calorie"
        Alamofire.request(URL, parameters: ["start":"2017-06-16","end":"2017-06-18"])
            .responseJSON { response in
                json = JSON(response.result.value)
                
                
                json["body"].forEach{(_, data) in
                    
                    let food: [String: String] = [
                        "menu": data["menu_name"].stringValue,
                        "cal": data["calorie"].description,
                        "img": data["url"].stringValue,
                        "date": data["ate_at"].stringValue
                    ]
                    self.rireki.append(food)
                    
                    self.afterJson()
                    
                }

                
        }
        
        return json
    }
    
    
    func afterJson(){
        let mt:CGFloat = statusBarHeight + ch + 25
        tableView = UITableView(frame:CGRect(x:0,y:mt,width:self.view.bounds.width,height:self.view.bounds.height - mt))
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }

    func setChart(values: [Double]){
        barChartView.noDataText = "You need to provide data for the chart."
        
        // y-axis
        var dataEntries: [BarChartDataEntry] = []
    
        for (i, val) in values.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: val)
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Calories")
        barChartView.data = BarChartData(dataSet: chartDataSet)
        
        let yaxis = YAxis()
        yaxis.valueFormatter = BarChartFormatter()
        // 軸を0からスタートする
        //yaxis.startAtZeroEnabled = true
        
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatter()
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        // ラベルの位置
        barChartView.xAxis.labelPosition = .bottom
        // グラフの色
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        // グラフの背景色
        barChartView.backgroundColor = UIColor.white//(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        // グラフの棒をニョキッとアニメーションさせる
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        // 横に赤いボーダーラインを描く
        let ll = ChartLimitLine(limit: 10.0, label: "Target")
        barChartView.rightAxis.addLimitLine(ll)
        // グラフのタイトル
        barChartView.chartDescription?.text = ""
        // グラフの余白
        barChartView.extraTopOffset = 0.0
        barChartView.extraRightOffset = 0.0
        barChartView.extraBottomOffset = 0.0
        barChartView.extraLeftOffset = 0.0
        
    }
    
    // セルを作る
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        //cell.imageView = ""
        let r = rireki[indexPath.row]
        
        cell.textLabel?.text = r["cal"]! + "kcal"
        cell.detailTextLabel?.text = r["menu"]! + " " + r["date"]!
        let url = NSURL(string: r["img"]!);
        var imageData = NSData(contentsOf: url as! URL)
        var img = UIImage(data:imageData as! Data);
        cell.imageView?.image = img
        //cell.accessoryType = .detailButton
        
        return cell
    }
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(rireki != nil){
            return rireki.count
        }else {
            return 0
        }
    }
    // セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップされたセルのindex番号: \(indexPath.row)")
    }
    // セルの高さを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}

public class BarChartFormatter: NSObject, IAxisValueFormatter{
    // x軸のラベル
    var weeks: [String]! = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return weeks[Int(value)]
    }
}
