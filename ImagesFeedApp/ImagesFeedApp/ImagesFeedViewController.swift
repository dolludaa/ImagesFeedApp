//
//  ViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import UIKit

class ImagesFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

enum AppConstants {
    static let accessKey = "o5yB0YPD0oWF6nDuI1F90yTQ1rOtbSkIRWoZ0krkbfE"
    static let secretKey = "PWqkolU55i36hIPKVQSitSBKG2KNTToZOWHEnEApVZE"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!

}