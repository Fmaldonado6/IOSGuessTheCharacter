//
//  JikanDataSoure.swift
//  RESTTutorial
//
//  Created by Fernando Maldonado on 07/10/21.
//

import Foundation

class JikanDataSource{
    
    
    private let url = "https://api.jikan.moe/v3/top/characters/"
    
    
    func getCharacters() async throws -> [Character]{
        let randomPage = Int.random(in: 1...5)
        let formattedUrl = URL(string: "https://api.jikan.moe/v3/top/characters/\(randomPage)")
        let (data,_) = try await URLSession.shared.data(from: formattedUrl!)
        let animes = try JSONDecoder().decode(JikanResponse.self, from: data)
        return animes.top
    }
    
}


