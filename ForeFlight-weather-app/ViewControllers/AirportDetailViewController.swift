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

    @IBOutlet weak var airportIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!


    let sectionNames = ["Period","Cloud Layers", "Visibility", "Wind"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let report = report {
            setupView(report)
        } else {
            activitySpinner.isHidden = false
            activitySpinner.startAnimating()
            getWeatherReport()
        }
    }

    func setupView(_ report: WeatherResponse.Report) {
        airportIDLabel.text = report.conditions.ident
        dateLabel.text = report.conditions.dateIssued
        latitudeLabel.text = String(report.conditions.lat)
        longitudeLabel.text = String(report.conditions.lon)
        elevationLabel.text = String(report.conditions.elevationFt)
        tableView.reloadData()
    }

    func getWeatherReport() {
        let weatherService = WeatherServiceWorker()
        if let airport = airportName {
            
            weatherService.fetchWeather(forAirport: airport) { [weak self] weatherResponse in
                if let weatherResponse = weatherResponse {
                    self?.report = weatherResponse.report
                    self?.reportsStore.addReport(weatherResponse.report)
                    DispatchQueue.main.async {
                        self?.activitySpinner.stopAnimating()
                        self?.setupView(weatherResponse.report)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - dataSource delgate fxns
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let cloudGroups: Int = report?.conditions.cloudLayers.count ?? 1
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

        if let report = report {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    attributeName = "coverage"
                    attributeData = (report.conditions.cloudLayers.first?.coverage)!
                case 1:
                    attributeName = "altitudeFt"
                    attributeData = String(report.conditions.cloudLayers.first!.altitudeFt)
                case 2:
                    attributeName = "ceiling"
                    attributeData = String(report.conditions.cloudLayers.first!.ceiling)
                default:
                    attributeName = "cloudlayers"
                    attributeData = "no data for indexpath.row cloudlayers"
                }
            case 1:
                switch indexPath.row {
                case 0:
                    attributeName = "distanceSm"
                    attributeData = String(report.conditions.visibility.distanceSm)
                case 1:
                    attributeName = "prevailingVisSm"
                    attributeData = String(report.conditions.visibility.prevailingVisSm)
                default:
                    attributeName = "visibility"
                    attributeData = "no data for indexpath.row "
                }
            case 2:
                switch indexPath.row {
                case 0:
                    attributeName = "speedKts"
                    attributeData = String(report.conditions.wind.speedKts)
                case 1:
                    attributeName = "variable"
                    attributeData = String(report.conditions.wind.variable)
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
