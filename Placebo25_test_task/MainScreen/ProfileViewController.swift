//
//  ProfileViewController.swift
//  Placebo25_test_task
//
//  Created by Dmitry on 26.01.2025.
//

import UIKit
import Combine

protocol ProfileViewControllerProtocol: AnyObject {
    func chartTapped()
    func avatarTapped()
}

final class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModelProtocol?
    var profileView: ProfileViewProtocol!
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupBindings()
        viewModel?.updateChart()
    }
    
    private func setupVC() {
        title = "Ваш профиль"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "pencil"),
            style: .plain,
            target: self,
            action: #selector(editProfileTapped)
        )
        
        editButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func setupBindings() {
        viewModel?.profileDataSubject.sink { [weak self] profileData in
            guard let self else { return }
            self.profileView.setupAge(age: profileData.age)
            self.profileView.setupName(name: profileData.name)
            self.profileView.setupAvatar(image: profileData.avatar)
        }.store(in: &subscriptions)
        
        viewModel?.chartDataSubject.sink { [weak self] chartEntries in
            self?.profileView.updatePieChart(entries: chartEntries)
        }.store(in: &subscriptions)
    }
    
    //MARK: - Selectors
    
    @objc
    private func editProfileTapped() {
        guard let viewModel else { return }
        let editProfileVC = EditProfileDataVC(viewModel: viewModel)
        present(editProfileVC, animated: true)
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func chartTapped() {
        viewModel?.updateChart()
    }
    
    func avatarTapped() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel?.updateAvatar(image: selectedImage)
        }
        dismiss(animated: true)
    }
}
