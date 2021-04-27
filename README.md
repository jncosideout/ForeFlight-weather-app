# ForeFlight-weather-app

+ Data
  - [x] Fetch JSON from server endpoint
  https://qa.foreflight.com/weather/report/<Airport identifier\>
+ User Interface
  - [x]  List of favorite locations (initially populated with KPWM & KAUS)
  - [x] Text Input box for airport identifier (ex: kaus) to add to list of locations and
  automatically pushes to the details view.
  - [x] Selecting a location will push to a “Details View” that initially displays the weather
  report for the “conditions” section of the JSON output
  - [x] Details view has the ability to switch to the “forecast” object in the JSON and the
  elements in the view update to represent
+ Features
  - [x] Store history of requested airports
  - [x] Cache last retrieved report for each airport
  - [x] Have a setting that automatically fetches updates at a regular interval

### Bugs
+ Details View button to show Forecast is labeled "Conditions" rather than "Forecast"
  + should update to show which section of Conditions in the Forecast is being shown, and when the top-level Conditions is being shown
+ Period Start/End initially show the Forecast Period, then updates to the first Conditions set's period after scrolling. Each Conditions set after that just shows its period. This is confusing to the user, but I didn't want to make a separate section for the Forecast's period.
+ There are no error messages shown when an api call fails or the weather report for that airport does not exist.
+ Airports are added to the favorites list even if they are not real airports or their weather cannot be retrieved from api
+ Remove label placeholders in AirportDetailViewController
+ Format values
### Design Flaws
+ I wanted to go with SwiftUI/Combine, or at least MVM with property observers, but due to time constraints used the MVC pattern with a classic TableViewController
+ The cells in the AirportDetailViewController must only use data from the Conditions data model, and will fail to be created if the data does not fit that model
  + MVVM could be used to separate the formatting from the TableViewController
  + Cells should be created generically or in a way that is agnostic of the data
