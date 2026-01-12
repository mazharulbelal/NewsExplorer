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
        bindViewModel()
        viewModel.fetchNews()
    }

    private func setupUI() {
        title = "News"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseID)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }


    private func bindViewModel() {
        viewModel.$articles
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

}


extension NewsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsCell.reuseID,
            for: indexPath
        ) as? NewsCell else {
            return UITableViewCell()
        }

        cell.configure(with: viewModel.articles[indexPath.row])
        return cell
    }
}
