//
//  HTMLParser.swift
//  GettyImageViewer
//
//  Created by Chris Song on 14/04/2018.
//  Copyright © 2018 ChrisMJSong. All rights reserved.
//

import UIKit
import HTMLReader
import HTMLString

class HTMLParser: NSObject {

    /// get element from html string
    ///
    /// - Parameter htmlString: HTML String
    /// - Returns: HTML element
    class func elementFromHTMLString(_ htmlString: String) -> HTMLElement? {
        let document = HTMLDocument.init(string: htmlString)
        return document.bodyElement
    }
    
    /// get elements form root element
    ///
    /// - Parameters:
    ///   - root: root element
    ///   - names: node names
    /// - Returns: HTML elements
    class func subElementsFromHTMLElement(_ root: HTMLElement?, nodeNames names: Array<String>) -> Array<HTMLElement>? {
        var lastElement: HTMLElement? = root
        let lastIndex = names.count - 1
        for i in 0..<lastIndex {
            if lastElement == nil {
                // if cant find element, return nil
                return nil
            }
            lastElement = lastElement?.document?.firstNode(matchingSelector: names[i])
        }
        let elements = lastElement?.nodes(matchingSelector: names[lastIndex])
        
        return elements
    }
    
    /// get raw string(without tag) from html string
    ///
    /// - Parameter htmlString: HTML string
    /// - Returns: a string that tag removed.
    class func stringFromHTMLString(_ htmlString: String) -> String {
        return htmlString.removingHTMLEntities
    }
}
