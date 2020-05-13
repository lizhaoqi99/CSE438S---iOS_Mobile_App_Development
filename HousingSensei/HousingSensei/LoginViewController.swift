//
//  LoginViewController.swift
//  HousingSensei
//
//  Created by Roger Wang on 11/30/19.
//  Copyright © 2019 InvictusProgramming. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import GoogleSignIn


class LoginViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    GIDSignIn.sharedInstance()?.presentingViewController = self
        //GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       //GIDSignIn.sharedInstance()?.uidelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
  
    
//    @IBAction func LoginTapped(_ sender: Any) {
//
//        let authUI = FUIAuth.defaultAuthUI()
//        guard authUI != nil else{
//            return
//        }
//
//        authUI?.delegate = self as? FUIAuthDelegate
//
////       let providers: [FUIAuthProvider] = [
////           FUIGoogleAuth()
////           ]
////
////        self.authUI.providers = providers
//        let authViewController = authUI!.authViewController()
//
//           present(authViewController, animated: true, completion: nil)
//
//
//
//    }
    func configureView(){
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "LoginCover.png")!)
        
    }
    
    
    
    func transitionToHome(){
        
        if #available(iOS 13.0, *) {
            let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UITabBarController
                view.window?.rootViewController = homeViewController
                        view.window?.makeKeyAndVisible()
    
            // Fallback on earlier versions
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

extension LoginViewController: GIDSignInDelegate{
      
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
      
         if let error = error{
             print(error.localizedDescription)
             return
         }else{
             guard let authentication = user.authentication else { return }
              let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
      
           
      Auth.auth().signIn(with: credential){ (result,error) in
                 if error == nil{
                     print(result?.user.email)
                     print(result?.user.displayName)
                      
                  
                  
                  // user is signed in
                      
                  self.transitionToHome()
                 }else{
                     print(error?.localizedDescription)
                 }
             }
         }
  }
    
  }
