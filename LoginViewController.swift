//
//  LoginViewController.swift
//  Guitaa
//
//  Created by admin on 05/09/19.
//  Copyright © 2019 professional. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    
    
    
    @IBAction func registerButton(_ sender: Any) {
        let SignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(SignUpViewController, animated: true)
        
        
    }
    
    

    @IBAction func loginTapped(_ sender: Any) {
        let userName = emailText.text
        let userPasswor = passwordText.text
        
        if (userName?.isEmpty)! || (userPasswor?.isEmpty)!
        {
            print("User name \(String(describing: userName)) or pasword \(String(describing: userPasswor)) is empty")
            displayMessage(userMessage: "One of the required field is missing")
            return
        }
        
        
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        
        
        let myUrl = URL(string: "https://www.guitaa.com/api/v1/users/1/login")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        let postString = ["userName": userName!, "userPassword": userPasswor!] as [String:String]
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Somthing went wrong...")
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
            
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if let parseJSON = json {
                    
                    let apiKey = parseJSON["FA81159EBEFC2CF1E7F9200E732540BC4E095485"] as? String
                    let userId = parseJSON["user"] as? String
                    print("Api Key: \(String(describing: apiKey!))")
                    
                    if (apiKey?.isEmpty)!
                    {
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                        return
                    }
                    DispatchQueue.main.async {
                        let homepage = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") as! HomePageViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homepage
                    }
                    
                } else {
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                }
                
            } catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print(error)
            }
            
            
            
            
            
        }
        
        task.resume()
        
        
        
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
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    
}
