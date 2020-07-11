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
    
    private var token: AccessToken?
    private var swiita: Swiita?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.swiita = Swiita(clientid: "bf0f661c452a2c20fe9f81c4a87225a76b84adb1", clientsecret: "7367b74ae862bea330f45ccd2ff8269ed8e451a1", tokenString: nil)
        
    }
    
    // ストック取得
    func getStock(page: Int, order: Int = 20){
        let url = URL(string: "https://qiita.com/api/v2/users/Enchan/stocks?page=\(page)&per_page=\(order)")
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(self.token!.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if (error == nil) {
                DispatchQueue.main.sync {
                    self.authorizeLabel.text = String(data: data!, encoding: .utf8)
                }
            }
        }.resume()
    }
    
    
    @IBAction func onTapAuthorize(_ sender: Any) {
        self.swiita?.authorize(presentViewController: self, authority: [.read, .write], success: { (token) in
            print(token)
        }) { (error) in
            print(error)
        }
    }
    
}

