//
//  PreferencesViewController.swift
//  SliceMaster
//
//  Created by Joann Monteiro on 2026-07-16.
//

import UIKit

class PreferencesViewController: UIViewController {
    // MARK: - Outlets
       
       @IBOutlet var tfName: UITextField!
       @IBOutlet var tfPhone: UITextField!
       @IBOutlet var tfEmail: UITextField!
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // load any previously saved values from UserDefaults
                loadFromDefaults()
            }
            
            // MARK: - Load values from UserDefaults
            
            func loadFromDefaults() {
                let store = UserDefaults.standard
                
                if let savedName = store.object(forKey: "lastName") as? String {
                    tfName.text = savedName
                }
                if let savedPhone = store.object(forKey: "lastPhone") as? String {
                    tfPhone.text = savedPhone
                }
                if let savedEmail = store.object(forKey: "lastEmail") as? String {
                    tfEmail.text = savedEmail
                }
            }
            
            // MARK: - Save tapped
            
            @IBAction func savePrefsTapped(_ sender: UIButton) {
                
                let nameStr  = tfName.text  ?? ""
                let phoneStr = tfPhone.text ?? ""
                let emailStr = tfEmail.text ?? ""
                
                let store = UserDefaults.standard
                store.set(nameStr,  forKey: "lastName")
                store.set(phoneStr, forKey: "lastPhone")
                store.set(emailStr, forKey: "lastEmail")
                
                // hide the keyboard if it's open
                view.endEditing(true)
                
                // confirmation alert
                let alert = UIAlertController(title: "Preferences",
                                              message: "Your info has been saved.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true)
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
