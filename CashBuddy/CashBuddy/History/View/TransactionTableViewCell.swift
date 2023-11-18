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
    private lazy var containerCellView = UIView()
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
    private lazy var signLabel = configureLabel(font: .boldSystemFont(ofSize: 25))
    private lazy var sumLabel = configureLabel(font: .boldSystemFont(ofSize: 25))
    private lazy var typePaymentImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .left
        view.tintColor = .white
        return view
    }()
    private lazy var sumStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        return stack
    }()
    private lazy var categoryTransactionLabel = configureLabel(font: .systemFont(ofSize: 17))
    private lazy var dateLabel = configureLabel(font: .systemFont(ofSize: 17))
    private lazy var cellStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = CGFloat(indentValue5)
        return stack
    }()
    
    // MARK: - Properties
    private let cardImage = UIImage(systemName: "creditcard.and.123")
    private let banknoteImage = UIImage(systemName: "banknote")
    
    private let cornerRadiusValue: CGFloat = 10
    private var indentValue5 = 5
    private let indentValue10 = 10
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
    private func configureLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }
    
    func configureCell(with transaction: Transaction) {
        signLabel.text = transaction.sign.rawValue
        sumLabel.text = "\(transaction.sum) "
        typePaymentImage.image = transaction.typePayment == .card ? cardImage : banknoteImage
        categoryTransactionLabel.text = "Category: ".localized + "\(transaction.categoryTransaction.rawValue.localized)"
        dateLabel.text = transaction.date.formattedDate()
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        addSubview(containerCellView)
        containerCellView.addSubviews([backgroundCellView, cellStack, sumStack])
        cellStack.addArrangedSubviews([sumStack, categoryTransactionLabel, dateLabel])
        sumStack.addArrangedSubviews([signLabel, sumLabel, typePaymentImage])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerCellView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(indentValue5)
            make.leading.trailing.equalToSuperview().inset(indentValue10)
        }
        
        backgroundCellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cellStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(indentValue10)
        }
    }
}
