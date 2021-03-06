//
//  AirportDetailViewController.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/24/21.
//

import Foundation
import UIKit

class AirportDetailViewController: UITableViewController {
    var report: WeatherResponse.Report?
    var airportName: String!
    var reportsStore: ReportsStore!
    var conditions: WeatherResponse.Report.Conditions?
    var forecastMode = false
    var forecastConditionIndex = 0
    var currentConditions: WeatherResponse.Report.Conditions? {
        if forecastMode {
            return report?.forecast?.conditions[forecastConditionIndex]
        } else {
            return report?.conditions
        }
    }

    @IBOutlet weak var airportIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var periodStartLabel: UILabel!
    @IBOutlet weak var periodEndLabel: UILabel!
    @IBOutlet weak var periodStartStackView: UIStackView!
    @IBOutlet weak var periodEndStackView: UIStackView!
    
    let sectionNames = ["Period","Cloud Layers", "Visibility", "Wind"]

    // MARK: - VC lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let report = report {
            setupView(report.conditions)
        } else {
            activitySpinner.isHidden = false
            activitySpinner.startAnimating()
            getWeatherReport()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func setupView(_ conditions: WeatherResponse.Report.Conditions) {
        airportIDLabel.text = conditions.ident
        dateLabel.text = conditions.dateIssued
        latitudeLabel.text = String(conditions.lat)
        longitudeLabel.text = String(conditions.lon)
        elevationLabel.text = String(conditions.elevationFt)
        periodStartStackView.isHidden = true
        periodEndStackView.isHidden = true
        tableView.reloadData()
    }

    func setupView(_ forecast: WeatherResponse.Report.Forecast) {
        airportIDLabel.text = forecast.ident
        dateLabel.text = forecast.dateIssued
        latitudeLabel.text = String(forecast.lat)
        longitudeLabel.text = String(forecast.lon)
        elevationLabel.text = String(forecast.elevationFt)
        periodStartStackView.isHidden = false
        periodStartLabel.text = forecast.period.dateStart
        periodEndStackView.isHidden = false
        periodEndLabel.text = forecast.period.dateEnd
        tableView.reloadData()
    }

    // MARK: - Weather service
    func getWeatherReport() {
        let weatherService = WeatherServiceWorker()
        if let airport = airportName {
            
            weatherService.fetchWeather(forAirport: airport) { [weak self] weatherResponse in
                if let weatherResponse = weatherResponse {
                    self?.report = weatherResponse.report
                    self?.reportsStore.addReport(weatherResponse.report)
                    DispatchQueue.main.async {
                        self?.activitySpinner.stopAnimating()
                        self?.setupView(weatherResponse.report.conditions)
                    }
                }
            }
        }
    }

    // MARK: - Helper functions
    @IBAction func showNextForecastConditions(_ sender: Any) {
        if let report = report {
            if let forecast = report.forecast {
                if forecast.conditions.isEmpty { return }
                // if cycled through all forecast [conditions]
                // reset
                if !forecastMode { // else if forecast mode was false, show first one
                    forecastMode = true
                    setPeriodLabels()
                    setupView(forecast)
                } else if forecastMode { // we are cycling through and go to next
                    // first, check  to see if should reset
                    if forecastConditionIndex >= forecast.conditions.count - 1 {
                        forecastConditionIndex = 0
                        forecastMode = false
                        setupView(report.conditions)
                        return
                    }
                    setPeriodLabels()
                    forecastConditionIndex += 1
                    tableView.reloadData() // async, so index will always be incremented first regardless
                }
            }
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setPeriodLabels()
    }

    func setPeriodLabels() {
        if forecastMode, let currentConditions = currentConditions {
            periodStartLabel.text = currentConditions.period?.dateStart
            periodEndLabel.text = currentConditions.period?.dateEnd
        }
    }

    // MARK: - dataSource and tableView delgate functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let cloudGroups: Int = currentConditions?.cloudLayers.count ?? 1
            return cloudGroups * 3
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 6
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section + 1]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell

        var attributeName = ""
        var attributeData = ""

        let row = indexPath.row
        if let conditions = currentConditions {
            switch indexPath.section {
            case 0:
                let cloudIndex = row / 3
                switch row % 3 {
                case 0:
                    attributeName = "coverage"
                    attributeData = conditions.cloudLayers[cloudIndex].coverage ?? ""
                case 1:
                    attributeName = "altitudeFt"
                    attributeData = String(format: "%f", conditions.cloudLayers[cloudIndex].altitudeFt ?? "")
                case 2:
                    attributeName = "ceiling"
                    if let ceiling = conditions.cloudLayers[cloudIndex].ceiling {
                        attributeData = String(ceiling)
                    }
                default:
                    attributeName = "cloudlayers"
                    attributeData = "no data for indexpath.row cloudlayers"
                }
            case 1:
                switch indexPath.row {
                case 0:
                    attributeName = "distanceSm"
                    attributeData = String(format: "%f", conditions.visibility.distanceSm ?? "")
                case 1:
                    attributeName = "prevailingVisSm"
                    attributeData = String(format: "%f", conditions.visibility.prevailingVisSm ?? "")
                default:
                    attributeName = "visibility"
                    attributeData = "no data for indexpath.row "
                }
            case 2:
                switch indexPath.row {
                case 0:
                    attributeName = "speedKts"
                    attributeData = String(format: "%f", conditions.wind.speedKts ?? "")
                case 1:
                    attributeName = "variable"
                    if let variable = conditions.wind.variable {
                        attributeData = String(variable)
                    }
                default:
                    attributeName = "wind"
                    attributeData = "no data for indexpath.row "
                }
            default:
                attributeName = "error"
                attributeData = "no data for indexpath.row "
            }
        }

        cell.attributeLabel.text = attributeName
        cell.dataLabel.text = attributeData
        return cell
    }
}
