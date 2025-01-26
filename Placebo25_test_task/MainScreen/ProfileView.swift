//
//  ProfileView.swift
//  Placebo25_test_task
//
//  Created by Dmitry on 26.01.2025.
//

import UIKit
import SnapKit
import DGCharts

enum Fonts {
    static var SFProDisplayMedium: String { "SFProDisplay-Medium"}
}

protocol ProfileViewProtocol: UIView {
    
    //MARK: - Input
    func setupAvatar(image: UIImage)
    func setupName(name: String)
    func setupAge(age: Int)
    func setupMainFeature(name: String)
    func updatePieChart(entries: Set<ChartEntry>)

}

final class ProfileView: UIView, ProfileViewProtocol {
    
    private lazy var avatarImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 26
        imageView.image = UIImage.monk
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Fonts.SFProDisplayMedium, size: 20)
        return label
    }()
    
    private lazy var ageLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: Fonts.SFProDisplayMedium, size: 16)
        return label
    }()
    
    private lazy var mainFeatureLabel: UILabel = {
        var label = UILabel()
        label.text = "Исследователь"
        label.textColor = .white
        label.font = UIFont(name: Fonts.SFProDisplayMedium, size: 16)
        return label
    }()
    
    private lazy var mainInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(mainFeatureLabel)
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var pieChartView: PieChartView = {
        let pieChartView = PieChartView()
        pieChartView.drawHoleEnabled = false
        pieChartView.rotationEnabled = true
        pieChartView.legend.enabled = true
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawEntryLabelsEnabled = false
        
        let legend = pieChartView.legend
        legend.font = UIFont(name: Fonts.SFProDisplayMedium, size: 16) ?? .systemFont(ofSize: 16)
        legend.textColor = .white
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .vertical

        return pieChartView
    }()
    
    private var chartTapGR: UITapGestureRecognizer?
    private var avatarTapGR: UITapGestureRecognizer?
    private var pieChartEntries: [PieChartDataEntry] = []
    
    weak var controller: ProfileViewControllerProtocol?
    
    init(controller: ProfileViewControllerProtocol) {
        self.controller = controller
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        addSubview(avatarImageView)
        addSubview(mainInfoStackView)
        addSubview(pieChartView)
        backgroundColor = UIColor(
            red: 22.0 / 255.0,
            green: 22.0 / 255.0,
            blue: 22.0 / 255.0,
            alpha: 0.93
        )
        chartTapGR = UITapGestureRecognizer(target: self, action: #selector(chartTapped))
        pieChartView.addGestureRecognizer(chartTapGR!)
        avatarTapGR = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(avatarTapGR!)
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(130)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        mainInfoStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
        }
        
        pieChartView.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(300)
            make.centerX.equalToSuperview()
            make.top.equalTo(mainInfoStackView.snp.bottom).offset(40)
        }
    }
    
    private func configurePieChartDataSet(entries: [PieChartDataEntry]) -> PieChartDataSet {
        let dataSet = PieChartDataSet(entries: entries)
        dataSet.colors = ChartColorTemplates.pastel()
        dataSet.valueTextColor = .white
        dataSet.valueFont = UIFont(name: Fonts.SFProDisplayMedium, size: 12) ?? .systemFont(ofSize: 12)
        dataSet.drawValuesEnabled = true
        dataSet.drawIconsEnabled = false
        dataSet.label = nil
        let formatter = PercentFormatter()
        dataSet.valueFormatter = formatter
        return dataSet
    }
    
    func updatePieChart(entries: Set<ChartEntry>) {
        pieChartEntries = entries.map {
            PieChartDataEntry(value: $0.value, label: $0.name)
        }
        let dataSet = configurePieChartDataSet(entries: Array(pieChartEntries))
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.notifyDataSetChanged()
        pieChartView.animate(xAxisDuration: 0.7, easingOption: .linear)
    }
    
    func setupAvatar(image: UIImage) {
        avatarImageView.image = image
    }
    
    func setupName(name: String) {
        nameLabel.text = name
    }
    
    func setupAge(age: Int) {
        ageLabel.text = "Возраст: \(age)"
    }
    
    func setupMainFeature(name: String) {
        mainFeatureLabel.text = name
    }
    
    //MARK: - Selectors
    
    @objc
    private func chartTapped() {
        controller?.chartTapped()
    }
    
    @objc
    private func avatarTapped() {
        controller?.avatarTapped()
    }
}

fileprivate class PercentFormatter: NSObject, ValueFormatter {
    func stringForValue(_ value: Double, entry: DGCharts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: DGCharts.ViewPortHandler?) -> String {
        let percentage = round(value)
        return "\(Int(percentage))%"
    }
}
