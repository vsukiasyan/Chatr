//
//  ViewController.swift
//  Chatr
//
//  Created by Vic Sukiasyan on 5/17/18.
//  Copyright © 2018 Vic Sukiasyan. All rights reserved.
//

import UIKit
import Firebase

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToChat", sender: self)
            
        }
        
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

