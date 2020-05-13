//
//  CollectionView.swift
//  HousingSensei
//
//  Created by MonAster on 2019/12/1.
//  Copyright © 2019 InvictusProgramming. All rights reserved.
//

import UIKit

class CollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var theSearchView: UICollectionView!
    @IBOutlet weak var loadingMark: UIActivityIndicatorView!
    
    var collectionData: [RentDetail] = []
    var imageCache : [UIImage] = []
    let notFound: UIImage = UIImage(named: "image-not-found-1")!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCache.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = theSearchView.dequeueReusableCell(withReuseIdentifier: "houseItem", for: indexPath) as! CollectionViewCell
        let position = indexPath.row
        let thisHouse = collectionData[position]
        
        if(imageCache.count == 0){
            cell.cover.image = notFound
            cell.coverText.text = nil
        }
        else{
            cell.cover.image = imageCache[position]
            cell.coverText.text = thisHouse.address
            cell.priceText.text = thisHouse.price
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let infoVC: DetailedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailedVC") as! DetailedVC
        let position = indexPath.row
        let thisHouse = collectionData[position]
        infoVC.image = imageCache[position]
        infoVC.address = thisHouse.address
        infoVC.price = thisHouse.price
        infoVC.lat = thisHouse.lat
        infoVC.lon = thisHouse.lon
        
        self.present(infoVC, animated: true, completion: nil)

    }
    
    func cacheImages(isEmpty: Bool){
        if(isEmpty == false){
            for i in 0..<collectionData.count{
                
                if(collectionData[i].photo_count != 0){
                    let fullImageURL = collectionData[i].photo!
                    let imageURL = URL(string: fullImageURL)
                    let imageData = try? Data(contentsOf: imageURL!)
                    let poster = UIImage(data: imageData!)
                    imageCache.append(poster!)
                }
                else{
                    imageCache.append(notFound)
                }
                
                
            }
        }
    }
    
    func setupCollectionView(){
        theSearchView.dataSource = self
        theSearchView.delegate = self
        
    }
    
    @IBAction func toMap(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "mapPage") as! MapScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadingMark.isHidden = false
        imageCache = []
        theSearchView.reloadData()
        loadingMark.startAnimating()
        DispatchQueue.global().async {
            self.cacheImages(isEmpty: false)
            DispatchQueue.main.async {
                self.loadingMark.isHidden = true
                self.loadingMark.stopAnimating()
                self.theSearchView.reloadData()
            }
        }
        
        
        // Do any additional setup after loading the view.
        
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
