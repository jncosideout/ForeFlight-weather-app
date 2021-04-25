//
//  AirportListViewController.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/23/21.
//

import UIKit

class AirportListViewController: UITableViewController {

    var airportsStore: AirportStore!
    var report: WeatherResponse.Report?

    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func lookUpButton(_ sender: Any) {
        let weatherService = WeatherServiceWorker()
        if let airport = searchTextField.text {
            airportsStore.allAirports.append(airport)
            tableView.reloadData()
            weatherService.fetchWeather(forAirport: airport) { [weak self] weatherResponse in
                if let weatherResponse = weatherResponse {
                    self?.report = weatherResponse.report

                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: .main)
                        let airportDetailViewController = storyboard.instantiateViewController(withIdentifier: "AirportDetailViewController") as! AirportDetailViewController
                        airportDetailViewController.report = weatherResponse.report
                        self?.showDetailViewController(airportDetailViewController, sender: self)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowAirportDetails":
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the airport associated with this row and pass it along
                let airport = airportsStore.allAirports[row]
                let airportDetailViewController = segue.destination as! AirportDetailViewController
                if let report = self.report {
                    airportDetailViewController.report = report
                }
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }

    // MARK: - dataSource delgate fxns
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airportsStore.allAirports.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AirportCell", for: indexPath) as! AirportCell

        // Set the text on the cell with the description of the airport
        // which is at the nth index of allAirports, where n = row this cell
        //will appear in on the tableview
        let airport = airportsStore.allAirports[indexPath.row]
        cell.airportNameLabel.text = airport

        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AirportCell {
            cell.dismiss()
        }
    }
}

