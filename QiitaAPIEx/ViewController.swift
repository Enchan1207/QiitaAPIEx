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
    private let qiitaKit = QiitaKit()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.qiitaKit.authorize(presentViewController: self, success: { (token) in
            print(token)
        }) { (error) in
            print(error)
        }
    }
    
}

