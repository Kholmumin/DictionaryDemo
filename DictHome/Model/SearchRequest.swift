//
//  SearchRequest.swift
//  DictHome
//
//  Created by Kholmumin Tursinboev on 17/01/24.
//


import Foundation



struct SearchRequest {
    
    func fetchData(for searchItem:String, completion: @escaping (Result<[SearchData], Error>) -> Void) {
        let wordApi = "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchItem)"
        
        guard let url = URL(string: wordApi) else {
            let urlError = NSError(domain: "DictHome", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(urlError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let dataError = NSError(domain: "DictHome", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(dataError))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([SearchData].self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Can not find the word")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

