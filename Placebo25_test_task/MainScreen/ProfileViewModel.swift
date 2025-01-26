//
//  ProfileViewModel.swift
//  Placebo25_test_task
//
//  Created by Dmitry on 26.01.2025.
//

import UIKit
import Combine

protocol ProfileViewModelProtocol {
    
    //MARK: - Input
    
    func updateAge(age: Int)
    func updateName(name: String)
    func updateAvatar(image: UIImage)
    func updateChart()
    
    //MARK: - Output
    
    var profileDataSubject: CurrentValueSubject<ProfileData, Never> { get }
    var chartDataSubject: CurrentValueSubject<Set<ChartEntry>, Never> { get }

}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    //MARK: - Properties
    
    private lazy var profileData = ProfileData(
        name: storage.getData(key: "profileName") as? String ?? "Dmitry",
        age: storage.getData(key: "profileAge") as? Int ?? 39,
        avatar: 
            UIImage(data: storage.getData(key: "profileAvatar") as? Data ?? Data()) ?? UIImage.monk
    )
    
    private var chartEntries = Set<ChartEntry>()
    private var chartAttributes = [
        "Духовность",
        "Интуиция",
        "Физическое состояние"
        ]
    
    lazy var profileDataSubject = CurrentValueSubject<ProfileData, Never>(profileData)
    lazy var chartDataSubject = CurrentValueSubject<Set<ChartEntry>, Never>(chartEntries)
    private let storage: Storage
    
    //MARK: - Initialization
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func updateAge(age: Int) {
        profileData.age = age
        profileDataSubject.send(profileData)
        storage.saveData(key: "profileAge", value: profileData.age)
    }
    
    func updateName(name: String) {
        profileData.name = name
        profileDataSubject.send(profileData)
        storage.saveData(key: "profileName", value: profileData.name)
    }
    
    func updateAvatar(image: UIImage) {
        profileData.avatar = image
        profileDataSubject.send(profileData)
        if image.pngData() != nil {
            storage.saveData(key: "profileAvatar", value: image.pngData()!)
        }
    }
    
    func updateChart() {
        chartEntries.removeAll()
        for i in 0...2 {
            let entry = ChartEntry(value: Double.random(in: 20...50), name: chartAttributes[i])
            chartEntries.insert(entry)
        }
        chartDataSubject.send(chartEntries)
    }
}
