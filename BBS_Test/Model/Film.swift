//
//  Film.swift
//  BBS_Test
//
//  Created by Clément Lavoisier on 04/05/2018.
//  Copyright © 2018 Clément Lavoisier. All rights reserved.
//

import Foundation

struct Film: Decodable {

    let title: String?
    let episode_id: Int?
    let opening_crawl: String?
    let director: String?
    let producer: String?
    let characters: [String]?
    let created: String?
    let edited: String?
    let release_date: Date?

}
