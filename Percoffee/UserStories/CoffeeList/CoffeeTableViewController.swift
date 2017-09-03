//
//  CoffeeTableViewController.swift
//  Percoffee
//
//  Created by Andrew Vyazovoy on 03/09/2017.
//  Copyright © 2017 vyazovoy. All rights reserved.
//

import UIKit
import Moya

class CoffeeTableViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 240
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(CoffeeTableViewCell.self, forCellReuseIdentifier: "CoffeeTableViewCell")
        
        return tableView
    }()
    
    fileprivate var coffeeInfos: [CoffeeInfo] = [] {
        didSet {
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }
    
    private var currentRequest: Cancellable?
    
    private let dataProvider = PercolateProvider()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        navigationItem.title = "Percolate"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updateCoffee(sender:)), for: .valueChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCoffeeInfos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        currentRequest?.cancel()
        currentRequest = nil
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    private func updateCoffeeInfos() {
        guard currentRequest == nil else { return }
        
        tableView.refreshControl?.beginRefreshing()
        currentRequest = dataProvider.requestCoffeeInfos() { [weak self] (result) in
            switch result {
            case .success(let coffeeInfos):
                self?.coffeeInfos = coffeeInfos
            case .failure(let error):
                print(error)
            }
            self?.currentRequest = nil
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func updateCoffee(sender: UIRefreshControl) {
        updateCoffeeInfos()
    }
    
}

extension CoffeeTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTableViewCell", for: indexPath) as! CoffeeTableViewCell
        let coffeeInfo = coffeeInfos[indexPath.row]
        cell.imageURL = coffeeInfo.imageURL
        cell.name = coffeeInfo.name
        cell.info = coffeeInfo.info
        cell.tableView = tableView
        
        return cell
    }
    
}

extension CoffeeTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coffeeInfo = coffeeInfos[indexPath.row]
        let coffeeDetailViewController = CoffeeDetailViewController(coffeeInfo: coffeeInfo)
        show(coffeeDetailViewController, sender: self)
    }
    
}

