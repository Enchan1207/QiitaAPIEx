//
//  ViewController.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/08.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var authorizeLabel: UILabel!
    
    private var token: String?
    private var swiita: Swiita?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swiita = Swiita(clientid: "bf0f661c452a2c20fe9f81c4a87225a76b84adb1", clientsecret: "7367b74ae862bea330f45ccd2ff8269ed8e451a1", token: nil)
    }
    
    @IBAction func onTapAuthorize(_ sender: Any) {
        if let _ = self.token, let swiita = self.swiita {
//            swiita.getStock(page: 1, success: { (json) in
//                print(json)
//            }, failure: { (error) in
//                print(error)
//            })
            
//            swiita.removeStock(id: "8134edf969f9629fa66e", success: { () in
//            }) { (error) in
//                print(error)
//            }
//
//            swiita.addStock(id: "8134edf969f9629fa66e", success: { () in
//            }) { (error) in
//                print(error)
//            }
            swiita.isStocked(itemid: "", success: { (status, json) in
                print(status)
            }) { (error) in
                print(error)
            }
            
        } else {
            
            self.swiita?.authorize(presentViewController: self, authority: [.read, .write], success: { (token) in
                self.token = token
                self.swiita = Swiita(clientid: "bf0f661c452a2c20fe9f81c4a87225a76b84adb1", clientsecret: "7367b74ae862bea330f45ccd2ff8269ed8e451a1", token: self.token)
            }) { (error) in
                print(error)
            }
        }
    }
    
}

