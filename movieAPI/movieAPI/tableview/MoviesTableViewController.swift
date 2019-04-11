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
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.title = "Movies"
        let group = DispatchGroup()
        group.enter()
            let imgPath = "https://image.tmdb.org/t/p/w200/"
            let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=c5850ed73901b8d268d0898a8a9d8bff&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1")!
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
        
            let task = session.dataTask(with: url) { (data, response, error) in
                
                
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with:data!) as! [String:Any]
                        
                        for (key, value) in json
                        {
                            if (key == "results"){
                                
                                if let resultsArray:[ [String: Any] ]  = value as? [[ String: Any]]
                                {
//                                    print("KEY RESULTS FOUND")
                                    
                                    for dic in resultsArray
                                    {
                                        let newMovie = Movie()
                                        newMovie.title = dic["original_title"]! as! String
                                        newMovie.overview = dic["overview"]! as! String
                                        newMovie.photo = imgPath + String (dic["poster_path"]! as! String)
                                        newMovie.release = dic["release_date"]! as! String

                                        self.theMovies.append(newMovie)
                                        

                                    }
                                }
                                
                            }
                            
                        }
                        
                        
                    }catch {
                        print("## JSON Serialization step has FAILED ##")
                    }
                    
                }
            }
            task.resume()
            group.leave()

        
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            
             print(self.theMovies.count)
        }
       
       
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


