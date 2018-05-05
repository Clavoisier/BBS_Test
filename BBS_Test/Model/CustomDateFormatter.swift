//
//  CustomDateFormatter.swift
//  BBS_Test
//
//  Created by Clément Lavoisier on 05/05/2018.
//  Copyright © 2018 Clément Lavoisier. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let yyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static let ddMMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
}
