//
//  MainRouter.swift
//  AppExtention
//
//  Created by  inna on 04/03/2021.
//

import Foundation


class DataManager {

    
   var sheredIdentifier =  "group.Appextention.swift.app"

   class func fetchedSharedData() -> String {
        if let shereData = UserDefaults.init(suiteName: sheredIdentifier) {
            ShedulerGCD.shared.schedule(with: "first", action: {
               print(shereData)
        })
            
       
    }
        return "first"
  }
}
