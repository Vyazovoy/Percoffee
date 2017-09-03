//
//  CoffeeDetailViewController.swift
//  Percoffee
//
//  Created by Andrew Vyazovoy on 02/09/2017.
//  Copyright © 2017 vyazovoy. All rights reserved.
//

import UIKit
import Moya

final class CoffeeDetailViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        tableView.register(CoffeeDetailTableViewCell.self, forCellReuseIdentifier: "CoffeeDetailTableViewCell")
        
        return tableView
    }()
    
    private lazy var shareButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "SHARE", style: .plain, target: nil, action: nil)
        barButtonItem.tintColor = #colorLiteral(red: 0.9450980392, green: 0.4, blue: 0.137254902, alpha: 1)
        barButtonItem.setTitleTextAttributes([.font : UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        return barButtonItem
    }()
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        
        return formatter
    }()
    
    private let coffeeInfo: CoffeeInfo
    
    fileprivate var coffeeDetailInfo: CoffeeDetailInfo? {
        didSet {
            if isViewLoaded {
                navigationItem.title = coffeeDetailInfo?.name ?? navigationItem.title
                tableView.reloadData()
            }
        }
    }
    
    private var currentRequest: Cancellable?
    
    private let dataProvider = PercolateProvider()
    
    
    init(coffeeInfo: CoffeeInfo) {
        self.coffeeInfo = coffeeInfo
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = coffeeInfo.name
        
        shareButton.action = #selector(shareCoffee(sender:))
        shareButton.target = self
        navigationItem.rightBarButtonItem = shareButton
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
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(updateCoffee(sender:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCoffeeDetailInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        currentRequest?.cancel()
        currentRequest = nil
        
        super.viewWillDisappear(animated)
    }
    
    private func updateCoffeeDetailInfo() {
        guard currentRequest == nil else { return }
        
        tableView.refreshControl?.beginRefreshing()
        currentRequest = dataProvider.requestCoffeeDetailInfo(withCoffeeInfo: coffeeInfo) { [weak self] (result) in
            switch result {
            case .success(let coffeeDetailInfo):
                self?.coffeeDetailInfo = coffeeDetailInfo
            case .failure(let error):
                print(error)
            }
            self?.currentRequest = nil
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func shareCoffee(sender: UIBarButtonItem) {
        print("SHARE")
    }
    
    @objc private func updateCoffee(sender: UIRefreshControl) {
        updateCoffeeDetailInfo()
    }
    
}

extension CoffeeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeDetailTableViewCell", for: indexPath) as! CoffeeDetailTableViewCell
        cell.tableView = tableView
        cell.imageURL = coffeeDetailInfo?.imageURL
        cell.info = coffeeDetailInfo?.info
        cell.date = coffeeDetailInfo?.updateDate.flatMap() { dateFormatter.string(from: $0) }
        
        return cell
    }
    
}
