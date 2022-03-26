//
//  AstronautListViewController.swift
//  AstronautLister
//
//  Created by Sunny Kumar on 25/3/22.
//  Copyright © 2022 Sunny Kumar. All rights reserved.
//

import UIKit
import Combine

enum Section: CaseIterable {
    case defaultSection
}

class AstronautListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
       
       private var viewModel: ListViewModel?
       private let kCellIdentifier = "AstronautListTableViewCell"
       private let kReuseCellIdentifier = "ReuseCell"
       private lazy var dataSource = prepareDataSource()
       private var disposeBag = Set<AnyCancellable>()
       
       // To toggle asending and descending order
       private var ascending = false
       
       override func viewDidLoad() {
           super.viewDidLoad()
        title = Utility.localisedStringfor(key: "main_title")
           loadingSpinner.isHidden = false
           setUpTableView()
           setUpViewModel()
           configureBindings()
           setUpRefreshAction()
           setUpReordOrderChangeAction()
       }
       
       // MARK: - Private methods
       
       private func setUpViewModel() {
        viewModel = AstronautListViewModel(networkHandler: NetworkHandler())
           viewModel?.fetchDetails()
       }
       
       private func setUpTableView() {
           tableView.register(UINib(nibName: kCellIdentifier, bundle: nil), forCellReuseIdentifier: kReuseCellIdentifier)
           tableView.delegate = self
           tableView.rowHeight = UITableView.automaticDimension
           tableView.estimatedRowHeight = UITableView.automaticDimension
           tableView.separatorStyle = .singleLine
       }
    
       private func setUpRefreshAction() {
            let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
            navigationItem.leftBarButtonItem = refresh
            navigationItem.leftBarButtonItem?.isEnabled = false
       }
        
       @objc private func refreshTapped() {
            loadingSpinner.isHidden = false
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.isEnabled = false
            viewModel?.fetchDetails()
       }
       
       
       private func setUpReordOrderChangeAction() {
           let changeOrderButton = UIBarButtonItem(title: Utility.localisedStringfor(key: "change_Order_Button_Title"), style: .plain, target: self, action:#selector(changeRecordOrderTapped))
           changeOrderButton.isEnabled = false
           navigationItem.rightBarButtonItem = changeOrderButton
       }
       
       @objc private func changeRecordOrderTapped() {
           viewModel?.updateDetails(asendingOrder: ascending)
           ascending = !ascending
       }
       
       private func configureBindings() {
           viewModel?.dispalyDetails.sink(receiveValue: { [weak self] displayDetails in
               DispatchQueue.main.async {
                   self?.loadDetails(displayDetails)
               }
               }).store(in: &disposeBag)
       }
       
       private func loadDetails(_ displayDetails: AstronautListData) {
           guard displayDetails.status != .pending else {
               loadingSpinner.isHidden = false
               return
           }
           
           loadingSpinner.isHidden = true
           navigationItem.leftBarButtonItem?.isEnabled = true
           
           switch displayDetails.details {
           case let .success(datamodel):
               navigationItem.leftBarButtonItem?.isEnabled = false
               navigationItem.rightBarButtonItem?.isEnabled = true
               var snapshot = NSDiffableDataSourceSnapshot<Section, AstronautListDataModel>()
               snapshot.appendSections(Section.allCases)
               snapshot.appendItems(datamodel, toSection: .defaultSection)
               dataSource.apply(snapshot, animatingDifferences: false)
               
           case let .failure(networkError):
            handleError(networkError, on: self)
           }
       }
       
       private func prepareDataSource() -> UITableViewDiffableDataSource<Section, AstronautListDataModel> {
           let reuseCellIdentifier = kReuseCellIdentifier
           
           return UITableViewDiffableDataSource(
               tableView: tableView,
               cellProvider: { tableView, indexPath, dataRecord in
                   guard let cell = tableView.dequeueReusableCell(
                       withIdentifier: reuseCellIdentifier,
                       for: indexPath
                       ) as? AstronautListTableViewCell else { return UITableViewCell() }

                cell.configure(astronautDataModel: dataRecord)
                   return cell
               }
           )
       }
       
       // Here all errors are handling in generic way
    private func handleError(_ error: DataError, on viewController: UIViewController) {
        Utility.showErrorDialog(on: self)
    }
}

extension AstronautListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = viewModel?.getId(at: indexPath.row),
            let viewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AstronautDetailsViewController") as? AstronautDetailsViewController else { return }
        let detailsViewModel = AstronautDetailsViewModel(id: id)
        viewController.viewModel = detailsViewModel
        self.navigationController?.pushViewController (viewController, animated: true)
    }
}
