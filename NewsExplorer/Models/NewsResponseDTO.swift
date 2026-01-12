//
//  NewsResponseDTO.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

struct NewsResponseDTO: Decodable {
    let articles: [ArticleDTO]
}

struct ArticleDTO: Decodable {
    let title: String?
    let description: String?
    let urlToImage: String?
}

