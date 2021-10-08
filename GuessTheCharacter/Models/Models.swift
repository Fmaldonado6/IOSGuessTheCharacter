//
//  Models.swift
//  RESTTutorial
//
//  Created by Fernando Maldonado on 07/10/21.
//

import Foundation

struct JikanResponse:Codable{
    var top:[Character]
}

struct Character:Codable{
    var mal_id:Int
    var title:String
    var image_url:String
}

enum Status{
    case Loading
    case Loaded
}
