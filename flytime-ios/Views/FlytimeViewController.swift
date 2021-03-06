//
//  FlytimeViewController.swift
//  flytime-ios
//
//  Created by FRICK ; KOENIG on 23.11.17.
//

import UIKit
import Charts
import CoreLocation

class FlytimeViewController: UIViewController {
    // holds lineChartDataSets ( Wind, Temp, Precip )
    var lineChartData: LineChartData?
    
    // holds the Weahter Data for a time Periode
    var times: [Int] = [0]
    var wind: [Double] = [0.0]
    var temprature: [Double] = [0.0]
    var precip: [Double] = [0.0]
    
    // TODO change with nicer Code, should be gone
    var whileFlag: Bool = true
    
    // instance of DataHandler
    let datahandler = DataHandler()
    
    // holds complete Weather Data
    var weatherData: WeatherData!
    
    // activity indicator for data fetching
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // Segmented Control for the days
    @IBOutlet weak var daySegmentedOutlet: UISegmentedControl!
    
    // Instanz of the Chart View from: Chart Framework
    @IBOutlet weak var chartView: CombinedChartView!
    
    // Textfield for weather summary
    @IBOutlet weak var textfield: UITextView!
    
    //
    @IBAction func daySegmentedAction(_ sender: Any) {
        NSLog("selectSegment = %1d", daySegmentedOutlet.selectedSegmentIndex)
        if daySegmentedOutlet.selectedSegmentIndex == 2 {
            addWeatherWeek()
            setBestFlyTime(dataPoints: times, valuesWind: wind, valuesPrecip: precip, valuesTemp: temprature)
        }else if daySegmentedOutlet.selectedSegmentIndex == 1 {
            addWeatherTomorrow()
            setBestFlyTime(dataPoints: times, valuesWind: wind, valuesPrecip: precip, valuesTemp: temprature)
        }else{
            addWeatherToday()
            setBestFlyTime(dataPoints: times, valuesWind: wind, valuesPrecip: precip, valuesTemp: temprature)
        }
    }
    
