//
//  SignupViewController.swift
//  recyclerewards
//
//  Created by Tyler Comisky on 2/14/20.
//  Copyright © 2020 Tyler Comisky. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is HomeViewController
        {
            let vc = segue.destination as? HomeViewController
            vc?.email = email.text!
        }
    }
    

       @IBOutlet weak var email: UITextField!
       @IBOutlet weak var password: UITextField!
       @IBOutlet weak var passwordConfirm: UITextField!

       
    @IBAction func signUpAction(_ sender: Any) {
           if password.text != passwordConfirm.text {
               let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
               
               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               
               alertController.addAction(defaultAction)
               self.present(alertController, animated: true, completion: nil)
           } else {
               Auth.auth().createUser(withEmail: email.text!, password: password.text!) {
                   (user, error) in
                   if error == nil {
                    self.addUser()
                       self.performSegue(withIdentifier: "signUpToHome", sender: self)
                   } else {
                       let alertController = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                       
                       alertController.addAction(defaultAction)
                       self.present(alertController, animated: true, completion: nil)
                   }
               }
           }
       }
    
    func addUser() {
        let emailString = email.text!
        db.collection("users").document(emailString).setData([
            "email": email.text!,
            "score": 0
        ])
    }
}
