//
//  AirportsStore.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/24/21.
//
import Foundation

class AirportStore: Codable {

    var allAirports = [String]()

    /// Loads saved Airports from disk according to ```AirportArchiveURL``` or creates brand new array
    init() {
        if let archivedAirports = loadSavedAirports(from: AirportArchiveURL) {
            allAirports = archivedAirports
        } else {
            allAirports.append("KAUS")
            allAirports.append("KPWM")
        }
    }

    //MARK: archiving tools for store

    ///storage path for archive
    let AirportArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("Airports.archive")
    }()

    /// Simple JSONEncoder wrapper for ```allAirports```
    func saveAirports() -> Bool {
        var data: Data

        do {
            try data = JSONEncoder().encode(allAirports)
            try data.write(to: AirportArchiveURL)
            return true
        } catch {
            print("error saving Airport data to disk: \(error)" )
        }
        return false
    }

    /// Simple JSONDecoder wrapper for assigning data to ```allAirports```
    func loadSavedAirports(from url: URL) -> [String]? {
        var archivedAirports: [String]?
        if let nsData = NSData(contentsOf: url) {
            do {
                let data = Data(referencing: nsData)
                archivedAirports = try JSONDecoder().decode([String].self, from: data)
                print("archivedAirports array loaded from disk")
            } catch {
                print("error loading Strings: \(error)")
            }
        } else {
            print("no data in AirportArchiveURL")
            return nil
        }
        return archivedAirports
    }
}//EoC
