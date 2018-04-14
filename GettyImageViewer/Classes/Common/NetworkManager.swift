//
//  NetworkManager.swift
//  GettyImageViewer
//
//  Created by Chris Song on 13/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire
import HTMLReader
import SVProgressHUD

public typealias CompletionHandler = (_ result: String?, _ error: NetworkError?) -> Void
public typealias CompletionDataHandler = (_ result: Data?, _ error: NetworkError?) -> Void

public enum NetworkError: Int {
    case connection = -1009, ats = -1022, hostNotFound = -1003, unknown = 9999
    
    func localzedDescription() -> String {
        switch self {
        case .connection:  return NSLocalizedString("The Internet connection appears to be offline.", comment: "NetworkError - connection")
        case .ats:  return NSLocalizedString("The resource could not be loaded because the App Transport Security policy requires the use of a secure connection.", comment: "NetworkError - ats")
        case .hostNotFound:  return NSLocalizedString("A server with the specified hostname could not be found.", comment: "NetworkError - ats")
        case .unknown:  return NSLocalizedString("Unknown network error.", comment: "NetworkError - unknown")
        }
    }
}

class NetworkManager: NSObject {
    
    static let serverUrl = "http://www.gettyimagesgallery.com/"
    static let shared = NetworkManager()
    let disposeBag = DisposeBag()
    
    /// get page source from web page
    ///
    /// - Parameters:
    ///   - requestUrlString: target webpage
    ///   - completion: completion closure
    func stringFromWebPageSource(_ requestUrlString: String, _ completion: @escaping CompletionHandler){
        
        // show load indicator
        SVProgressHUD.show()
        RxAlamofire.requestString(.get, requestUrlString)
            .subscribe(onNext: { (respons, resultString) in
                completion(resultString, nil)
            }, onError: { (error) in
                SVProgressHUD.dismiss()
                let objError = error as NSError
                let nError = NetworkError.init(rawValue: objError.code)
                completion(nil, nError)
            }, onCompleted: {
                // hide load indicoatr
                SVProgressHUD.dismiss()
            }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    /// get getty page source string
    ///
    /// - Parameter completion: completion closure
    func loadGettyMainPageSource(_ completion: @escaping CompletionHandler){
        let requestUrlString = NetworkManager.serverUrl + "collections/archive/slim-aarons.aspx"
        stringFromWebPageSource(requestUrlString, completion)
    }
    
    /// get getty page source at detail page
    ///
    /// - Parameters:
    ///   - subUrlString: detail page url
    ///   - completion: completion closure
    func loadGettyDetailpageSource(subUrl subUrlString: String, _ completion: @escaping CompletionHandler){
        let requestUrlString = NetworkManager.serverUrl + subUrlString
        stringFromWebPageSource(requestUrlString, completion)
    }
    
    /// download image from url
    ///
    /// - Parameters:
    ///   - urlString: image url
    ///   - completion: completion closure
    func downloadImage(_ urlString: String, _ completion: @escaping CompletionDataHandler) {
        let requestUrlString = NetworkManager.serverUrl + urlString
        
        RxAlamofire.requestData(.get, requestUrlString).subscribe(onNext: { (response, data) in
            completion(data, nil)
        }, onError: { (error) in
            let objError = error as NSError
            let nError = NetworkError.init(rawValue: objError.code)
            completion(nil, nError)
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
