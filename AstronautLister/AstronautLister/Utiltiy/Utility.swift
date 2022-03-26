//
//  Utility.swift
//  AstronautLister
//
//  Created by Sunny Kumar on 25/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import Foundation
import UIKit

struct Utility {
    enum Constants {
        static let spacing = 16.0
    }
    
    static func localisedStringfor(key: String) -> String {
        return NSLocalizedString(key, bundle: Bundle.main, comment: "")
    }
    
    static func showErrorDialog(on viewController: UIViewController) {
        let dialog = UIAlertController(title: "",
                                                 message: Utility.localisedStringfor(key:"generic_message_for_error"),
                                                 preferredStyle: .alert)
        let ok = UIAlertAction(title: Utility.localisedStringfor(key:"ok_button_title"), style: .default, handler: nil)//
                  
        dialog.addAction(ok)
        viewController.present(dialog, animated: true, completion: nil)
    }
}
