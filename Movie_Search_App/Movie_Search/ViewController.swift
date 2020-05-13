//
//  ViewController.swift
//  Lab4
//
//  Created by Steve Li on 10/19/19.
//  Copyright © 2019 Steve Li. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var space: CGFloat = 10.0
    var theData: [Movie] = []
    var theImageCache: [UIImage] = []
    var originalImageCache: [UIImage] = []
    var theTitle: [String] = []
    var theReleaseDate: [String] = []
    var theVoteAverage: [Double] = []
    var theOverview: [String] = []
    var theVideoKey: [VideoKey] = []
    var theID: [Int] = []
    
    var searchBarIsEmpty = true
    var searchBarText = ""
    var filteredData: [Movie] = []
    var filteredImg: [UIImage] = []
    var filteredOriginalImg: [UIImage] = []
    var filteredTitle: [String] = []
    var filteredReleaseDate: [String] = []
    var filteredVoteAverage: [Double] = []
    var filteredOverview: [String] = []
    var filteredVideoKey: [VideoKey] = []
    var filterdID: [Int] = []
    
    var currentData: [Movie] = []
    var currentImg: [UIImage] = []
    var currentOriginalImg: [UIImage] = []
    var currentTitle: [String] = []
    var currentReleaseDate: [String] = []
    var currentVoteAverage: [Double] = []
    var currentOverview: [String] = []
    var currentVideoKey: [VideoKey] = []
    var currentID: [Int] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func setBackground(_ sender: Any) {
        let color: UIColor = UIColor.random()
        self.view.backgroundColor = color
        self.collectionView.backgroundColor = color
    }
    
    @IBAction func defaultBackground(_ sender: Any) {
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.white
    }
    
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        searchBar.delegate = self
        setupIndicator()
        indicator.startAnimating()
        attributeSource()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchMovie()
            self.cacheImage()
            self.cacheText()
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    func attributeSource() {
        let alert = "Attribute"
        let message = "This app used TMDB api as the source of the movie data."
        
        let alertController = UIAlertController(title: alert, message: message, preferredStyle: .alert)
        let skip = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(skip)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
    }
    
    func setupIndicator() {
        let frame = view.frame
        indicator.frame = frame
        indicator.style = .whiteLarge
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.red
        self.view.addSubview(indicator)
    }
    
    func fetchMovie() {
        if (searchBarIsEmpty) {
            theData = []
            let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=1e39f740912c95cd512cb5f0aec75125&language=en-US&page=1"
            guard let url = URL(string: urlString) else {return}
            
            let data = try! Data(contentsOf: url)
            let api = try! JSONDecoder().decode(APIResults.self, from: data)
            
            for movie in api.results! {
                self.theData.append(movie)
            }
        }
    }
    
    func cacheImage() {
        if (searchBarIsEmpty) {
            theImageCache = []
            originalImageCache = []
            for item in theData {
                if let path = item.poster_path {
                    let url = "https://image.tmdb.org/t/p/w500"+path
                    let url_original = "https://image.tmdb.org/t/p/original"+path
                    do {
                        let data = try Data(contentsOf: URL(string: url)!)
                        let data_original = try Data(contentsOf: URL(string: url_original)!)
                        let image = UIImage(data: data)
                        let image_original = UIImage(data: data_original)
                        theImageCache.append(image!)
                        originalImageCache.append(image_original!)
                    } catch {
                        theImageCache.append(#imageLiteral(resourceName: "Movie_Unavailable"))
                        originalImageCache.append(#imageLiteral(resourceName: "Movie_Unavailable"))
                    }
                } else {
                    theImageCache.append(#imageLiteral(resourceName: "Movie_Unavailable"))
                    originalImageCache.append(#imageLiteral(resourceName: "Movie_Unavailable"))
                }
            }
        }
    }
    
    func cacheText() {
        theVideoKey = []
        if (searchBarIsEmpty) {
            for item in theData {
                if let id = item.id {
                    theID.append(id)
                    let urlString = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=1e39f740912c95cd512cb5f0aec75125"
                    //print(urlString)
                     do {
                         let url = URL(string: urlString)
                         let data = try Data(contentsOf: url!)
                         let api = try! JSONDecoder().decode(APIVideoKey.self, from: data)
                         for key in api.results! {
                             self.theVideoKey.append(key)
                             break
                         }
                     //print(theVideoKey)
                     } catch {
                     
                     }
                    
                } else {
                    theID.append(0)
                }
                if let name = item.title {
                    theTitle.append(name)
                }
                else {
                    theTitle.append("No Title Available")
                }
                
                
                if let releaseDate = item.release_date {
                    theReleaseDate.append(releaseDate)
                }
                else {
                    theReleaseDate.append("No Release Date Available")
                }
                
    
                if let voteAvg = item.vote_average {
                    theVoteAverage.append(voteAvg)
                }
                else {
                    theVoteAverage.append(0.0)
                }

                if let overview = item.overview {
                    theOverview.append(overview)
                }
                else {
                    theOverview.append("No Overview Available")
                }
                
            }
        }
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil {
            searchBarText = searchBar.text!
        } else {
            return
        }
        if (searchBarText.isEmpty) {
            searchBarIsEmpty = true
        } else {
            searchBarIsEmpty = false
        }
        
        filteredData = []
        filteredImg = []
        filteredOriginalImg = []
        filteredTitle = []
        filteredReleaseDate = []
        filteredVoteAverage = []
        filteredOverview = []
        filterdID = []
        filteredVideoKey = []
        
        indicator.startAnimating()

        DispatchQueue.global(qos: .userInitiated).async {
        if (self.searchBarText.isEmpty) {
            self.currentTitle = self.theTitle
            self.currentData = self.theData
            self.currentImg = self.theImageCache
            self.currentOriginalImg = self.originalImageCache
            self.currentReleaseDate = self.theReleaseDate
            self.currentVoteAverage = self.theVoteAverage
            self.currentOverview = self.theOverview
            self.currentID = self.theID
            self.currentVideoKey = self.theVideoKey
            //self.indicator.stopAnimating()
        } else {
            if (self.searchBarText.contains(" ")) {
                self.searchBarText = self.searchBarText.replacingOccurrences(of: " ", with: "%20")
            }
            var urlString = "https://api.themoviedb.org/3/search/movie?api_key=1e39f740912c95cd512cb5f0aec75125&query="
            urlString += self.searchBarText
            guard let url = URL(string: urlString) else {return}
            do {
                let data = try Data(contentsOf: url)
                let api = try JSONDecoder().decode(APIResults.self, from: data)
                for movie in api.results! {
                    self.filteredData.append(movie)
                }
            } catch {
                
            }
            // cache data
            for item in self.filteredData {
                // append image
                if let path = item.poster_path {
                    let url = "https://image.tmdb.org/t/p/w500"+path
                    let url_original = "https://image.tmdb.org/t/p/original"+path
                    do {
                        let data = try Data(contentsOf: URL(string: url)!)
                        let data_original = try Data(contentsOf: URL(string: url_original)!)
                        let image = UIImage(data: data)
                        let image_original = UIImage(data: data_original)
                        self.filteredImg.append(image!)
                        self.filteredOriginalImg.append(image_original!)
                    } catch {
                        self.filteredImg.append(#imageLiteral(resourceName: "Movie_Unavailable"))
                        self.filteredOriginalImg.append(#imageLiteral(resourceName: "Movie_Unavailable"))
                    }
                } else {
                    self.filteredImg.append(#imageLiteral(resourceName: "Movie_Unavailable"))
                    self.filteredOriginalImg.append(#imageLiteral(resourceName: "Movie_Unavailable"))
                }
                // append id and video key
                if let id = item.id {
                    self.filterdID.append(id)
                    let urlString = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=1e39f740912c95cd512cb5f0aec75125"
                     do {
                         let url = URL(string: urlString)
                         let data = try Data(contentsOf: url!)
                         let api = try! JSONDecoder().decode(APIVideoKey.self, from: data)
                         for key in api.results! {
                            self.filteredVideoKey.append(key)
                            break
                         }
                     } catch {
                        self.filteredVideoKey.append(VideoKey(key: ""))
                     }
                }
                else {
                    self.filterdID.append(0)
                }
                
                // append title
                if let name = item.title {
                    if (item.title == "") {
                        self.filteredTitle.append("No Title Available")
                    } else {
                        self.filteredTitle.append(name)
                    }
                } else {
                    self.filteredTitle.append("No Title Available")
                }
                // append release date
                if let date = item.release_date {
                    if (item.release_date == "") {
                        self.filteredReleaseDate.append("No Release Date Available")
                    } else {
                        self.filteredReleaseDate.append(date)
                    }
                } else {
                    self.filteredReleaseDate.append("No Release Date Available")
                }
                // append vote average
                if let vote = item.vote_average {
                    self.filteredVoteAverage.append(vote)
                } else {
                    self.filteredVoteAverage.append(0)
                }
                // append overview
                if let overview = item.overview {
                    if (item.overview == "") {
                        self.filteredOverview.append("No Overview Available")
                    } else {
                        self.filteredOverview.append(overview)
                    }
                } else {
                    self.filteredOverview.append("No Overview Available")
                }
            }
            self.currentTitle = self.filteredTitle
            self.currentData = self.filteredData
            self.currentImg = self.filteredImg
            self.currentOriginalImg = self.filteredOriginalImg
            self.currentReleaseDate = self.filteredReleaseDate
            self.currentVoteAverage = self.filteredVoteAverage
            self.currentOverview = self.filteredOverview
            self.currentID = self.filterdID
            self.currentVideoKey = self.filteredVideoKey
            //self.indicator.stopAnimating()
            print(self.currentVideoKey)
        }
        DispatchQueue.main.async {
        self.indicator.stopAnimating()
        self.collectionView.reloadData()
        }
        }
        }
    func takeScreenShot(_ sender: Any) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        let contxt = UIGraphicsGetCurrentContext()
        view.layer.render(in: contxt!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil)
        return img!
    }
    
    @IBAction func share(_ sender: Any) {
        // reference: 'http://www.thomashanning.com/mfmailcomposeviewcontroller/'
        let title = "Share Status"
        var message = "Please set up an email account on an actual device first"
        if (MFMailComposeViewController.canSendMail()){
            let screenShot = takeScreenShot(sender)
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            
            mailComposeViewController.setToRecipients(["zhaoqi.li@wustl.edu"])
            mailComposeViewController.setSubject("Search Content: " + searchBar.text!)
            mailComposeViewController.setMessageBody("This is my screenshot!!!", isHTML: false)
            mailComposeViewController.addAttachmentData(screenShot.pngData()!, mimeType: "image/png", fileName: "screenshot.png")
            self.present(mailComposeViewController, animated: true, completion: nil)
            message = "Your email has been successfully sent!"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}


extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (searchBarIsEmpty) {
            return 20
        } else {
            return filteredData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowNum: CGFloat = 3
        let totalSpacing = CGFloat(40.5)
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing)/rowNum
            return CGSize(width: width, height: 1.72 * width)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (searchBarText.isEmpty) {
            currentTitle = theTitle
            currentData = theData
            currentImg = theImageCache
            currentOriginalImg = originalImageCache
            currentReleaseDate = theReleaseDate
            currentVoteAverage = theVoteAverage
            currentOverview = theOverview
            currentID = theID
            currentVideoKey = theVideoKey
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 124, height: 214))
        cell.contentView.addSubview(imgView)
        let label = UILabel(frame: CGRect(x: 0, y: 164, width: 124, height: 50))
        
        if (currentImg.count != 0) {
            if (indexPath.row < currentImg.count) {
                imgView.image = currentImg[indexPath.row]
                label.text = currentTitle[indexPath.row]
                label.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
                label.textColor = UIColor.white
                label.textAlignment = .center
                label.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
                label.lineBreakMode = .byWordWrapping
                label.numberOfLines = 2
                imgView.addSubview(label)
            } else {
                //imgView.image = #imageLiteral(resourceName: "Movie_Unavailable")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(currentVideoKey)
        let detailedVC = DetailedViewController()
        if (!theImageCache.isEmpty) {
            detailedVC.imageName = currentTitle[indexPath.row]
            detailedVC.image = currentOriginalImg[indexPath.row]
            detailedVC.releaseDate = currentReleaseDate[indexPath.row]
            detailedVC.voteAvg = currentVoteAverage[indexPath.row]
            detailedVC.overview = currentOverview[indexPath.row]
        }
        if (!currentVideoKey.isEmpty) {
            if (indexPath.row < currentVideoKey.count) {
                if (currentVideoKey[indexPath.row].key == "" || currentVideoKey[indexPath.row].key == nil) {

                } else {
                detailedVC.videoKey = currentVideoKey[indexPath.row].key
                }
            }
        }
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

