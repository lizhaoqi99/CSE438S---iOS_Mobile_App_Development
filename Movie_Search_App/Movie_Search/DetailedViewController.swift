//
//  DetailedViewController.swift
//  Lab4
//
//  Created by Steve Li on 10/20/19.
//  Copyright © 2019 Steve Li. All rights reserved.
//
import MessageUI
import UIKit

class DetailedViewController: UIViewController {

    var image: UIImage!
    var imageName: String!
    var releaseDate: String!
    var voteAvg: Double!
    var overview: String!
    var fav: [String] = []
    var videoKey: String!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // navigation bar and the background
        navigationItem.title = imageName
        view.backgroundColor = UIColor.white
        
        // image
        let theImageFrame = CGRect(x: view.frame.midX/3, y: 105, width: view.frame.midX*4/3,
                                   height: view.frame.midY - 50)
        let imageView = UIImageView(frame: theImageFrame)
        imageView.image = image
        
        view.addSubview(imageView)
        
        // overview
        let theTextFrame_overview = CGRect(x: 30, y: view.frame.midY + 55, width: view.frame.width - 60, height: 165)
        let textView_overview = UILabel(frame: theTextFrame_overview)
        if (overview == "No Overview Available") {
            textView_overview.text = overview
        } else {
            textView_overview.text = "Overview: " + overview
        }
        textView_overview.font = UIFont(name: textView_overview.font.fontName, size: 15.0)
        textView_overview.textAlignment = .center
        textView_overview.lineBreakMode = .byWordWrapping
        textView_overview.numberOfLines = 0 // remove upper limit
        view.addSubview(textView_overview)
        
        // release date
        let theTextFrame_releaseDate = CGRect(x: 0, y: view.frame.midY + 220, width: view.frame.width, height: 30)
        let textView_releaseDate = UILabel(frame: theTextFrame_releaseDate)
        if (releaseDate == "No Release Date Available") {
            textView_releaseDate.text = "No Release Date Available"
        } else {
            textView_releaseDate.text = "Release date: " + releaseDate
        }
        textView_releaseDate.textColor = UIColor.black
        textView_releaseDate.textAlignment = .center
        view.addSubview(textView_releaseDate)
        
        // vote average
        let theTextFrame_voteAvg = CGRect(x: 0, y: view.frame.midY + 260, width: view.frame.width, height: 30)
        let textView_voteAvg = UILabel(frame: theTextFrame_voteAvg)
        if (voteAvg == 0.0) {
            textView_voteAvg.text = "Vote Average Unavailable"
        } else {
            textView_voteAvg.text = "Score: " + String(voteAvg) + " / 10"
        }
        textView_voteAvg.textColor = UIColor.black
        textView_voteAvg.textAlignment = .center
        view.addSubview(textView_voteAvg)
        
        // add favorite button
        
        let theButtonFrame = CGRect(x: view.frame.width/2 - 170, y: view.frame.midY + 310, width: view.frame.width/3, height: 30)
        let button = CirclularButton(frame: theButtonFrame)
        button.backgroundColor = UIColor.white
        button.setTitle("Add to Favorites", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2.0
        button.cornerRadius = 5
        button.addTarget(self, action: #selector(self.buttonAction_favorite(sender:)), for: .touchUpInside)
        view.addSubview(button)
        
        // add preview button
        let frame = CGRect(x: 100 + view.frame.width/3, y: view.frame.midY + 310, width: view.frame.width/3, height: 30)
        let button_preview = CirclularButton(frame: frame)
        button_preview.backgroundColor = UIColor.white
        button_preview.setTitle("Preview", for: .normal)
        button_preview.setTitleColor(UIColor.blue, for: .normal)
        button_preview.layer.borderColor = UIColor.blue.cgColor
        button_preview.layer.borderWidth = 2.0
        button_preview.cornerRadius = 5
        button_preview.addTarget(self, action: #selector(self.buttonAction_preview(sender:)), for: .touchUpInside)
        view.addSubview(button_preview)
        
    }
    
    @objc func buttonAction_favorite(sender: UIButton!) {
        let alert = "Add to Favorites"
        var message = "You have successfully added '" + imageName + "' to favorite movie list."
        
        if (UserDefaults.standard.array(forKey: "fav") != nil){
            fav = UserDefaults.standard.array(forKey: "fav") as! [String]
        }
        if (!fav.contains(imageName)){
            fav.append(imageName)
            UserDefaults.standard.set(fav, forKey: "fav")
        } else {
            message = "This movie is already in the favorite movie list."
        }
        let alertController = UIAlertController(title: alert, message: message, preferredStyle: .alert)
        let skip = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(skip)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func buttonAction_preview(sender: UIButton!) {
        if (videoKey == nil || videoKey == "") {
            
        } else {
            let urlString = "https://www.youtube.com/watch?v=" + videoKey
            print(urlString)
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
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
