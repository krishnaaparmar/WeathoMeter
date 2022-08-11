//
//  SettingsViewController.swift
//  WeathoMeter
//
//  Created by MobileAppDevelopment on 2022-08-09.
//
import UIKit
import SQLite3
import UserNotifications
import Foundation
class SettingsViewController: UIViewController {
    var db : OpaquePointer?
    @IBOutlet weak var notificationTime: UIDatePicker!
    @IBOutlet weak var stateSwitch: UISwitch!
    //var offSwitch = "switchIsOFF"
    var switchAction = ""
    var selectedTime = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let stausOfSwitch = UserDefaults.standard.string(forKey:Constants.isEnable)
        print("status of the switch \(String(describing: stausOfSwitch))")
        if(stausOfSwitch == "isEnable"){
            pushNotification()
            stateSwitch.setOn(true, animated:true)
        }else{
            stateSwitch.setOn(false, animated:true)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changeTimeOfNotification(_ sender: Any) {
        notificationTime.datePickerMode = UIDatePicker.Mode.time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        selectedTime = dateFormatter.string(from: notificationTime.date)
        UserDefaults.standard.set(selectedTime, forKey: Constants.KEYTIME)
        pushNotification()
    }
   
  
    @IBAction func enableNotification(_ sender: UISwitch) {
        
        if stateSwitch.isOn {
                print("The Switch is ON")
                switchAction = "isEnable"
                UserDefaults.standard.set(switchAction, forKey: Constants.isEnable)
                stateSwitch.setOn(true, animated:true)
                pushNotification()
            } else {
                print("The Switch is OFF")
                switchAction = ""
                UserDefaults.standard.set(switchAction, forKey: Constants.isEnable)
                stateSwitch.setOn(false, animated:true)
            }
    }
    
    func pushNotification(){
        //Authorization
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound])
        {(granted, error)in}
        
        //Notification Content
        let content = UNMutableNotificationContent()
        content.title = "WeathoMeter"
        content.subtitle = "Hey, There !"
        content.body = "Check the new Weahter Updates"
        content.sound = .default
        
       
        let hh = selectedTime.prefix(2)
        let mm = selectedTime.suffix(2)
        //Timing
        
        var dateComponent = DateComponents()
        dateComponent.hour = Int(hh)
        dateComponent.minute = Int(mm)

       
        
        //let date = Date().addingTimeInterval(15)
        
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        //let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
       // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        //Request
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: timeTrigger)
        
        // Register the request
        
        center.add(request) { (error) in
            //check the error parameter and handle any errors
        }
        
        
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

struct Constants{
    static let  isEnable = "isEnable"
    //static let  keyHours = ""
    //static let  keyMinutes = ""
   // static let  Key =  ""
    static let KEYTIME = ""
}
