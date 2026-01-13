//
//  NewsListViewController.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//
import UIKit
import Combine

final class NewsListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No articles available."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()
    
    private lazy var searchController: UISearchController = {
        let searchBar = SearchControllerProvider.shared.makeSearchController(placeholder: "Search articles")
        searchBar.searchResultsUpdater = self
        return searchBar
    }()
    
    private let viewModel: NewsListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearch()
        bindViewModel()
        viewModel.fetchNews()
    }
    
    private func setupUI() {
        title = "News"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseID)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSearch() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func bindViewModel() {

        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self else { return }
                if self.viewModel.isSearching { return }
                self.updateUI(for: state)
            }
            .store(in: &cancellables)
        
        viewModel.$searchText
            .combineLatest(viewModel.$filteredArticles)
            .receive(on: RunLoop.main)
            .sink { [weak self] _, _ in
                guard let self else { return }
                if self.viewModel.isSearching {
                    let hasResults = !self.viewModel.filteredArticles.isEmpty
                    self.setContentVisibility(showTable: hasResults, showEmpty: !hasResults)
                } else {
                    self.updateUI(for: self.viewModel.state)
                }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI State Handling
    
    private func updateUI(for state: ViewState<[Article]>) {
        switch state {
        case .idle:
            LoaderView.hide()
            setContentVisibility(showTable: true, showEmpty: false)
            
        case .loading:
            LoaderView.show(on: view)
            setContentVisibility(showTable: false, showEmpty: false)
            
        case .loaded:
            LoaderView.hide()
            setContentVisibility(showTable: true, showEmpty: false)
            
        case .empty:
            LoaderView.hide()
            setContentVisibility(showTable: false, showEmpty: true)
            
        case .error(let message):
            LoaderView.hide()
            setContentVisibility(showTable: false, showEmpty: false)
            AlertManager.shared.showAlert(title: "", message: message)
        }
    }
    
    private func setContentVisibility(showTable: Bool, showEmpty: Bool) {
        tableView.isHidden = !showTable
        emptyLabel.isHidden = !showEmpty
    }
}


extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.displayedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsCell.reuseID,
            for: indexPath
        ) as? NewsCell else {
            return UITableViewCell()
        }
        
        let article = viewModel.displayedArticles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
}


// MARK: - UISearchResultsUpdating
extension NewsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}
