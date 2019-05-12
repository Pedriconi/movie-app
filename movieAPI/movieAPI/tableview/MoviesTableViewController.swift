//
//  MoviesTableViewController.swift
//  movieAPI
//
//  Created by Guilherme Pedriconi on 10/04/19.
//  Copyright © 2019 Pedriconi. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage



class MoviesTableViewController: UITableViewController {
    var theMovies = [Movie]()
    var movieSelected:Movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.title = "Movies"
 
        let imgPath = "https://image.tmdb.org/t/p/w200/"
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)!)
        var request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/discover/movie?api_key=c5850ed73901b8d268d0898a8a9d8bff&language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
               
                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse)
               // print (data!)
                group.enter()
                do {
                    
                    let json = try JSONSerialization.jsonObject(with:data!) as! [String:Any]
                    
                            for (key, value) in json
                            {
                               
                                print(key)
                                print(value)
                                if (key == "results"){
                    
                                    if let resultsArray:[ [String: Any] ]  = value as? [[ String: Any]]
                                    {
                    
                    
                                        for dic in resultsArray
                                        {
                                            let newMovie = Movie()
                                            newMovie.title = dic["original_title"]! as! String
                                            newMovie.overview = dic["overview"]! as! String
                                            newMovie.photo = imgPath + String (dic["poster_path"]! as! String)
                                            newMovie.release = dic["release_date"]! as! String
                    
                                            self.theMovies.append(newMovie)
                                            group.notify(queue: DispatchQueue.main){
                                                self.tableView.reloadData()
                                            }
                                        }
                                        
                                    }
                    
                                    }
                    
                                }
                    
                            group.leave()
                    }catch {
                            print("## JSON Serialization step has FAILED ##")
                            }
                
            }
        })
        dataTask.resume()
        
    }

    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return theMovies.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "gotoMovie"){
            let destination = segue.destination as! MovieController //metodo chamado antes de fazer uma
            destination.movieSelected = movieSelected

        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieSelected = theMovies[indexPath.row]

        performSegue(withIdentifier: "gotoMovie", sender:nil)

    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          let cell = tableView.dequeueReusableCell(withIdentifier: "reuse") as! MoviesTableViewCell
          let imgUrl = URL(string: self.theMovies[indexPath.row].photo!)
          let indexMovie  = theMovies[indexPath.row]
          cell.lblDate.text =  "Release on: " + indexMovie.release!
          cell.lblTitle.text = indexMovie.title!
          cell.imgView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "placeholder.png"))
        return cell

    }
    
//end
}


