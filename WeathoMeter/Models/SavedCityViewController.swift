//
//  SavedCityViewController.swift
//  WeathoMeter
//
//  Created by MobileAppDevelopment on 2022-08-09.
//

import UIKit
import SQLite3

class SavedCityViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    var cityList = [CityModel]()
    var db: OpaquePointer?
    @IBOutlet weak var SavedCityTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SavedCityTableView.delegate = self
        SavedCityTableView.dataSource = self
        featchSavedData()
        // Do any additional setup after loading the view.
        if(cityList.count == 0){
            let dialogMessage = UIAlertController(title: "Attention", message: "No any completed Weather Details to Display.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            dialogMessage.addAction(defaultAction)
            present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
        featchSavedData()
        SavedCityTableView.reloadData()
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        featchSavedData()
        SavedCityTableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRow row: Int, inComponent component: Int) {
       
            print(cityList[row])
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            //this method is giving the row count of table view which is
        return cityList.count
        }
 
    

        //this method is binding the course name with the tableview cell
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! SavedCityTableViewCell
            
            let cityObj: CityModel
            cityObj = cityList[indexPath.row]
            cell.cityName.text = cityObj.cityName
            cell.temperature.text = cityObj.temperature
            cell.date.text = cityObj.date
            cell.humdity.text = cityObj.humidity
            
            return cell
        }
    
  
    
    //Read data from the database
    func featchSavedData(){
        
        cityList.removeAll()
        
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        
        if sqlite3_exec(self.db, "CREATE TABLE IF NOT EXISTS City2 (cityId INTEGER PRIMARY KEY AUTOINCREMENT, cityName TEXT, temperature TEXT, date TEXT, humidity TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")

        }
        
        //this is our select query
        let queryString = "SELECT * FROM City2"
        
        //statement pointer
        var stmt:OpaquePointer? = nil
          //preparing the query
             if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
                 let errmsg = String(cString: sqlite3_errmsg(db)!)
                 print("error preparing insertview: \(errmsg)")
                 return
             }

             //traversing through all the records
             while(sqlite3_step(stmt) == SQLITE_ROW){
                 let cityId = sqlite3_column_int(stmt, 0)
                 let cityName = String(cString: sqlite3_column_text(stmt, 1))
                 let temperature = String(cString: sqlite3_column_text(stmt, 2))
                 let date = String(cString: sqlite3_column_text(stmt, 3))
                 let humidity = String(cString: sqlite3_column_text(stmt, 4))

                 
                 print("\(cityId)\(cityName)\(temperature)\(date)\(humidity)")
                 //adding values to list
                 cityList.append(CityModel(cityId: Int(cityId), cityName: String(describing: cityName),humidity: String(describing: humidity), temperature: String(describing: temperature), date: String(describing: date)))
                 
                 
             }
      sqlite3_finalize(stmt)
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
        
    }
    
    // MARK: - DELETE DATA
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    var id = ""
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
   
        if editingStyle == .delete{
            
            tableView.beginUpdates()
            let cityOb: CityModel
            cityOb = cityList[indexPath.row]
            id = String(cityOb.cityId)
            let alertController = UIAlertController(
                   title: "Confirmation", message: "Are you sure?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
                self.deleteCity(id:self.id)
                self.cityList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            
            let defaultAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alertController.addAction(defaultAction)

            present(alertController, animated: true, completion: nil)
            
            tableView.endUpdates()
       
        }
    }
    func deleteCity(id: String){
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        
        if sqlite3_exec(self.db, "CREATE TABLE IF NOT EXISTS City2 (cityId INTEGER PRIMARY KEY AUTOINCREMENT, cityName TEXT, temperature TEXT, date TEXT, humidity TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
            

        }
        let updateStatementString = "DELETE FROM City2 where cityId = \(id);"

          var updateStatement: OpaquePointer?
          if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
              SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
              print("\nSuccessfully updated row.")
            } else {
              print("\nCould not update row.")
            }
          } else {
            print("\nUPDATE statement is not prepared")
          }
          sqlite3_finalize(updateStatement)
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        // Create a new alert
        let dialogMessage = UIAlertController(title: "Attention", message: "Details is Deleted successfully!", preferredStyle: .alert)

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

}
