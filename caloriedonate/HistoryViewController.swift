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

class HistoryViewController: UIViewController {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var barChartView: BarChartView!

    // chartの高さ
    var ch: CGFloat = 200
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ステータスバーの高さを取得
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        // ナビゲーションバーの高さを取得
        //let navBarHeight = self.navigationController?.navigationBar.frame.size.height
    
        let unitsCal = [1200.0,1600.0,2200.0,1000.0,1800.0,1100.0,1500.0]

        barChartView = BarChartView(frame:CGRect(x:0,y:statusBarHeight,width:self.view.bounds.width,height:ch))
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
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(barChartView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
}

public class BarChartFormatter: NSObject, IAxisValueFormatter{
    // x軸のラベル
    var weeks: [String]! = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return weeks[Int(value)]
    }
}
