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
    var reportsStore = ReportsStore()

    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func lookUpButton(_ sender: Any) {

        if let airport = searchTextField.text {
            let airportUpper = airport.uppercased()
            if !airportsStore.allAirports.contains(airportUpper) {
                airportsStore.allAirports.append(airportUpper)
                tableView.reloadData()
                report = reportsStore.getReport(for: airportUpper)
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
        let airportDetailViewController = segue.destination as! AirportDetailViewController
        airportDetailViewController.reportsStore = reportsStore
        if let report = self.report {
            airportDetailViewController.report = report
        }
        switch segue.identifier {
        case "AirportDetailFromCell":
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the airport associated with this row and pass it along
                let airport = airportsStore.allAirports[row]
                airportDetailViewController.airportName = airport
                if let report = reportsStore.getReport(for: airport) {
                    airportDetailViewController.report = report
                }
            } else {
                airportDetailViewController.airportName = "error"
            }
        case "AirportDetailFromLookup":
            if let airport = searchTextField.text {
                airportDetailViewController.airportName = airport
            } else {
                airportDetailViewController.airportName = "error"
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

