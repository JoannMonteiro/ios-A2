//
//  AppDelegate.swift
//  SliceMaster
//
//  Created by Joann Monteiro on 2026-07-16.
//

import UIKit
import SQLite3
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // database properties
        var window: UIWindow?
        var dbFileName: String? = "sliceDB.sqlite"
        var dbFilePath: String?
        var savedOrders: [PizzaOrder] = []
        var chosenOrder: PizzaOrder? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // build the phone-side path in ~/Documents
                let docPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let docsFolder = docPaths[0]
                dbFilePath = docsFolder.appending("/" + dbFileName!)
                
                setupDatabaseIfNeeded()
                loadAllOrders()
                
                return true
    }
    // copy the bundled sqlite file to Documents on first launch
        func setupDatabaseIfNeeded() {
            let fileMgr = FileManager.default
            
            // if the file already exists on the phone, nothing to do
            if fileMgr.fileExists(atPath: dbFilePath!) {
                return
            }
            
            // otherwise copy from the app bundle
            let bundlePath = Bundle.main.resourcePath?.appending("/" + dbFileName!)
            try? fileMgr.copyItem(atPath: bundlePath!, toPath: dbFilePath!)
        }
        
        // read every row from OrderLog into savedOrders
        func loadAllOrders() {
            savedOrders.removeAll()
            
            var db: OpaquePointer? = nil
            
            if sqlite3_open(self.dbFilePath, &db) == SQLITE_OK {
                print("DB opened at \(self.dbFilePath!)")
                
                var stmt: OpaquePointer? = nil
                let sqlText: String = "select * from OrderLog"
                
                if sqlite3_prepare_v2(db, sqlText, -1, &stmt, nil) == SQLITE_OK {
                    
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        // col 0 = ID, 1 = DeliveryDate, 2 = Address, 3 = Size,
                        // 4 = MeatToppings, 5 = VegToppings, 6 = Avatar
                        let idVal: Int  = Int(sqlite3_column_int(stmt, 0))
                        let cDate       = sqlite3_column_text(stmt, 1)
                        let cAddr       = sqlite3_column_text(stmt, 2)
                        let szVal: Int  = Int(sqlite3_column_int(stmt, 3))
                        let cMeat       = sqlite3_column_text(stmt, 4)
                        let cVeg        = sqlite3_column_text(stmt, 5)
                        let cAvatar     = sqlite3_column_text(stmt, 6)
                        
                        let dateStr   = String(cString: cDate!)
                        let addrStr   = String(cString: cAddr!)
                        let meatStr   = String(cString: cMeat!)
                        let vegStr    = String(cString: cVeg!)
                        let avatarStr = String(cString: cAvatar!)
                        
                        let record = PizzaOrder()
                        record.fillIn(theRowID: idVal,
                                      theDeliveryDate: dateStr,
                                      theAddress: addrStr,
                                      theSize: szVal,
                                      theMeatToppings: meatStr,
                                      theVegToppings: vegStr,
                                      theAvatar: avatarStr)
                        savedOrders.append(record)
                        
                        print("Row: \(idVal) | \(dateStr) | \(addrStr) | \(szVal) | \(meatStr) | \(vegStr) | \(avatarStr)")
                    }
                    sqlite3_finalize(stmt)
                } else {
                    print("SELECT could not be prepared")
                }
                
                sqlite3_close(db)
            } else {
                print("Could not open database.")
            }
        }
        
        // insert one new PizzaOrder row — returns true on success
        func saveOrder(record: PizzaOrder) -> Bool {
            var db: OpaquePointer? = nil
            var ok: Bool = true
            
            if sqlite3_open(self.dbFilePath, &db) == SQLITE_OK {
                print("DB opened for insert at \(self.dbFilePath!)")
                
                var stmt: OpaquePointer? = nil
                let sqlText: String = "insert into OrderLog values(NULL, ?, ?, ?, ?, ?, ?)"
                
                if sqlite3_prepare_v2(db, sqlText, -1, &stmt, nil) == SQLITE_OK {
                    
                    // cast to NSString to use utf8String
                    let dateNS   = record.deliveryDate! as NSString
                    let addrNS   = record.address!      as NSString
                    let meatNS   = record.meatToppings! as NSString
                    let vegNS    = record.vegToppings!  as NSString
                    let avatarNS = record.avatar!       as NSString
                    
                    sqlite3_bind_text(stmt, 1, dateNS.utf8String,   -1, nil)
                    sqlite3_bind_text(stmt, 2, addrNS.utf8String,   -1, nil)
                    sqlite3_bind_int (stmt, 3, Int32(record.size!))
                    sqlite3_bind_text(stmt, 4, meatNS.utf8String,   -1, nil)
                    sqlite3_bind_text(stmt, 5, vegNS.utf8String,    -1, nil)
                    sqlite3_bind_text(stmt, 6, avatarNS.utf8String, -1, nil)
                    
                    if sqlite3_step(stmt) == SQLITE_DONE {
                        let newID = sqlite3_last_insert_rowid(db)
                        print("Inserted row \(newID)")
                    } else {
                        print("Insert failed")
                        ok = false
                    }
                    sqlite3_finalize(stmt)
                } else {
                    print("INSERT could not be prepared")
                    ok = false
                }
                
                sqlite3_close(db)
            } else {
                print("Could not open database for insert")
                ok = false
            }
            return ok
        }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

