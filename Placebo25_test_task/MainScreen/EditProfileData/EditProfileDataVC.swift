//
//  EditProfileDataVC.swift
//  Placebo25_test_task
//
//  Created by Dmitry on 26.01.2025.
//

import UIKit

final class EditProfileDataVC: UIViewController {
    
    private lazy var nameTextField: OffsetTextField = {
        let textField = OffsetTextField()
        textField.textColor = .white
        textField.backgroundColor = UIColor(
            red: 28.0 / 255.0,
            green: 29.0 / 255.0,
            blue: 31.0 / 255.0,
            alpha: 1
        )
        textField.layer.cornerRadius = 16
        let placeholderText = "Имя"

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        return textField
    }()
    
    private lazy var ageTextField: OffsetTextField = {
        let textField = OffsetTextField()
        textField.keyboardType = .numberPad
        textField.textColor = .white
        textField.backgroundColor = UIColor(
            red: 28.0 / 255.0,
            green: 29.0 / 255.0,
            blue: 31.0 / 255.0,
            alpha: 1
        )
        textField.layer.cornerRadius = 16
        let placeholderText = "Возраст"

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        return textField
    }()
    
    private lazy var inputStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(nameTextField)
        sv.addArrangedSubview(ageTextField)
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.addTarget(
            self,
            action: #selector(saveButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(
            self,
            action: #selector(closeButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private var viewModel: ProfileViewModelProtocol?
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(inputStackView)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
        view.backgroundColor = .black
    }
    
    private func setupConstraints() {
        inputStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(48)
            make.height.equalTo(120)
        }
        
        saveButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(16)
        }
        
        closeButton.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
        }
    }
    
    @objc
    private func saveButtonTapped() {
        guard let age = Int(ageTextField.text ?? "0"), age > 0 else { return }
        viewModel?.updateAge(age: age)
        viewModel?.updateName(name: nameTextField.text ?? "")
        dismiss(animated: true)
    }
    
    @objc
    private func closeButtonTapped() {
        dismiss(animated: true)
    }

}

fileprivate final class OffsetTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += 20
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect.origin.x += 20
        return rect
    }
}
