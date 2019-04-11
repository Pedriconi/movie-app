//
//  MovieController.swift
//  movieAPI
//
//  Created by Guilherme Pedriconi on 10/04/19.
//  Copyright © 2019 Pedriconi. All rights reserved.
//

import UIKit
import SDWebImage

class MovieController: UIViewController {
    var movieSelected:Movie = Movie()
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtOverview: UITextView!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var lblDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    let imgUrl = URL(string: movieSelected.photo!)

     self.title = movieSelected.title!
     lblDate.text = movieSelected.release!
     lblTitle.text = movieSelected.title!
     imgView.sd_setImage(with: imgUrl , placeholderImage: UIImage(named: "placeholder.png"))
     txtOverview.text = movieSelected.overview!
     self.adjustView(txtOverview)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func adjustView(_ view: UIView){
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds      = true
        view.layer.cornerRadius = 10
        

    }


}