    // Sets the initial Data and show ChartView
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        while whileFlag {
            weatherData = datahandler.getWeatherData()
            if weatherData != nil{
                activityIndicator.stopAnimating()
                addWeatherToday()
                setBestFlyTime(dataPoints: times, valuesWind: wind, valuesPrecip: precip, valuesTemp: temprature)
                // TODO work this out, no refresh
                chartView.notifyDataSetChanged()
                whileFlag = false
            }
            // TODO Exception Handling, no Connection
        }
    }
    
    // Init ChartView
    // Fetches the Weatherdata while view is loading
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicatory(uiView: chartView)
        setChartView()
        datahandler.getDataFromApi(latitude: 47.81009, longitude: 9.63863)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // initiales the ChartView ( size, layout, settings, marker)
    func setChartView() {
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.setScaleEnabled(false)
        chartView.xAxis.labelPosition = .bottom
        chartView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        chartView.chartDescription?.enabled = true
        chartView.chartDescription?.font = .systemFont(ofSize: 10)
        chartView.chartDescription?.text = "Powered by Darksky.net"
        chartView.chartDescription?.position = CGPoint(x: 138, y: 3)
        chartView.extraTopOffset = 20
        let rightAxis = chartView.rightAxis
        rightAxis.labelTextColor = .blue
        rightAxis.axisMinimum = 0.0
        rightAxis.axisMaximum = 100.0
        rightAxis.gridColor = .blue
        let marker = BalloonMarker(color: .gray,
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker

    }
    // fills the DataSets. Called by addWeather Functions. called by addWeather Functions
    func setLineCharts(dataPoints: [Int], valuesTemp: [Double], valuesWind: [Double], valuesPrecip: [Double], labelPrecip: String) {

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
        lineChartDataSetTemp.axisDependency = .left
        setPropsLineChartDataSet(lineChartDataSet: lineChartDataSetTemp, color: .red)
        let lineChartDataSetWind = LineChartDataSet(values: dataEntriesWind, label: "Windgeschw. [m/s]")
        lineChartDataSetWind.axisDependency = .left
        setPropsLineChartDataSet(lineChartDataSet: lineChartDataSetWind, color: .green)
        let lineChartDataSetPrecip = LineChartDataSet(values: dataEntriesPrecip, label: labelPrecip)
        lineChartDataSetPrecip.axisDependency = .right
        setPropsLineChartDataSet(lineChartDataSet: lineChartDataSetPrecip, color: .blue)
        lineChartData = LineChartData(dataSets: [lineChartDataSetTemp, lineChartDataSetWind, lineChartDataSetPrecip])
        chartView.data = lineChartData
        chartView.xAxis.setLabelCount(times.count, force: true)
    }
    // Sets the properties for the Lines
    func setPropsLineChartDataSet (lineChartDataSet: LineChartDataSet, color: UIColor){
        lineChartDataSet.setColor(color)
        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.circleRadius = 3.5
        lineChartDataSet.drawCircleHoleEnabled = false
        lineChartDataSet.circleColors = [color]
        lineChartDataSet.mode = .cubicBezier
    }
    // Sets the precip label (Schnee, Regen, oder Hagel + wahrsch. [%])
    func setPrecipLabel(day: Int) -> String {
        var precipLabel: String = "kein Niederschlag"
        
        if weatherData.daily.data[day].precipType != nil {
            if weatherData.daily.data[day].precipType == "snow" {
                precipLabel = "Schnee"
            } else if weatherData.daily.data[day].precipType == "rain" {
                precipLabel = "Regen"
            }else {
                precipLabel = "Hagel"
            }
            precipLabel.append("wahrsch. [%]")
        } else if weatherData.daily.data[day].precipType == nil && weatherData.daily.data[day+1].precipType != nil  {
            if weatherData.daily.data[day+1].precipType == "snow" {
                precipLabel = "Schnee"
            } else if weatherData.daily.data[day+1].precipType == "rain" {
                precipLabel = "Regen"
            }else {
                precipLabel = "Hagel"
            }
            precipLabel.append("wahrsch. [%]")
        }
        return precipLabel
    }
    
    // clears WeahterDatas for a time periode
    func clearWeatherData() {
        times.removeAll()
        wind.removeAll()
        temprature.removeAll()
        precip.removeAll()
    }
    
    // fill weatherData for  today. called by addWeatherToday
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
    
    // fill weatherData for tomorrow. called by addWeatherTomorrow
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
    
    // fill weatherData for the week. called by addWeatherWeek
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
    // fills charDataSets, sets x-Axis time Labels, refresh the ChartView. called by Segmeted Cotrol
    func addWeatherToday() {
        clearWeatherData()
        fillWeatherDataTodayHours()
        if times.count <= 0 {
            clearWeatherData()
            fillWeatherDataTomorrowHours()
            textfield.text = "Wetter von Morgen!! \n"
            textfield.text.append(weatherData.daily.data[1].summary)
            setLineCharts(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip, labelPrecip: setPrecipLabel(day: 1))
        }else{
            textfield.text = weatherData.daily.data[0].summary
            setLineCharts(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip, labelPrecip: setPrecipLabel(day: 0))
        }
        
        chartView.xAxis.valueFormatter = DateValueFormatterHour()
        chartView.notifyDataSetChanged()
    }
    
    // fills charDataSets, sets x-Axis time Labels, refresh the ChartView. called by Segmeted Cotrol
    func addWeatherTomorrow() {
        clearWeatherData()
        fillWeatherDataTomorrowHours()
        setLineCharts(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip, labelPrecip: setPrecipLabel(day: 1))
        chartView.xAxis.valueFormatter = DateValueFormatterHour()
        textfield.text = weatherData.daily.data[1].summary


        chartView.notifyDataSetChanged()

    }
    
    // fills charDataSets, sets x-Axis time Labels, refresh the ChartView. called by Segmeted Cotrol
    func addWeatherWeek() {
        clearWeatherData()
        fillWeatherDataDays()
        setLineCharts(dataPoints: times, valuesTemp: temprature, valuesWind: wind, valuesPrecip: precip, labelPrecip: setPrecipLabel(day: 3))
        chartView.xAxis.valueFormatter = DateValueFormatterDay()
        textfield.text = weatherData.daily.summary
        chartView.notifyDataSetChanged()
    }
    
    // Initiales the Activity Indicator and Starts it
    func showActivityIndicatory(uiView: UIView) {
        chartView.noDataText = "Fetching Data..."
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        activityIndicator.center.x = uiView.center.x
        activityIndicator.center.y = uiView.center.y-60.0
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    // Calculates the Best Fly Time and sets the Linechart
    // Function for BestFlytime it works TODO KI-Classifer
    func setBestFlyTime (dataPoints: [Int], valuesWind: [Double], valuesPrecip: [Double], valuesTemp: [Double]) {
        var results: [Result] = []
        var bestCount: Int = 1
        var windSpeedMax: Double = valuesWind.max()!
        if windSpeedMax >= 10 {
            windSpeedMax = 10
        }
        let windSpeedMin: Double = valuesWind.min()!
        var dataEntriesFlyTime: [ChartDataEntry] = []
        
        // start from 1, because with 0 -> i+1 we'll receive a "Index out of range" error
        for i in 1..<dataPoints.count {
            var countBestFlytime: Int = 0
            // calculate average on the actual time frame (normally hour) based on twoe corresponding points
            let varWind: Double = (valuesWind[i-1]+valuesWind[i])/2
            let varPrecip: Double = (valuesPrecip[i-1]+valuesPrecip[i])/2
            let varTemp: Double = (valuesTemp[i-1]+valuesTemp[i])/2
            
            // calculate points for wind attribute (double weight, but only two-point range)
            if varWind <= windSpeedMax {
                if varWind < windSpeedMin * 1.5 {
                    countBestFlytime += 4
                    print("wind2 ")
                }else if varWind < windSpeedMin * 1.9  {
                    countBestFlytime += 2
                    print("wind1 ")
                }
            }

            // calcualte points for temperature attribute (single weight)
            if varTemp >= 8 && varTemp <= 25 {
                if varTemp <= 16 {
                    countBestFlytime += 2
                    print("temp2 ")
                }else if varTemp <= 25 {
                    countBestFlytime += 3
                    print("temp3 ")
                }
            } else if varTemp >= -5 && varTemp <= 35 {
                countBestFlytime += 1
                print("temp1 ")
            }
            
            // calculate points for precip attribute (double weight, three-point range)
            if varPrecip > 0.7 { countBestFlytime = -1 }
            
            if varPrecip <= 0.6 {
                if varPrecip <= 0.2 {
                    countBestFlytime += 6
                    print("precip3 ")
                }else if varPrecip <= 0.4 {
                    countBestFlytime += 4
                    print("precip2 ")
                } else {
                    countBestFlytime += 2
                    print("precip1 ")
                }
            }
            
            if countBestFlytime > bestCount {
                bestCount = countBestFlytime
            }
            print(countBestFlytime)
            
            let dataEntryFlyTime1 = ChartDataEntry(x: Double(dataPoints[i-1]), y: 0)
            let dataEntryFlyTime2 = ChartDataEntry(x: Double(dataPoints[i]), y: 0)
            results.append(Result(countBestFlyTime: countBestFlytime, firstEntry: dataEntryFlyTime1, secondEntry: dataEntryFlyTime2))
        }
        for result in results {
            if result.countBestFlyTime >= bestCount-1{
                result.firstEntry.y = 100
                result.secondEntry.y = 100
            }
            dataEntriesFlyTime.append(result.firstEntry)
            dataEntriesFlyTime.append(result.secondEntry)
        }


        // Setes Line Chart
        let lineChartDataSetBestFlyTime = LineChartDataSet(values: dataEntriesFlyTime, label: "Flytime [%]")
        lineChartDataSetBestFlyTime.axisDependency = .right
        lineChartDataSetBestFlyTime.setColor(UIColor(red: 240, green: 5, blue: 160, alpha: 0.7))
        lineChartDataSetBestFlyTime.drawCircleHoleEnabled = false
        lineChartDataSetBestFlyTime.drawCirclesEnabled = false
        lineChartDataSetBestFlyTime.lineWidth = 3.0
        lineChartDataSetBestFlyTime.mode = .stepped
        let gradientColors = [ChartColorTemplates.colorFromString("#c000faa0").cgColor,
                              ChartColorTemplates.colorFromString("#0b00faa0").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        lineChartDataSetBestFlyTime.fill = Fill(linearGradient: gradient, angle: 90)
        lineChartDataSetBestFlyTime.fillAlpha = 1
        lineChartDataSetBestFlyTime.drawFilledEnabled = true
        chartView.data?.addDataSet(lineChartDataSetBestFlyTime)
        
        chartView.notifyDataSetChanged()
        chartView.data?.notifyDataChanged()
    }
   
}

