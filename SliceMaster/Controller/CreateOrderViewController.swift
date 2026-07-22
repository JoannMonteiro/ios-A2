//
//  CreateOrderViewController.swift
//  SliceMaster
//
//  Created by Joann Monteiro on 2026-07-16.
//

import UIKit

class CreateOrderViewController: UIViewController {
    // MARK: - Outlets
        
        @IBOutlet var dateWheel: UIDatePicker!
        @IBOutlet var tfAddress: UITextField!
        @IBOutlet var sizePicker: UISegmentedControl!
        
        // meat switches
        @IBOutlet var swSalami: UISwitch!
        @IBOutlet var swHam: UISwitch!
        @IBOutlet var swPepperoni: UISwitch!
        
        // veg switches
        @IBOutlet var swOlives: UISwitch!
        @IBOutlet var swSpinach: UISwitch!
        @IBOutlet var swJalapeno: UISwitch!
        
    // holds the currently chosen avatar name — defaults to chef1
    var pickedAvatar: String = "chef1"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func avatarTapped(_ sender: UIButton) {
        print("avatarTapped fired! tag = \(sender.tag)")
        // buttons are tagged 1, 2, 3 in storyboard
        switch sender.tag {
        case 1:
            pickedAvatar = "chef1"
        case 2:
            pickedAvatar = "chef2"
        case 3:
            pickedAvatar = "chef3"
        default:
            pickedAvatar = "chef1"
        }
        
    }
    @IBAction func saveTapped(_ sender: UIButton) {
        
        // 1. Format the delivery date as text
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let deliveryStr = formatter.string(from: dateWheel.date)
        
        // 2. Address
        let addressStr = tfAddress.text ?? ""
        
        // 3. Size — 0 = Small, 1 = Medium, 2 = Large
        let sizeVal = sizePicker.selectedSegmentIndex
        
        // 4. Meat toppings — join the ON ones into a single string
        var meats: [String] = []
        if swSalami.isOn      { meats.append("Salami") }
        if swHam.isOn         { meats.append("Ham") }
        if swPepperoni.isOn  { meats.append("Pepperoni") }
        let meatStr = meats.joined(separator: ", ")
        
        // 5. Veg toppings — join the ON ones
        var vegs: [String] = []
        if swOlives.isOn   { vegs.append("Olives") }
        if swSpinach.isOn  { vegs.append("Spinach") }
        if swJalapeno.isOn { vegs.append("Jalapeño") }
        let vegStr = vegs.joined(separator: ", ")
        
        // 6. Build the PizzaOrder object
        let newRecord = PizzaOrder()
        newRecord.fillIn(theRowID: 0,
                         theDeliveryDate: deliveryStr,
                         theAddress: addressStr,
                         theSize: sizeVal,
                         theMeatToppings: meatStr,
                         theVegToppings: vegStr,
                         theAvatar: pickedAvatar)
        
        // 7. Ask the AppDelegate to insert it
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        let ok = mainDelegate.saveOrder(record: newRecord)
        
        // 8. Refresh the in-memory list so the history table sees the new row
        mainDelegate.loadAllOrders()
        
        // 9. Feedback alert
        var msg = "Your order has been saved."
        if ok == false {
            msg = "Something went wrong saving the order."
        }
        let alert = UIAlertController(title: "Save Order",
                                      message: msg,
                                      preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default) { _ in
            // clear the form for the next order
            self.tfAddress.text = ""
            self.sizePicker.selectedSegmentIndex = 0
            self.swSalami.isOn = false
            self.swHam.isOn = false
            self.swPepperoni.isOn = false
            self.swOlives.isOn = false
            self.swSpinach.isOn = false
            self.swJalapeno.isOn = false
            self.pickedAvatar = "chef1"
        }
        alert.addAction(okBtn)
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
