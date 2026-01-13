//
//  NewsListViewModel.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

enum ViewState<Value> {
    case idle
    case loading
    case loaded(Value)
    case empty
    case error(String)
}

import Combine
import Foundation

final class NewsListViewModel: ObservableObject {
    
    @Published private(set) var articles: [Article] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var state: ViewState<[Article]> = .idle
    
    
    @Published var searchText: String = ""
    @Published private(set) var filteredArticles: [Article] = []
    
    var displayedArticles: [Article] {
        isSearching ? filteredArticles : articles
    }
    
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private let apiClient: APIClientProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
        bindSearch()
    }
    
    func fetchNews() {
        state = .loading
        
        apiClient.request(NewsEndpoint.appleNews)
            .map { (response: NewsResponseDTO) in
                response.articles.map {
                    Article(
                        title: $0.title ?? "",
                        description: $0.description ?? "",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                }
            }
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    if case .failure(let error) = completion {
                        let message = error.localizedDescription
                        self.errorMessage = message
                        self.state = .error(message)
                        print(message)
                    }
                },
                receiveValue: { [weak self] articles in
                    guard let self else { return }
                    self.articles = articles
                    self.applyFilter(self.searchText)
                    if articles.isEmpty {
                        self.state = .empty
                    } else {
                        self.state = .loaded(articles)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Search binding
    
    private func bindSearch() {
        $searchText
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.applyFilter(query)
            }
            .store(in: &cancellables)
        
        $articles
            .combineLatest($searchText.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .map { articles, query -> [Article] in
                Self.filter(articles: articles, with: query)
            }
            .assign(to: &$filteredArticles)
    }
    
    private func applyFilter(_ query: String) {
        filteredArticles = Self.filter(articles: articles, with: query)
    }
    
    private static func filter(articles: [Article], with query: String) -> [Article] {
        let q = query.lowercased()
        guard !q.isEmpty else { return [] }
        return articles.filter { article in
            article.title.lowercased().contains(q) ||
            article.description.lowercased().contains(q)
        }
    }
}

