//
//  AirportDetailViewController.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/24/21.
//

import Foundation
import UIKit

class AirportDetailViewController: UIViewController {
    var report: WeatherResponse.Report!

    @IBOutlet weak var airportIDLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }

    func setupView() {
        airportIDLabel.text = report.conditions.ident
        dateLabel.text = report.conditions.dateIssued
        latitudeLabel.text = String(report.conditions.lat)
        longitudeLabel.text = String(report.conditions.lon)
        elevationLabel.text = String(report.conditions.elevationFt)
    }
}
