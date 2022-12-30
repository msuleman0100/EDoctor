//
//  BaseViewConroller.swift
//  Psychnic Reading
//
//  Created by EAPPLE on 10/08/2021.
//

import UIKit
import SwiftUI
import Combine

class BaseViewConroller: UIViewController, ObservableObject {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- FUNCTION TO SHOW ALERT MESSAGE
    func showAlert(message: String, title: String? = nil, action: UIAlertAction? = nil, secondAction: UIAlertAction? = nil, sender: UIViewController) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(action ?? UIAlertAction(title: "OK", style: .default, handler: nil))
            if let secondAction = secondAction {
                alertController.addAction(secondAction)
            }
            sender.present(alertController, animated: true, completion: nil)
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
