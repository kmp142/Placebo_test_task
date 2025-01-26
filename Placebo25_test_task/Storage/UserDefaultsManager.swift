//
//  UserDefaultsManager.swift
//  Placebo25_test_task
//
//  Created by Dmitry on 26.01.2025.
//

import Foundation

protocol Storage {
    func saveData(key: String, value: Any)
    func getData(key: String) -> Any?
}

final class UserDefaultsManager: Storage {
    func saveData(key: String, value: Any) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func getData(key: String) -> Any? {
        let data = UserDefaults.standard.value(forKey: key)
        return data
    }
    
}
