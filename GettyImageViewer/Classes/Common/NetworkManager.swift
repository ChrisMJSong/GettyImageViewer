//
//  NetworkManager.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import SwiftyJSON

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    var sessionManager: Alamofire.SessionManager? = nil
    
    private override init(){
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest  = 60
        configuration.timeoutIntervalForResource = 60
        
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
}
