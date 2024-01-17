//
//  SearchData.swift
//  DictHome
//
//  Created by Kholmumin Tursinboev on 17/01/24.
//

import Foundation

struct SearchData:Decodable {
    let word, phonetic: String?
    let meanings: [Meaning]
    let phonetics: [Phonetics]
    let sourceUrls: [String]
    
}


struct Phonetics:Decodable {
    let audio: String
    
}


struct Meaning: Decodable {
    let partOfSpeech: String
    let definitions: [Definition]
    let synonyms: [String]
    let antonyms: [String]
}


struct Definition:Decodable {
    let definition: String
    let synonyms, antonyms: [String]
    let example: String?
}


