//
//  ShareViewController.swift
//  WebTextShare
//
//  Created by  inna on 01/02/2021.
//

import UIKit
import Social


class ShareViewController: SLComposeServiceViewController {
    
    
    var tableView: UITableView = .init()
    
    static let sheredIdentifier: String =  "group.test.inna.AppExtention"
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        if let cText = contentText {
            UserDefaults(suiteName: ShareViewController.sheredIdentifier)?.set(cText, forKey: "first")
        }
    
        return true
    }
    
    override func didSelectPost() {
                
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
               
        return []
    }
}
