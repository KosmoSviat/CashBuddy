//
//  TransactionTableViewCell.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//

import UIKit
import SnapKit

final class TransactionTableViewCell: UITableViewCell {
    
    // MARK: - GUI Variables
    private lazy var containerCellView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backgroundCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadiusValue
        view.alpha = CGFloat(0.15)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 3
        return view
    }()
    
    private lazy var signLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        return label
    }()
    
    private lazy var typePaymentLabel: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .white
        return view
    }()
    
    private lazy var categoryTransactionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Properties
    private let cardImage = UIImage(systemName: "creditcard.and.123")
    private let banknoteImage = UIImage(systemName: "banknote")
    
    private let cornerRadiusValue: CGFloat = 10
    private var indentValue5 = 5
    private let indentValue10 = 10
    private let indentValue20 = 20
    private let heightValue = 30
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configureCell(with transaction: Transaction) {
        signLabel.text = transaction.sign.rawValue
        sumLabel.text = transaction.sum
        typePaymentLabel.image = transaction.typePayment == .card ? cardImage : banknoteImage
        categoryTransactionLabel.text = "Category: ".localized + "\(transaction.categoryTransaction.rawValue.localized)"
        dateLabel.text = transaction.date.formattedDate()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubviews([backgroundCellView, containerCellView])
        containerCellView.addSubviews([signLabel, sumLabel, typePaymentLabel, categoryTransactionLabel, dateLabel])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerCellView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(indentValue5)
            make.leading.trailing.equalToSuperview().inset(indentValue10)
        }
        
        backgroundCellView.snp.makeConstraints { make in
            make.centerY.equalTo(containerCellView.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(indentValue10)
            make.height.equalTo(containerCellView.snp.height)
        }
        
        signLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(indentValue10)
        }
        
        sumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(signLabel.snp.centerY)
            make.leading.equalTo(signLabel.snp.trailing)
        }
        
        typePaymentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sumLabel.snp.centerY)
            make.leading.equalTo(sumLabel.snp.trailing).offset(indentValue10)
            make.trailing.lessThanOrEqualToSuperview().inset(indentValue10)
            make.width.height.equalTo(heightValue)
        }
        
        categoryTransactionLabel.snp.makeConstraints { make in
            make.top.equalTo(signLabel.snp.bottom).offset(indentValue5)
            make.leading.trailing.equalToSuperview().inset(indentValue10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTransactionLabel.snp.bottom).offset(indentValue5)
            make.leading.trailing.equalToSuperview().inset(indentValue10)
            make.bottom.equalToSuperview().inset(indentValue10)
        }
    }
}
