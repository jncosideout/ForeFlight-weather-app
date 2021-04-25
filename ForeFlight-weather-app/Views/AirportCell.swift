//
//  AirportCell.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/24/21.
//

import UIKit

class AirportCell: UITableViewCell {
    @IBOutlet var airportNameLabel: UILabel!
    fileprivate var gestureRecognizer: UITapGestureRecognizer?

    func configureGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        if let gestureRecognizer = gestureRecognizer {
            addGestureRecognizer(gestureRecognizer)
            isUserInteractionEnabled = true
        }
    }

    func dismiss() {
        removeGestureRecognizer()
    }

    func removeGestureRecognizer() {
        if let validGesture = gestureRecognizer {
            removeGestureRecognizer(validGesture)
            gestureRecognizer = nil
        }
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        
    }
}
