//
//  SignUpViewController.swift
//  Guitaa
//
//  Created by admin on 05/09/19.
//  Copyright © 2019 professional. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPasswor: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if (email.text?.isEmpty)! || (password.text?.isEmpty)! {
            displayMessage(userMessage: "All Fields are requird")
            
            return
        }
        
        if ((password.text?.elementsEqual(confirmPasswor.text!))! != true){
            displayMessage(userMessage: "Please enter the same password")
            return
        }
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        let myUrl = URL(string: "https://www.guitaa.com/api/v1/users/1/signup")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        let postString = ["username": email.text!, "userpassword": password.text!] as [String:String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Somthing went wrong. Try again.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = json {
                    let userId = parseJSON["FA81159EBEFC2CF1E7F9200E732540BC4E095485"] as? String
                    print("FA81159EBEFC2CF1E7F9200E732540BC4E095485: \(String(describing: userId!))")
                    
                    if (userId?.isEmpty)!
                    {
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again Later")
                        return
                    } else {
                        self.displayMessage(userMessage: "Successfully Regustered a New account. Please proced to Sign in")
                    }
                    
                } else {
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again Later")
                }
            } catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again Later")
                print(error)
            }
        
                    
            }
            
            
            
            
            task.resume()
        }
        
    

    
    
    @IBAction func signInButton(_ sender: Any) {
        let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(LoginViewController, animated: true)
        
    }
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController  = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Ok", style: .default)
            { (action:UIAlertAction!) in
                print("Ok Button Tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
}
