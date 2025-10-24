//
//  UsersListViewController.swift
//  StackOverflowDemoApp
//
//  Created by Aleksandar Geyman on 24.10.25.
//

import UIKit

class UsersListViewController: UIViewController {
    private let viewModel = UsersListViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        viewModel.fetch { [weak self] isComplete in
            self?.setViewState(isComplete: isComplete)
        }
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: UserCell.IDENTIFIER, bundle: nil), forCellReuseIdentifier: UserCell.IDENTIFIER)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setEmptyState() {
        var config = UIContentUnavailableConfiguration.empty()
        config.image = UIImage(systemName: "face.smiling.inverse")
        config.text = "No Content Available"
        config.secondaryText = "We are sorry, something went wrong."
        contentUnavailableConfiguration = config
    }
    
    private func setViewState(isComplete: Bool) {
        if isComplete {
            runOnMainThread { [weak tableView] in
                tableView?.reloadData()
            }
        } else {
            runOnMainThread { [weak self] in
                guard let self else { return }
                tableView.isHidden = true
                setEmptyState()
            }
        }
        
        func runOnMainThread(execute work: @escaping () -> Void) {
            DispatchQueue.main.async(execute: work)
        }
    }
}

extension UsersListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: UserCell.IDENTIFIER) as? UserCell else {
            return UITableViewCell()
        }
        
        cell.delegate = viewModel
        cell.setData(viewModel.getUser(at: indexPath.row))
        return cell
    }
}
