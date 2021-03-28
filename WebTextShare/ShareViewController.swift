//
//  ShareViewController.swift
//  WebTextShare
//
//  Created by  inna on 01/02/2021.
//

import UIKit
import Social
import DFetcher


class ShareViewController: SLComposeServiceViewController {
    
    static let sheredIdentifier: String =  "group.test.inna.AppExtention"
    
    override func isContentValid() -> Bool {


            if let cText = self.contentText {
                UserDefaults(suiteName: ShareViewController.sheredIdentifier)?.set(cText, forKey: "first")
            }
       
        return true
    }
    
    override func didSelectPost() {
                
            let urlString = "openFromExtention://"
            if let url = URL(string: urlString)
            {
                self.extensionContext!.open(url, completionHandler: {success in print("called url complete handler: \(success)")})
            }
    }
    
    override func configurationItems() -> [Any]! {
               
        return []
    }
}
