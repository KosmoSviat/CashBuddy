//
//  HistoryViewController.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//

import UIKit

final class HistoryViewController: UITableViewController {
    // MARK: - GUI variables
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "backgroundImage")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // MARK: - Properties
    private var dataSource = TransactionsList.shared
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerObserver()
    }
    
    private func setupUI() {
        tableView.backgroundColor = .sBack
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
        tableView.register(TransactionTableViewCell.self,
                           forCellReuseIdentifier: "TransactionTableViewCell")
    }
}

// MARK: - UITableViewDataSource
extension HistoryViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.sectionDates.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.MM.yyyy"
        return dateFormatter.string(from: dataSource.sectionDates[section])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = dataSource.sectionDates[section]
        return dataSource.transactionsByDate[date]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell",
                                                       for: indexPath) as? TransactionTableViewCell
        else { return UITableViewCell() }
        let date = dataSource.sectionDates[indexPath.section]
        if let transactions = dataSource.transactionsByDate[date] {
            let transaction = transactions[indexPath.row]
            cell.configureCell(with: transaction)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HistoryViewController {
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let transaction = self.dataSource.transactions[indexPath.row]
            TransactionPersistent.delete(transaction)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed.withAlphaComponent(0)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Observer
extension HistoryViewController {
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData),
                                               name: NSNotification.Name("Update"), object: nil)
    }

    @objc
    private func updateData() {
        dataSource.getTransactions()
        tableView.reloadData()
    }
}
