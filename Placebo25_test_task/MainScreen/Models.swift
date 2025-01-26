//
//  Models.swift
//  Placebo25_test_task
//
//  Created by Dmitry on 26.01.2025.
//

import UIKit

struct ProfileData {
    var name: String
    var age: Int
    var avatar: UIImage
}

struct ChartEntry: Hashable {
    let value: Double
    let name: String
}
