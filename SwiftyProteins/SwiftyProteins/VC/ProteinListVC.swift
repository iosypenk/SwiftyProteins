//
//  ProteinListVC.swift
//  SwiftyProteins
//
//  Created by Ivan OSYPENKO on 9/3/18.
//  Copyright © 2018 iosypenk & mrybak team. All rights reserved.
//

import UIKit

class ProteinListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let data = MyData()
    var name: String = ""

    @IBOutlet weak var proteinsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        proteinsList.delegate = self
        proteinsList.dataSource = self
        searchBar.delegate = self
        if data.proteinsArr.isEmpty {
            data.getProteinsArr()
        }
        loadingIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideIndicator()
        proteinsList.reloadData()
        
        
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        segmentedControll.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControll.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
        
    //MARK: -Loading Indicator show/hide
    
    private func showIndicator() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func hideIndicator() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    // MARK: -Rows
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !data.filteredArr.isEmpty {
            return data.filteredArr.count
        }
        return data.proteinsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProteinListCell {
            if !data.filteredArr.isEmpty {
                cell.set(name: data.filteredArr[indexPath.row])
                return cell
            }
            cell.set(name: data.proteinsArr[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: -Segue for selected row
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.cellForRow(at: indexPath)?.setHighlighted(false, animated: true)
        
       let name = !data.filteredArr.isEmpty ? data.filteredArr[indexPath.row] : data.proteinsArr[indexPath.row]
        showIndicator()
        callSegue(name)
    }
    
    fileprivate func callSegue(_ name: String) {
        self.name = name
        data.downloadProtein(name: name, completionHandler: { (response) in
            DispatchQueue.main.async {
                if let data = response {
                    self.data.pdbFile = data
                    self.performSegue(withIdentifier: "show", sender: self)
                    return
                }
                self.showAlert(error: "Error", message: "Connection failed")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let proteinVC = segue.destination as? ProteinVC else { return }
        proteinVC.pdbfile = self.data.pdbFile
        proteinVC.name = self.name
    }
    
    //MARK: -SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let name = searchBar.text else { return }
        let upperName = name.uppercased()
        if data.proteinsArr.contains(upperName) {
            showIndicator()
            callSegue(upperName)
        } else {
            self.showAlert(error: "Error", message: "No such name")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let toSearch = searchBar.text else { return }
        data.searchProtein(text: toSearch)
        proteinsList.reloadData()
    }
    
    //MARK: -Alert
    
    fileprivate func showAlert(error: String, message: String) {
        let alertController = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default , handler: nil)
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changeSort(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            data.proteinsArr.sort()
        case 1:
            data.proteinsArr.reverse()
        default:
            break
        }
        proteinsList.reloadData()
    }
}
