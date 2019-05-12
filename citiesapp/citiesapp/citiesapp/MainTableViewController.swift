//
//  ViewController.swift
//  citiesapp
//
//  Created by Guilherme Pedriconi on 11/05/19.
//  Copyright © 2019 Pedriconi. All rights reserved.
//

import UIKit
import Foundation

class MainTableViewController: UITableViewController {
    var arrayKey: [String] = []
    var itemSelected = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tarefa"
        
        let url = "http://dev.4all.com:3003"
        let task = "/tarefa"
        let httpMethod = "GET"
        self.httpCall(method: httpMethod, url: url , task:  task)
       
        print(self.arrayKey.count)
    }// didLoadFinish

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "reuse")
        cell.textLabel?.text = arrayKey[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayKey.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       itemSelected = arrayKey[indexPath.row]
       performSegue(withIdentifier: "gotoViewController", sender:nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "gotoViewController"){
            let destination = segue.destination as! MainViewController 
            destination.itemSelected = itemSelected
            
        }
    }
    
    
    func httpCall(method:String , url:String , task:String){
        let group = DispatchGroup() // to async
        
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        var request = NSMutableURLRequest(url: NSURL(string: url + task)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5.0)
        request.httpMethod = method
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                
                let httpResponse = response as? HTTPURLResponse
                
                group.enter()
                do {
                    
                    let json = try JSONSerialization.jsonObject(with:data!) as! [String:Any]
                    
                    for (key, value) in json
                    {
                        for eachValue in value as Any as! NSArray
                        {
                            
                            self.arrayKey.append(eachValue as! String)
                            group.notify(queue: DispatchQueue.main){ // notify data coming and reload table view
                                
                                self.tableView.reloadData()
                            }
                            
                        } //second for
                        
                    }//frist for
                    
                    group.leave()
                }catch {
                    print("## JSON Serialization step has FAILED ##")
                }
                
            }
        })
        dataTask.resume()
    } // finish function
    
}

