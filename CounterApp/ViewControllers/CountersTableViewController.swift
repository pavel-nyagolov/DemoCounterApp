//
//  CountersTableViewController.swift
//  CounterApp
//
//  Created by Pavel on 6.04.23.
//

import UIKit

class CountersTableViewController: UITableViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var isEditingClicked = false
    var refreshDataControl: UIRefreshControl?
    var loadingView = LoadingView()
    var counters: [CounterModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
        
        NotificationCenter.default.addObserver(forName: .updateData, object: nil, queue: OperationQueue.main) { (_) in
            self.updateData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startSpinner()
        updateData()
    }
    
    func updateData() {
        DispatchQueue.main.async {
            guard let counterArray = FactoryStorage.getCounters() else {
                return
            }
            self.counters = counterArray
            self.refreshDataControl?.endRefreshing()
            self.stopSpinner()
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        guard !counters.isEmpty else {
            sender.title = "Edit"
            isEditingClicked = false
            tableView.setEditing(false, animated: true)
            return
        }
        
        if !isEditingClicked {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            isEditingClicked = true
        } else {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            isEditingClicked = false
        }
    }
    
    func addRefreshControl(){
        refreshDataControl = UIRefreshControl()
        refreshDataControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshDataControl!)
    }
    
    @objc func refresh(sender: UIRefreshControl){
        updateData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if counters.isEmpty {
            let label = UILabel()
            label.text = "No Counters"
            label.textAlignment = .center
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return counters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.counterCell) else {
            return UITableViewCell()
        }
        
        let counter = counters[indexPath.row]
        cell.textLabel?.text = counter.title
        cell.detailTextLabel?.text = "Count: \(counter.count)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCounter = counters[indexPath.row]
        performSegue(withIdentifier: Constants.countingView, sender: selectedCounter)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueDestination = segue.destination as? CounterViewController else {
            return
        }
        
        segueDestination.counter = sender as? CounterModel
    }
    
}

extension CountersTableViewController {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        FactoryStorage.deleteCounter(counters[indexPath.row])
        updateData()
    }
}

extension CountersTableViewController {
    func startSpinner() {
        
        loadingView.spinnerView = UIView(frame: self.view.bounds)
        
        loadingView.blurEffectView = UIVisualEffectView(effect: loadingView.blurEffect)
        loadingView.blurEffectView?.frame = self.view.bounds
        loadingView.blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        loadingView.spinner.center = loadingView.spinnerView!.center
        loadingView.spinner.startAnimating()
        loadingView.spinnerView!.addSubview(loadingView.spinner)
        
        let textLabel = UILabel(frame: CGRect(x: 0,
                                              y: self.loadingView.spinner.frame.midY + 24,
                                              width: self.view.frame.width,
                                              height: 20))
        
        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 16, weight: .ultraLight)
        textLabel.text = "Loading..."
        
        loadingView.spinnerView?.addSubview(textLabel)
        
        self.view.addSubview(loadingView.blurEffectView!)
        self.view.addSubview(loadingView.spinnerView!)
    }
    
    func stopSpinner() {
        loadingView.blurEffectView?.removeFromSuperview()
        loadingView.blurEffectView = nil
        
        loadingView.spinnerView?.removeFromSuperview()
        loadingView.spinnerView = nil
    }
}
