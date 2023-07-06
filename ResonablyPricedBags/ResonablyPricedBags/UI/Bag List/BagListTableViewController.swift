//
//  BagListTableViewController.swift
//  ResonablyPricedBags
//
//  Created by Karl Pfister on 7/4/23.
//

import UIKit

class BagListTableViewController: UITableViewController, AlertPresentable {
    
    // MARK: - Properties
    var viewModel: BagListViewModel! // implecentlty unwrapped
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BagListViewModel(injectedDelegate: self) // hiring the person
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchAllBags()
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
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // what editing is the user trying to do?
        if editingStyle == .delete {
            // remove the object from FB
            viewModel.delete(indexPath: indexPath) {
                // closure Prevents the row from being deleted before we can update the SOT - must be on main
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        guard let destination = segue.destination as? BagDetailViewController else {return}
        // object to send
        if segue.identifier == "toDetailVC" {
            // the user is tapping on a cell
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let bag = viewModel.bagsSourceOfTruth?[indexPath.row]
            // in order to send the bag to the detail VC I need to inject that bag into the initialization of the bagDetailView Model
            destination.viewModel = BagDetailViewModel(bag: bag, injectedDelegate: destination)
        } else {
            // the user tapped on the plus button
            destination.viewModel = BagDetailViewModel(bag: nil, injectedDelegate: destination)
        }
    } // End of segue
    
} // End of VC

// Posting the job req
extension BagListTableViewController: BagListViewModelDelegate{
    // The job description
    func successfullyLoadedData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func encountered(_ error: Error) {
        presentAlert(message: error.localizedDescription, title: " Oh no!")
    }
}
