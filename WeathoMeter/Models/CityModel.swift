//
//  CityModels.swift
//  WeathoMeter
//
//  Created by MobileAppDevelopment on 2022-08-09.
//


import Foundation

class CityModel{
    var cityId: Int
    var cityName: String?
    var humidity: String?
    var temperature: String?
    var date : String?
    
    init(cityId: Int, cityName: String?, humidity: String?, temperature: String?, date:String?){
          self.cityId = cityId
          self.cityName = cityName
          self.humidity = humidity
          self.temperature = temperature
          self.date = date
        
      }
    
    
    
}

