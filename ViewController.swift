//
//  ViewController.swift
//  task
//
//  Created by mino on 5/8/18.
//  Copyright © 2018 marwa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBAction func addNew(_ sender: AnyObject) {
     
        let viewController:UIViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "form") as UIViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        
    
       
    }
    
  
}

