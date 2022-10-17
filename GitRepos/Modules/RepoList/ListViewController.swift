//
//  ListViewController.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import UIKit

enum RepoPage: Int {
    case startPage = 1
}

protocol ListViewInputs: AnyObject {
    func configure(entities: ListEntities?)
    func reloadTableView()
    func indicatorView(animate: Bool)
    func showErrorMessage(message: String)
}

final class ListViewController: UIViewController, Viewable {

    internal var viewModel: ListViewModel?
    internal var router: ListRouterOutput?
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(entities: viewModel?.entities)
        
        let request = SearchLanguageRequest(language:Constants.searchedRepoKeyWord, page:RepoPage.startPage.rawValue)

        viewModel?.fetchSearch(request: request)
    }

}

extension ListViewController: ListViewInputs {
    
    func showErrorMessage(message: String) {
        let alertController = UIAlertController(title: Constants.AlertTitle, message:message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title:Constants.AlertActionOk, style: .cancel, handler: { action in
            
        }))
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func configure(entities: ListEntities?) {
        navigationItem.title = "\(entities?.entryEntity.language ?? "") \(NSLocalizedString("list_screen_title", comment: ""))"
    }

    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }

    func indicatorView(animate: Bool) {
        DispatchQueue.main.async { [weak self] in
            animate ? self?.indicatorView?.startAnimating() : self?.indicatorView?.stopAnimating()
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.entities?.gitHubRepositories.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repo = viewModel?.entities?.gitHubRepositories[safe: indexPath.row] else { return UITableViewCell() }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constants.listCellIdentifier)
        cell.textLabel?.text = "\(repo.fullName)"
        cell.detailTextLabel?.textColor = UIColor.lightGray
        cell.detailTextLabel?.text = "\(repo.description)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedRepo = viewModel?.entities?.gitHubRepositories[safe: indexPath.row] else { return }
        router?.transitionDetail(gitHubRepository: selectedRepo)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleLastIndexPath = tableView.visibleCells.compactMap { [weak self] in
            self?.tableView.indexPath(for: $0)
        }.last
        guard let last = visibleLastIndexPath, last.row > (viewModel?.entities?.gitHubRepositories.count ?? 0) - Constants.seacondLastCell else { return }
        viewModel?.onReachBottom()
    }
}
