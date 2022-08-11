//
//  SearchViewController.swift
//  WeathoMeter
//
//  Created by MobileAppDevelopment on 2022-08-10.
//

import UIKit

class SearchViewController: UIViewController {
    var passZipCode : zipCodeBus?
    @IBOutlet weak var searchCity: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func serachForWearher(_ sender: Any) {
        
        guard let enterdZipcode = searchCity.text else {return }
        
        passZipCode?.passZipCode(zipCode: enterdZipcode)
        dismiss(animated: true, completion: nil)
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
