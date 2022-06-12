//
//  HypeListViewController.swift
//  HypeCloudKit
//
//  Created by Mitya Kim on 6/11/22.
//

import UIKit

class HypeListViewController: UIViewController {
    
    // MARK: - Properties
    var refresh: UIRefreshControl = UIRefreshControl()

    // MARK: - Outlets
    @IBOutlet weak var hypeListTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadData()
        setupVews()
    }
    
    // MARK: - Actions
    @IBAction func addHypeButtonTapped(_ sender: Any) {
        
        hypeAlertController(nil)
    }
    
    // MARK: - Helper Methods
    @objc func loadData() {
        
        HypeController.shared.fetchHypes { success in
            if success {
                self.updateViews()
            }
        }
    }
    
    func updateViews() {
        
        DispatchQueue.main.async {
            self.hypeListTableView.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    func setupVews() {
        
        hypeListTableView.delegate = self
        hypeListTableView.dataSource = self
        refresh.attributedTitle = NSAttributedString(string: "Pull")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        hypeListTableView.addSubview(refresh)
    }
    
    func hypeAlertController(_ hype: Hype?) {
        
        let alertController = UIAlertController(title: "New Hype", message: "Add New Hype", preferredStyle: .alert)
        
        alertController.addTextField { textfield in
            textfield.delegate = self
            textfield.placeholder = "Add Hype"
            textfield.autocorrectionType = .yes
            textfield.autocapitalizationType = .sentences
            
            if let hype = hype {
                textfield.text = hype.body
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            
            if let hype = hype {
                hype.body = text
                HypeController.shared.updateHype(with: hype) { success in
                    if success {
                        self.updateViews()
                    }
                }
            } else {
                HypeController.shared.createHype(with: text) { success in
                    if success {
                        self.updateViews()
                    }
                }
            }
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

// MARK: - Extensions
extension HypeListViewController: UITextFieldDelegate {}

extension HypeListViewController: UITableViewDelegate {}

extension HypeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HypeController.shared.hypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hypeListTableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        
        let hype = HypeController.shared.hypes[indexPath.row]
        cell.textLabel?.text = hype.body
        cell.detailTextLabel?.text = hype.timestamp.formatted()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let hypeToDelete = HypeController.shared.hypes[indexPath.row]
            guard let index = HypeController.shared.hypes.firstIndex(of: hypeToDelete) else { return }
            HypeController.shared.deleteHype(with: hypeToDelete) { success in
                HypeController.shared.hypes.remove(at: index)
                self.updateViews()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHype = HypeController.shared.hypes[indexPath.row]
        hypeAlertController(selectedHype)
    }
       
}
