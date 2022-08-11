//
//  DatabaseManager.swift
//  WeathoMeter
//
//  Created by MobileAppDevelopment on 2022-08-09.
//

import Foundation
 
// import library
import SQLite3

class DatabaseManager{
    var db: OpaquePointer?
    var operationType:String = ""
    var courseId:String = ""
//    var listCity: [String] = [CityModel]()
    var cityArray = [CityModel]()
   
    
    func addCity(city_Name:String){
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("mydata3.sqlite")
        let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
        //opening the database
        if sqlite3_open_v2(fileURL.path, &db,flags,nil) != SQLITE_OK {
            print("error opening database")
        }
        //creating table
        if sqlite3_exec(self.db, "CREATE TABLE IF NOT EXISTS City (cityId INTEGER PRIMARY KEY AUTOINCREMENT, cityName TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")

        }
                var stmt : OpaquePointer?
                let insertQuery = "INSERT INTO City(cityName) VALUES(?)"
                if(sqlite3_prepare_v2(db,insertQuery, -1, &stmt,nil)) != SQLITE_OK{
                    print("Error binding Query")
                    return
                }
                let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
                //binding the parameters
                if sqlite3_bind_text(stmt, 1, city_Name, -1, SQLITE_TRANSIENT) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure binding city Name: \(errmsg)")
                    return
                }
                if (sqlite3_step(stmt) != SQLITE_DONE){
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting city Name: \(errmsg)")
                }
                else{
                    print("City is inserted \(city_Name)")
                }
                sqlite3_finalize(stmt)
                
                if sqlite3_close(db) != SQLITE_OK {
                    print("error closing database")
                }
    }
    
   
    func deleteCourses(id: Int){
        //the database file
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("mydata3.sqlite")
        //opening the database
                if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                    print("error opening database")
                }
        
        let deleteQuery = "DELETE FROM City where cityId = \(id);"

          var stmt: OpaquePointer?
          if sqlite3_prepare_v2(db, deleteQuery, -1, &stmt, nil) ==
              SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
              print("\nSuccessfully deleted row.")
            } else {
              print("\nCould not update row.")
            }
          } else {
            print("\nUPDATE statement is not prepared")
          }
          sqlite3_finalize(stmt)
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
    }
    
   
    
}



