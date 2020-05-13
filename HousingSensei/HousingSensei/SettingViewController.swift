//
//  SettingViewController.swift
//  HousingSensei
//
//  Created by Mac for Rav on 12/2/19.
//  Copyright © 2019 InvictusProgramming. All rights reserved.
//

import UIKit

var priceSlider = 15000;
var distance = 10;

class SettingViewController: UIViewController {
    @IBOutlet weak var sliderO: UISlider!
    @IBOutlet weak var selectorO: UISegmentedControl!
    
    @IBAction func sliderA(_ sender: Any) {
        priceSlider = Int(sliderO.value)
        PriceO.text = "Budget: \(priceSlider)"
        UserDefaults.standard.set(priceSlider, forKey: "priceL")
    }
    @IBAction func selectorA(_ sender: Any) {
        switch selectorO.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(10, forKey: "dist")
        case 1:
            UserDefaults.standard.set(20, forKey: "dist")
        case 2:
            UserDefaults.standard.set(30, forKey: "dist")
        case 3:
            UserDefaults.standard.set(50, forKey: "dist")
        default:
            return
        }
    }
//    UserDefaults.standard.int(forKey: "dist")
//    UserDefaults.standard.int(forKey: "priceL")
    @IBOutlet weak var PriceO: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        assignbackground()
    }
    func assignbackground(){
        let background = UIImage(named: "settingC")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.alpha = 0.3
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
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
