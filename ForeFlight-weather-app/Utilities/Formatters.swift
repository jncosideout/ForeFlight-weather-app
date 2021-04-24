//
//  Formatters.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/23/21.
//

import Foundation

let fullDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "YYYY-MM-ddT00:00:00+0000"
  return formatter
}()

let dayFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd"
  return formatter
}()

let monthFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMMM"
  return formatter
}()
