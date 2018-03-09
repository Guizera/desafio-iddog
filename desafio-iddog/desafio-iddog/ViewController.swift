//
//  ViewController.swift
//  desafio-iddog
//
//  Created by José Guilherme Alves da Cunha on 06/03/2018.
//  Copyright © 2018 José Guilherme Alves da Cunha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var loginButton:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //textField Style
        emailText.layer.borderColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.0).cgColor
        emailText.layer.cornerRadius = 20
        
        
        //btnLogin
        loginButton.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginBtn(_ sender: UIButton) {
        
        let email:String = emailText.text!
        
         if emailText.text != ""  {
            
            let LOGIN_URL = "https://iddog-api.now.sh/signup?email=\(email)"
            
            let parameter:NSString = "email=\(email)" as NSString
            
            print("postData: %@", parameter)
            
            let url:NSURL = NSURL(string: LOGIN_URL)!
            let postData = parameter.data(using: String.Encoding.utf8.rawValue)
            let postLength: NSString = String(postData!.count) as NSString
            let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
            
            request.httpMethod = "POST"
            request.httpBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            //let session = URLSession.shared
            //let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> in
            let task = URLSession.shared.dataTask (with: request as URLRequest, completionHandler: {
                (data, response, error) in
                if (error != nil) {
                    print(error!)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse!.statusCode)
                    
                    if let statusCode = httpResponse?.statusCode, 200..<300 ~= statusCode {
                         do {
                            let responseData: NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                            print(responseData)
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                            print(json)
                            
                            let user:NSDictionary = (json!.value(forKey: "user") as? NSDictionary)!
                            
                            //let success:NSInteger = user.value(forKey: "__v") as! NSInteger
                            
                            //print(success)
                            
                            let token:NSString = user.value(forKey: "token") as! NSString
                            
                            print(token)
                            
                            if (user.isEqual(user)) {
                                
                                let success = 1
                            
                             let defaultValues = UserDefaults.standard
                                
                                defaultValues.setValue(email, forKey: "email")
                                defaultValues.setValue(token, forKey: "token")
                                defaultValues.set(success, forKey: "ISLOGGEDIN")
                                defaultValues.synchronize()
                            
                                
                                self.dismiss(animated: true, completion: nil)
                                
                            } else {
                                print("Algo errado aconteceu")
                            }
                         }  catch {
                            print("Error")
                        }
                    }
                }
            })
            task.resume()
        
         } else {
            alertStatus(msg: "Preencha os campos!", title: "Espere ai...", tag: 0)
        }
        
        
    }
    func alertStatus(msg: String, title: String, tag:Int) {
        let alertController: UIAlertController = UIAlertController(title: title , message: msg , preferredStyle: .alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            
        })
        alertController.addAction(alertAction)
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        })
        
        
    }
    
}

