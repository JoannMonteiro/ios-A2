//
//  OrderHistoryViewController.swift
//  SliceMaster
//
//  Created by Joann Monteiro on 2026-07-16.
//

import UIKit

class OrderHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var historyTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.dataSource = self
                historyTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // refresh table each time this screen appears (in case new order was saved)
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            mainDelegate.loadAllOrders()
            historyTable.reloadData()
        }

        // MARK: - Table view data source

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            return mainDelegate.savedOrders.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 90
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell",
                                                     for: indexPath) as! OrderRowTableViewCell
            
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            let record = mainDelegate.savedOrders[indexPath.row]
            
            if let avatarName = record.avatar, !avatarName.isEmpty {
                cell.imgAvatar.image = UIImage(named: avatarName)
            } else {
                cell.imgAvatar.image = nil
            }
            
            cell.lblRight.text = record.address ?? ""
            
            let sizeText = sizeLabel(for: record.size ?? 0)
            cell.lblLeft.text = "\(record.deliveryDate ?? "") • \(sizeText)"
            
            return cell
        }
        
        // MARK: - Tap row → alert with the extra info
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            let record = mainDelegate.savedOrders[indexPath.row]
            
            let meats = (record.meatToppings ?? "").isEmpty ? "None" : record.meatToppings!
            let vegs  = (record.vegToppings  ?? "").isEmpty ? "None" : record.vegToppings!
            let sizeText = sizeLabel(for: record.size ?? 0)
            
            let msg = """
            Delivery: \(record.deliveryDate ?? "")
            Address: \(record.address ?? "")
            Size: \(sizeText)
            
            Meat: \(meats)
            Veg: \(vegs)
            
            Avatar: \(record.avatar ?? "none")
            """
            
            let alert = UIAlertController(title: "Order Details",
                                          message: msg,
                                          preferredStyle: .alert)
            let closeBtn = UIAlertAction(title: "Close", style: .default, handler: nil)
            alert.addAction(closeBtn)
            present(alert, animated: true)
        }
        
        private func sizeLabel(for value: Int) -> String {
            switch value {
            case 0: return "Small"
            case 1: return "Medium"
            case 2: return "Large"
            case 3: return "X-Large"
            default: return "?"
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
