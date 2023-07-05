//
//  BagListTableViewController.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/4/23.
//

import UIKit

class BagListTableViewController: UITableViewController {

    // MARK: - Properties
    var viewModel: BagListViewModel! // implecentlty unwrapped
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BagListViewModel(injectedDelegate: self) // hiring the person
      
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return viewModel.bagsSourceOfTruth?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bagCell", for: indexPath) as! BagTableViewCell
        let bag = viewModel.bagsSourceOfTruth?[indexPath.row]
        // Configure the cell...
        cell.configure(with: bag)
        return cell
    }
    


} // End of VC

// Posting the job req
extension BagListTableViewController: BagListViewModelDelegate {
    // The job description
    func successfullyLoadedData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
