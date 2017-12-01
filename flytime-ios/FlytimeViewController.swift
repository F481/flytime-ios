//
//  FlytimeViewController.swift
//  flytime-ios
//
//  Created by KOENIG on 23.11.17.
//  Copyright © 2017 KOENIG. All rights reserved.
//

import UIKit
import Charts
class FlytimeViewController: UIViewController {
    var times = [0]
    var wind = [0.0]
    var whileFlag = true
    var temprature = [0.0]
    var precip = [0.0]
    let datahandler = DataHandler()
    var weatherData: WeatherData!
    @IBOutlet weak var daySegmentedOutlet: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var textfield: UITextView!
    
    @IBAction func daySegmentedAction(_ sender: Any) {
        NSLog("selectes Segment = %1d", daySegmentedOutlet.selectedSegmentIndex)
        if daySegmentedOutlet.selectedSegmentIndex == 2 {
            clearWeatherData()
            fillWeatherDataDays()
            setChart(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip)
            lineChartView.xAxis.valueFormatter = DateValueFormatterDay()
            textfield.text = weatherData.daily.summary
            textfield.text.append("\nNiederschlags Type = ")
            if weatherData.daily.data[0].precipType == "snow" {
                textfield.text.append("Schnee")
            } else if weatherData.daily.data[0].precipType == "rain" {
                textfield.text.append("Regen")
            }else {
                textfield.text.append("Hagel")
            }
            lineChartView.notifyDataSetChanged()
        }else if daySegmentedOutlet.selectedSegmentIndex == 1 {
            clearWeatherData()
            fillWeatherDataTomorrowHours()
            setChart(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip)
            lineChartView.xAxis.valueFormatter = DateValueFormatterHour()
            textfield.text = weatherData.daily.data[1].summary
            textfield.text.append("\nNiederschlags Type = ")
            if weatherData.daily.data[1].precipType == "snow" {
                textfield.text.append("Schnee")
            } else if weatherData.daily.data[1].precipType == "rain" {
                textfield.text.append("Regen")
            }else {
                textfield.text.append("Hagel")
            }
            lineChartView.notifyDataSetChanged()
        }else{
            clearWeatherData()
            fillWeatherDataTodayHours()
            if times.count <= 0 {
                clearWeatherData()
                fillWeatherDataTomorrowHours()
                textfield.text = "Wetter von Morgen!! \n"
                textfield.text.append(weatherData.daily.data[1].summary)
                textfield.text.append("\nNiederschlags Type = ")
                if weatherData.daily.data[1].precipType == "snow" {
                    textfield.text.append("Schnee")
                } else if weatherData.daily.data[1].precipType == "rain" {
                    textfield.text.append("Regen")
                }else {
                    textfield.text.append("Hagel")
                }
            }else{
                textfield.text = weatherData.daily.data[0].summary
                textfield.text.append("\nNiederschlags Type = ")
                if weatherData.daily.data[0].precipType == "snow" {
                    textfield.text.append("Schnee")
                } else if weatherData.daily.data[0].precipType == "rain" {
                    textfield.text.append("Regen")
                }else {
                    textfield.text.append("Hagel")
                }
            }
            setChart(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip)
            lineChartView.xAxis.valueFormatter = DateValueFormatterHour()
            lineChartView.notifyDataSetChanged()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLineChartView()
       datahandler.getDataFromApi(latitude: 47.81009, longitude: 9.63863)
        while whileFlag {
            weatherData = datahandler.getWeatherData()
            if weatherData != nil{
                whileFlag = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [Int], valuesTemp: [Double], valuesWind: [Double], valuesPrecip: [Double]) {
        var lineChartData: LineChartData?
        var dataEntriesTemp: [ChartDataEntry] = []
        var dataEntriesWind: [ChartDataEntry] = []
        var dataEntriesPrecip: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntryTemp = ChartDataEntry(x: Double(dataPoints[i]), y: valuesTemp[i])
            dataEntriesTemp.append(dataEntryTemp)
            let dataEntryWind = ChartDataEntry(x: Double(dataPoints[i]), y: valuesWind[i])
            dataEntriesWind.append(dataEntryWind)
            let dataEntryPrecip = ChartDataEntry(x: Double(dataPoints[i]), y: valuesPrecip[i]*100)
            dataEntriesPrecip.append(dataEntryPrecip)
        }
        let lineChartDataSetTemp = LineChartDataSet(values: dataEntriesTemp, label: "Temperatur [C°]")
        setPropsLineChartDataSet(lineChartDataSet: lineChartDataSetTemp, color: .red)
        let lineChartDataSetWind = LineChartDataSet(values: dataEntriesWind, label: "Windgeschw. [m/s]")
        setPropsLineChartDataSet(lineChartDataSet: lineChartDataSetWind, color: .blue)
        let lineChartDataSetPrecip = LineChartDataSet(values: dataEntriesPrecip, label: "Niederschlags Wahrsch. [%]")
        setPropsLineChartDataSet(lineChartDataSet: lineChartDataSetPrecip, color: .green)
        lineChartData = LineChartData(dataSets: [lineChartDataSetTemp, lineChartDataSetWind, lineChartDataSetPrecip])
        lineChartView.data = lineChartData
        lineChartView.chartDescription?.text = "Wetter"
        lineChartView.xAxis.setLabelCount(times.count, force: true)
    }
    func setLineChartView() {
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.setScaleEnabled(false)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.rightAxis.enabled = false
        lineChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        lineChartView.noDataText = "You need to provide data for the chart."
    }
    func clearWeatherData() {
        times.removeAll()
        wind.removeAll()
        temprature.removeAll()
        precip.removeAll()
    }
    func fillWeatherDataTodayHours() {
        for hours in weatherData.hourly.data {
            if hours.time >= datahandler.sunriseTimeToday && hours.time <= datahandler.sunsetTimeToday{
                times.append(hours.time)
                temprature.append(hours.temperature)
                wind.append(hours.windSpeed)
                precip.append(hours.precipProbability)
            }
        }
    }
    func fillWeatherDataTomorrowHours() {
        for hours in weatherData.hourly.data {
            if hours.time >= datahandler.sunriseTimeTomorrow && hours.time <= datahandler.sunsetTimeTomorrow{
                times.append(hours.time)
                temprature.append(hours.temperature)
                wind.append(hours.windSpeed)
                precip.append(hours.precipProbability)
            }
        }
    }
    func fillWeatherDataDays() {
        for days in weatherData.daily.data {
            if days.time != nil{
                times.append(days.time)
                temprature.append(days.temperatureMax)
                wind.append(days.windSpeed)
                precip.append(days.precipProbability)
            }
        }
    }
    func setPropsLineChartDataSet (lineChartDataSet: LineChartDataSet, color: UIColor){
        lineChartDataSet.setColor(color)
        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.circleRadius = 3.5
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.circleColors = [color]
        lineChartDataSet.mode = .cubicBezier
    }
}

