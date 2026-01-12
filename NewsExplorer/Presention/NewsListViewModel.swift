//
//  NewsListViewModel.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import Combine
import Foundation

final class NewsListViewModel: ObservableObject {

    @Published private(set) var articles: [Article] = []
    @Published private(set) var errorMessage: String?

    private let apiClient: APIClientProtocol
    private var cancellables = Set<AnyCancellable>()

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchNews() {
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
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        print(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] articles in
                    self?.articles = articles
                }
            )
            .store(in: &cancellables)
    }
}
