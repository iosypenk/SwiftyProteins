//
//  ProteinListVC.swift
//  SwiftyProteins
//
//  Created by Ivan OSYPENKO on 9/3/18.
//  Copyright © 2018 iosypenk & mrybak team. All rights reserved.
//

import UIKit

class ProteinListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
    var group : Bool = false
    
    let data = MyData()

    @IBOutlet weak var proteinsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        proteinsList.delegate = self
        proteinsList.dataSource = self
        searchBar.delegate = self
        data.getProteinsArr()
        loadingIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideIndicator()
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
        if !data.filteredArr.isEmpty{
            return data.filteredArr.count
        }
        return data.proteinsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
  
        if !data.filteredArr.isEmpty {
            cell.textLabel?.text = data.filteredArr[indexPath.row]
            return cell
        }
        cell.textLabel?.text = data.proteinsArr[indexPath.row]
        return cell
    }
    
    // MARK: -Sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if group == true {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let button = UIButton(type: .system)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .selected)
        button.backgroundColor = UIColor.darkText
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleExpandCLose), for: .touchUpInside)
        button.tag = section
        return button
    }
    
    @objc func handleExpandCLose(button: UIButton) {
        
//        let section = button.tag
//        var indexPaths = [IndexPath]()
//
//        for row in projects[section].arr.indices {
//            let indexPath = IndexPath(row: row, section: section)
//            indexPaths.append(indexPath)
//        }
//
//        let isExpanded = projects[section].isExpanded
//        tabBar.api?.poolsArray[section].isExpanded = !isExpanded
//
//        if isExpanded {
//            tableView.deleteRows(at: indexPaths, with: .fade)
//        } else {
//            tableView.insertRows(at: indexPaths, with: .fade)
//        }
    }
    
    // MARK: -Segue for selected row

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
       let name = !data.filteredArr.isEmpty ? data.filteredArr[indexPath.row] : data.proteinsArr[indexPath.row]
        showIndicator()
        callSegue(name)
    }
    
    fileprivate func callSegue(_ name: String) {
        data.downloadProtein(name: name, completionHandler: { (response) in
            DispatchQueue.main.async {
                if let data = response {
                    self.data.pdbFile = data
                    self.performSegue(withIdentifier: "show", sender: self)
                } else {
                    self.showAlert(error: "Error", message: "Connection failed")
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let proteinVC = segue.destination as? ProteinVC else { return }
        proteinVC.pdbfile = self.data.pdbFile
    }
    
    //MARK: -SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let name = searchBar.text else { return }
        if data.proteinsArr.contains(name) {
            showIndicator()
            callSegue(name)
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
    
    @IBAction func segmentHandler(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            group = false
        case 1:
            group = true
        default:
            break
        }
        proteinsList.reloadData()
    }
    
}
