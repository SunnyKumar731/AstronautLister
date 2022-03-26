//
//  AstronautDetailsViewController.swift
//  AstronautLister
//
//  Created by Sunny Kumar on 25/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import UIKit

class AstronautDetailsViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var viewModel: DetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.spacing = CGFloat(Utility.Constants.spacing)
        loadingSpinner.isHidden = false
        viewModel?.getDetails(completionHandler: { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
            self.loadingSpinner.isHidden = true
            switch result {
            case let .success(dataModel):
                    self.imgView.sd_setImage(with: URL(string: dataModel.profileImageUrl), placeholderImage: UIImage(named: "icons_load"))
                    self.stackView.addArrangedSubview(self.labelFor(text: "\(Utility.localisedStringfor(key: "name")): \n\(dataModel.name)"))
                    self.stackView.addArrangedSubview(self.labelFor(text: "\(Utility.localisedStringfor(key: "date_of_birth")): \n\(dataModel.dateOfBirth)"))
                    self.stackView.addArrangedSubview(self.labelFor(text: "\(Utility.localisedStringfor(key: "biography")): \n\(dataModel.bio)"))
                break
            case .failure:
                Utility.showErrorDialog(on: self)
            }
        }
        })
    }
    
    private func labelFor(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
}
