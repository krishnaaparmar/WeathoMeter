//
//  HomeViewController.swift
//  WeathoMeter
//
//  Created by MobileAppDevelopment on 2022-08-09.
//

import UIKit
import SQLite3


class HomeViewController: UIViewController , zipCodeBus {

    @IBOutlet weak var currentDate: UILabel!
    
    @IBOutlet weak var minTemp: UILabel!
    
    @IBOutlet weak var maxTemp: UILabel!
    
    @IBOutlet weak var lcoationDesc: UILabel!
    @IBOutlet weak var saveCityBtn: UIButton!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    
     var DailyWeather = [List] ()
     var zipCode = "Barrie" // defult zip code : newYork city
    
     override func viewDidLoad() {
         super.viewDidLoad()
        let todayDate = Date()
         let formatter = DateFormatter()
         formatter.dateStyle = .long
         let dateString = formatter.string(from: todayDate)
         currentDate.text = dateString
     }
    override func viewWillAppear(_ animated: Bool) {
         getDataFromApi(zipCode: zipCode)
       
     }
     // pass Default city value by protocol and delegate
     
     func passZipCode(zipCode: String) {
         self.zipCode = zipCode
         getDataFromApi(zipCode: zipCode)
     }
   
    @IBAction func takenewZipCode(_ sender: Any) {
        let searchView = self.storyboard?.instantiateViewController(withIdentifier: "serachbyZipCpde")as!SearchViewController
        searchView.passZipCode = self
        present(searchView, animated: true, completion: nil)
    }
    var db: OpaquePointer?
   
    static let dailyBase = "http://api.openweathermap.org/data/2.5"
    static let appid = "6a07e24be765a5cefd9594f42f65d19e"
    
    
    @IBAction func saveCity(_ sender: Any) {
        let city_name = locationName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let temp = temperature.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let hum = humidity.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let tempDate = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM / dd"
        let selectedDate = dateFormatter.string(from: tempDate)
            //the database file
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("mydata3.sqlite")
            let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
            //opening the database
            if sqlite3_open_v2(fileURL.path, &db,flags,nil) != SQLITE_OK {
                print("error opening database")
            }
            //creating table
            if sqlite3_exec(self.db, "CREATE TABLE IF NOT EXISTS City2 (cityId INTEGER PRIMARY KEY AUTOINCREMENT, cityName TEXT, temperature TEXT, date TEXT, humidity TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")

            }
                    var stmt : OpaquePointer?
                    let insertQuery = "INSERT INTO City2(cityName,temperature,date,humidity) VALUES(?,?,?,?)"
                    if(sqlite3_prepare_v2(db,insertQuery, -1, &stmt,nil)) != SQLITE_OK{
                        print("Error binding Query")
                        return
                    }
                    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
                    //binding the parameters
                    if sqlite3_bind_text(stmt, 1, city_name, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failure binding city Name: \(errmsg)")
                        return
                    }
        if sqlite3_bind_text(stmt, 2, temp, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding temperature: \(errmsg)")
            return
        }
       
        if sqlite3_bind_text(stmt, 3, selectedDate , -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding date : \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 4, hum, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding humdity: \(errmsg)")
            return
        }
                    if (sqlite3_step(stmt) != SQLITE_DONE){
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failure inserting city details: \(errmsg)")
                    }
                    else{
                        print("City is inserted \(String(describing: city_name))")
                    }
                    sqlite3_finalize(stmt)
                    
                    if sqlite3_close(db) != SQLITE_OK {
                        print("error closing database")
                    }
        
        // Create a new alert
        // Create a new alert
        let dialogMessage = UIAlertController(title: "Attention", message: "Weather Details is saved successfully!", preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        dialogMessage.addAction(defaultAction)
        present(dialogMessage, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func ConvertKivToC(temperature : Double)->String {
       return  "\(String(format: "%.0f", temperature - 273.15))° C"
    }
    
    func getDataFromApi(zipCode : String ){
     
        
        let jsonURLstring = "http://api.openweathermap.org/data/2.5/forecast?q=\(zipCode)&appid=6a07e24be765a5cefd9594f42f65d19e&units=metrics"
    
        guard let url = URL(string : jsonURLstring) else {return }
        URLSession.shared.dataTask(with: url) { data , response, errur in
            guard let data = data else {return }
            
            let dataAsString = String(data: data , encoding: .utf8)
            
            
            do {
                let watherData = try JSONDecoder().decode( Welcome.self ,from: data )
            
                self.DailyWeather.removeAll()
                for i in 0...20{
                    self.DailyWeather.append(watherData.list[i])
                }
                
                DispatchQueue.main.async {
                    
                    print(watherData.city.name)
                    
                    self.temperature.text = self.ConvertKivToC(temperature :watherData.list[0].main.temp)
                    self.locationName.text = watherData.city.name
                    
                    let humm = watherData.list[0].main.humidity
                    
                    self.humidity.text = String("\(humm) %")
                    self.minTemp.text = "\(self.ConvertKivToC(temperature : Double(watherData.list[0].main.tempMin)))↓"
                    self.maxTemp.text = "\(self.ConvertKivToC(temperature : Double(watherData.list[0].main.tempMax)))↑"
                    
                    self.lcoationDesc.text =  watherData.list[0].weather[0].weatherDescription
                }
            }catch let jsonErr{
                print("Error :" ,jsonErr )
            }
            
        }.resume()
    }
 

}

