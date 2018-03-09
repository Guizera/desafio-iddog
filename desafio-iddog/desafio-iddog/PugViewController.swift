//
//  PugViewController.swift
//  desafio-iddog
//
//  Created by José Guilherme Alves da Cunha on 09/03/2018.
//  Copyright © 2018 José Guilherme Alves da Cunha. All rights reserved.
//

import UIKit
import AFNetworking

class PugViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var dogs: [String] = []
    
    let husky:String = "pug"
    
    let defaultValues = UserDefaults.standard
    
    func loadRequest(husky: String) -> URLSessionTask {
        
        let tokenregis:String = defaultValues.string(forKey: "token")!
        
        let LIST_URL = "https://iddog-api.now.sh/feed?category=\(husky)"
        
        let headers = [
            "Authorization": tokenregis,
            "Content-Type": "application/json"
        ]
        let url = URL(string: LIST_URL)!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.dogs = (dataDictionary["list"] as! [String])
                    self.collectionView.reloadData()
                }
            }
            else {
                print("Erro")
            }
        }
        return task
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        let LoggedIn:Int = defaultValues.integer(forKey: "ISLOGGEDIN") as Int
        if(LoggedIn != 1) {
            let appDomain = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            performSegue(withIdentifier: "Login", sender: self)
            
        } else {
            
            let task = loadRequest(husky: (husky))
            task.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogsCollectionViewCell
        let dog = self.dogs[indexPath.row]
        if let posterPath = dog as? String {
            let imageUrl = URL(string: posterPath)
            cell.dogImage.setImageWith(imageUrl!)
        }
        
        return cell
    }
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        performSegue(withIdentifier: "Login", sender: self)
        
    }
    

}
