//
//  ParseLocal.swift
//  DictHome
//
//  Created by Kholmumin Tursinboev on 17/01/24.
//

import Foundation

struct ParseLocal{
    func loadJsonArray() -> [String]? {
        guard let url = Bundle.main.url(forResource: "all", withExtension: "json") else {
            print("Json file not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String]
            return jsonArray
        } catch {
            print("Error reading or parsing JSON:", error)
            return nil
        }
    }
}
