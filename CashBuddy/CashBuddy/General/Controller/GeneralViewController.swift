//
//  GeneralViewController.swift
//  CashBuddy
//
//  Created by Sviatoslav Samoilov on 4.09.2023.
//

import UIKit
import SnapKit

final class GeneralViewController: UIViewController {

    let store: AppStore

    // MARK: - GUI variables
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private lazy var containerScrollView = UIView()
    
    // MARK: BalanceView
    private lazy var balanceContainerView = UIView()
    private lazy var balanceBackgroundView = configureBackgroundView()
    private lazy var balanceTitleLabel = configureLabel(text: "balance".localized.uppercased(),
                                                        fontSize: 25,
                                                        textAlignment: .left,
                                                        shadows: true)
    private lazy var hideBalanceButton = configureButtonWithImage(imageSystemName: "eye",
                                                                  selector: #selector(hideBalanceAction))
    private lazy var balanceNumberLabel = configureLabel(text: "",
                                                         fontSize: 25,
                                                         textAlignment: .left,
                                                         shadows: true)
    
    // MARK: TransactionView
    private lazy var transactionContainerView = UIView()
    private lazy var transactionBackgroundView = configureBackgroundView()
    private lazy var transactionSumTextField = configureTextField(placeholderText: "sum".localized)
    private lazy var typePaymentButton = configureButtonWithImage(imageSystemName: "creditcard.and.123",
                                                                  selector: #selector(changeTypePayment))
    private lazy var stackCategory: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    private lazy var foodCategoryButton = configureButtonWithImage(imageSystemName: "takeoutbag.and.cup.and.straw",
                                                                   selector: #selector(selectCategory))
    private lazy var transportCategoryButton = configureButtonWithImage(imageSystemName: "car",
                                                                        selector: #selector(selectCategory))
    private lazy var medicineCategoryButton = configureButtonWithImage(imageSystemName: "cross",
                                                                       selector: #selector(selectCategory))
    private lazy var entertainmentCategoryButton = configureButtonWithImage(imageSystemName: "gamecontroller",
                                                                            selector: #selector(selectCategory))
    private lazy var clothCategoryButton = configureButtonWithImage(imageSystemName: "tshirt",
                                                                    selector: #selector(selectCategory))
    private lazy var householdCategoryButton = configureButtonWithImage(imageSystemName: "sofa",
                                                                        selector: #selector(selectCategory))
    private lazy var rentCategoryButton = configureButtonWithImage(imageSystemName: "house",
                                                                   selector: #selector(selectCategory))
    private lazy var stackTransactionButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = CGFloat(indentValue10)
        return stack
    }()
    private lazy var refillButton = configureTransactionButton(title: "refill".localized,
                                                               selector: #selector(plusButtonAction))
    private lazy var debitButton = configureTransactionButton(title: "debit".localized,
                                                              selector: #selector(minusButtonAction))
    
    // MARK: StatisticView
    private lazy var statisticsContainerView = UIView()
    private lazy var statisticsBackgroundView = configureBackgroundView()
    private lazy var statisticsTitleLabel = configureLabel(text: "statistics".localized.uppercased(),
                                                           fontSize: 25,
                                                           textAlignment: .left,
                                                           shadows: true)
    private lazy var refillTotalLabel = configureLabel(text: "",
                                                       fontSize: 20,
                                                       textAlignment: .left,
                                                       shadows: false)
    private lazy var debitTotalLabel = configureLabel(text: "",
                                                      fontSize: 20,
                                                      textAlignment: .left,
                                                      shadows: false)
    
    private lazy var foodStatisticLabel = configureLabel(text: "Food".localized,
                                                         fontSize: 18,
                                                         textAlignment: .left,
                                                         shadows: false)
    private lazy var foodSumStatisticLabel = configureLabel(text: "",
                                                            fontSize: 18,
                                                            textAlignment: .right,
                                                            shadows: false)
    private lazy var foodProgressView = configureCategoryProgressView(category: .food)
    
    
    private lazy var transportStatisticLabel = configureLabel(text: "Transport".localized,
                                                              fontSize: 18,
                                                              textAlignment: .left,
                                                              shadows: false)
    private lazy var transportSumStatisticLabel = configureLabel(text: "",
                                                                 fontSize: 18,
                                                                 textAlignment: .right,
                                                                 shadows: false)
    private lazy var transportProgressView = configureCategoryProgressView(category: .transport)
    
    private lazy var entertainmentStatisticLabel = configureLabel(text: "Entertainment".localized,
                                                                  fontSize: 18,
                                                                  textAlignment: .left,
                                                                  shadows: false)
    private lazy var entertainmentSumStatisticLabel = configureLabel(text: "",
                                                                     fontSize: 18,
                                                                     textAlignment: .right,
                                                                     shadows: false)
    private lazy var entertainmentProgressView = configureCategoryProgressView(category: .entertainment)
    
    private lazy var medicineStatisticLabel = configureLabel(text: "Medicine".localized,
                                                             fontSize: 18,
                                                             textAlignment: .left,
                                                             shadows: false)
    private lazy var medicineSumStatisticLabel = configureLabel(text: "",
                                                                fontSize: 18,
                                                                textAlignment: .right,
                                                                shadows: false)
    private lazy var medicineProgressView = configureCategoryProgressView(category: .medicine)
    
    private lazy var householdStatisticLabel = configureLabel(text: "Household".localized,
                                                              fontSize: 18,
                                                              textAlignment: .left,
                                                              shadows: false)
    private lazy var householdSumStatisticLabel = configureLabel(text: "",
                                                                 fontSize: 18,
                                                                 textAlignment: .right,
                                                                 shadows: false)
    private lazy var householdProgressView = configureCategoryProgressView(category: .household)
    
    private lazy var clothStatisticLabel = configureLabel(text: "Cloth".localized,
                                                          fontSize: 18,
                                                          textAlignment: .left,
                                                          shadows: false)
    private lazy var clothSumStatisticLabel = configureLabel(text: "",
                                                             fontSize: 18,
                                                             textAlignment: .right,
                                                             shadows: false)
    private lazy var clothProgressView = configureCategoryProgressView(category: .cloth)
    
    private lazy var rentStatisticLabel = configureLabel(text: "Rent".localized,
                                                         fontSize: 18,
                                                         textAlignment: .left,
                                                         shadows: false)
    private lazy var rentSumStatisticLabel = configureLabel(text: "",
                                                            fontSize: 18,
                                                            textAlignment: .right,
                                                            shadows: false)
    private lazy var rentProgressView = configureCategoryProgressView(category: .rent)
    
    // MARK: - Properties
    private let dataSource = TransactionsList.shared
    private var selectedPaymentType: PaymentType = .card
    private var selectedCategoryTransaction: CategoryTransaction = .defaultCategory
    private var balanceIsHide = false
    
    private var cardImage = UIImage(systemName: "creditcard.and.123")
    private var banknoteImage = UIImage(systemName: "banknote")
    private let cornerRadiusValue: CGFloat = 10
    private var indentValue5 = 5
    private let indentValue10 = 10
    private let indentValue20 = 20
    private let heightValue = 30
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        store.$state.sink { _ in
            updateUI()
        }

        registerObserver()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideOrShowBalance()
        setStatistics()
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForKeyboardNotification()
    }
    
    // MARK: - Methods
    private func hideOrShowBalance() {
        guard let isHide = UserDefaults.hideBalanceSetting?.bool(forKey: "balanceIsHide") else { return }
        balanceIsHide = isHide
        
        if balanceIsHide {
            hideBalanceButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            balanceNumberLabel.text = "****"
            refillTotalLabel.text = "Refill total: ".localized + "****"
            debitTotalLabel.text = "Debit total: ".localized + "****"
        } else {
            hideBalanceButton.setImage(UIImage(systemName: "eye"), for: .normal)
            setBalance()
        }
    }
    
    private func setBalance() {
        balanceNumberLabel.text = String(dataSource.balanceTotal)
        refillTotalLabel.text = "Refill total: ".localized + "\(dataSource.refillTotal)"
        debitTotalLabel.text = "Debit total: ".localized + "\(dataSource.debitTotal)"
    }
    
    @objc
    private func hideBalanceAction() {
        UserDefaults.hideBalanceSetting?.set(!balanceIsHide, forKey: "balanceIsHide")
        hideOrShowBalance()
    }
    
    @objc
    private func changeTypePayment() {
        if selectedPaymentType == .cash {
            typePaymentButton.setImage(cardImage, for: .normal)
            selectedPaymentType = .card
        } else {
            typePaymentButton.setImage(banknoteImage, for: .normal)
            selectedPaymentType = .cash
        }
    }
    
    @objc
    private func selectCategory(button: UIButton) {
        let category: CategoryTransaction
        
        switch button {
        case foodCategoryButton: category = .food
        case transportCategoryButton: category = .transport
        case entertainmentCategoryButton: category = .entertainment
        case medicineCategoryButton: category = .medicine
        case householdCategoryButton: category = .household
        case clothCategoryButton: category = .cloth
        case rentCategoryButton: category = .rent
        default: category = .defaultCategory
        }
        
        if selectedCategoryTransaction == category {
            selectedCategoryTransaction = .defaultCategory
        } else {
            selectedCategoryTransaction = category
        }
        updateCategoryButtonAppearance()
    }
    
    private func updateCategoryButtonAppearance() {
        foodCategoryButton.isSelected = selectedCategoryTransaction == .food
        transportCategoryButton.isSelected = selectedCategoryTransaction == .transport
        entertainmentCategoryButton.isSelected = selectedCategoryTransaction == .entertainment
        medicineCategoryButton.isSelected = selectedCategoryTransaction == .medicine
        householdCategoryButton.isSelected = selectedCategoryTransaction == .household
        clothCategoryButton.isSelected = selectedCategoryTransaction == .cloth
        rentCategoryButton.isSelected = selectedCategoryTransaction == .rent
    }
    
    @objc
    private func plusButtonAction() {
        saveTransaction(sign: .refill, typePayment: selectedPaymentType)
    }
    
    @objc
    private func minusButtonAction() {
        saveTransaction(sign: .debit, typePayment: selectedPaymentType)
    }
    
    private func saveTransaction(sign: TransactionType, typePayment: PaymentType) {
        guard let sumInt = Int(transactionSumTextField.text ?? "0"), sumInt >= 1 else { return }
        let transaction = Transaction(sign: sign,
                                      sum: String(sumInt),
                                      typePayment: typePayment,
                                      categoryTransaction: selectedCategoryTransaction,
                                      date: Date())
        TransactionPersistent.save(transaction)
        
        transactionSumTextField.resignFirstResponder()
        transactionSumTextField.text = ""
        selectedCategoryTransaction = .defaultCategory
        updateCategoryButtonAppearance()
        hideOrShowBalance()
        setStatistics()
    }
    
    private func setStatistics() {
        foodProgressView.progress = dataSource.getStatistics(category: .food).0
        transportProgressView.progress = dataSource.getStatistics(category: .transport).0
        entertainmentProgressView.progress = dataSource.getStatistics(category: .entertainment).0
        medicineProgressView.progress = dataSource.getStatistics(category: .medicine).0
        householdProgressView.progress = dataSource.getStatistics(category: .household).0
        clothProgressView.progress = dataSource.getStatistics(category: .cloth).0
        rentProgressView.progress = dataSource.getStatistics(category: .rent).0
        
        foodSumStatisticLabel.text = String(dataSource.getStatistics(category: .food).1)
        transportSumStatisticLabel.text = String(dataSource.getStatistics(category: .transport).1)
        entertainmentSumStatisticLabel.text = String(dataSource.getStatistics(category: .entertainment).1)
        medicineSumStatisticLabel.text = String(dataSource.getStatistics(category: .medicine).1)
        householdSumStatisticLabel.text = String(dataSource.getStatistics(category: .household).1)
        clothSumStatisticLabel.text = String(dataSource.getStatistics(category: .cloth).1)
        rentSumStatisticLabel.text = String(dataSource.getStatistics(category: .rent).1)
    }
    
    private func configureBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadiusValue
        view.alpha = CGFloat(0.15)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 3
        return view
    }
    
    private func configureLabel(text: String, fontSize: CGFloat, textAlignment: NSTextAlignment, shadows: Bool) -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: fontSize)
        label.textAlignment = textAlignment
        label.textColor = .sText
        label.text = text
        
        if shadows {
            label.layer.shadowColor = UIColor.black.cgColor
            label.layer.shadowOffset = CGSize(width: 2, height: 2)
            label.layer.shadowOpacity = 1
            label.layer.shadowRadius = 3
        }
        return label
    }
    
    private func configureButtonWithImage(imageSystemName: String, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageSystemName), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 3
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    private func configureTextField(placeholderText: String) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.font = .boldSystemFont(ofSize: 25)
        textField.textAlignment = .center
        textField.textColor = .black
        textField.tintColor = .black
        textField.layer.cornerRadius = cornerRadiusValue
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.sDark.withAlphaComponent(0.3),
                                                         .font: UIFont.boldSystemFont(ofSize: 20)]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        return textField
    }
    
    private func configureTransactionButton(title: String, selector: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.sDark, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.layer.cornerRadius = cornerRadiusValue
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 3
        return button
    }
    
    private func configureCategoryProgressView(category: CategoryTransaction) -> UIProgressView {
        let view = UIProgressView(progressViewStyle: .default)
        view.progressTintColor = .sText
        view.trackTintColor = .sDark
        return view
    }
    
    private func setupUI() {
        view.backgroundColor = .sBack
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerScrollView)
        containerScrollView.addSubviews([balanceBackgroundView, balanceContainerView,
                                         transactionBackgroundView, transactionContainerView,
                                         statisticsBackgroundView, statisticsContainerView])
        
        balanceContainerView.addSubviews([balanceTitleLabel, hideBalanceButton, balanceNumberLabel])
        
        transactionContainerView.addSubviews([transactionSumTextField, typePaymentButton, stackCategory, stackTransactionButton])
        stackCategory.addArrangedSubviews([foodCategoryButton, transportCategoryButton, entertainmentCategoryButton,
                                           medicineCategoryButton, householdCategoryButton, clothCategoryButton, rentCategoryButton])
        stackTransactionButton.addArrangedSubviews([refillButton, debitButton])
        
        statisticsContainerView.addSubviews([statisticsTitleLabel, refillTotalLabel, debitTotalLabel,
                                             foodStatisticLabel, foodSumStatisticLabel, foodProgressView,
                                             transportStatisticLabel, transportSumStatisticLabel, transportProgressView,
                                             entertainmentStatisticLabel, entertainmentSumStatisticLabel, entertainmentProgressView,
                                             medicineStatisticLabel, medicineSumStatisticLabel, medicineProgressView,
                                             householdStatisticLabel, householdSumStatisticLabel, householdProgressView,
                                             clothStatisticLabel, clothSumStatisticLabel, clothProgressView,
                                             rentStatisticLabel, rentSumStatisticLabel, rentProgressView])
        
        setupConstraints()
        updateCategoryButtonAppearance()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerScrollView.snp.makeConstraints { make in
            make.size.edges.equalToSuperview()
        }
        
        balanceContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(indentValue10)
        }
        
        balanceBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(balanceContainerView)
        }
        
        balanceTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(indentValue20)
        }
        
        hideBalanceButton.snp.makeConstraints { make in
            make.centerY.equalTo(balanceTitleLabel.snp.centerY)
            make.leading.equalTo(balanceTitleLabel.snp.trailing).offset(indentValue10)
            make.width.height.equalTo(heightValue)
        }
        
        balanceNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(indentValue10)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
            make.bottom.equalToSuperview().inset(indentValue20)
        }
        
        transactionContainerView.snp.makeConstraints { make in
            make.top.equalTo(balanceContainerView.snp.bottom).offset(indentValue20)
            make.leading.trailing.equalToSuperview().inset(indentValue10)
        }
        
        transactionBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(transactionContainerView)
        }
        
        transactionSumTextField.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(indentValue20)
            make.trailing.equalTo(typePaymentButton.snp.leading).offset(-indentValue10)
            make.height.equalTo(heightValue)
        }
        
        typePaymentButton.snp.makeConstraints { make in
            make.centerY.equalTo(transactionSumTextField.snp.centerY)
            make.trailing.equalToSuperview().inset(indentValue20)
            make.width.height.equalTo(heightValue)
        }
        
        stackCategory.snp.makeConstraints { make in
            make.top.equalTo(transactionSumTextField.snp.bottom).offset(indentValue10 + 5)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
            make.height.equalTo(heightValue)
        }
        
        stackTransactionButton.snp.makeConstraints { make in
            make.top.equalTo(stackCategory.snp.bottom).offset(indentValue10 + 5)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
            make.height.equalTo(heightValue)
            make.bottom.equalToSuperview().inset(indentValue20)
        }
        
        statisticsContainerView.snp.makeConstraints { make in
            make.top.equalTo(transactionContainerView.snp.bottom).offset(indentValue20)
            make.leading.trailing.equalToSuperview().inset(indentValue10)
        }
        
        statisticsBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(statisticsContainerView)
        }
        
        statisticsTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(indentValue20)
        }
        
        refillTotalLabel.snp.makeConstraints { make in
            make.top.equalTo(statisticsTitleLabel.snp.bottom).offset(indentValue10)
            make.leading.equalToSuperview().inset(indentValue20)
        }
        
        debitTotalLabel.snp.makeConstraints { make in
            make.top.equalTo(refillTotalLabel.snp.bottom).offset(indentValue10)
            make.leading.equalToSuperview().inset(indentValue20)
        }
        
        foodStatisticLabel.snp.makeConstraints { make in
            make.top.equalTo(debitTotalLabel.snp.bottom).offset(indentValue10)
            make.leading.equalToSuperview().inset(indentValue20)
        }
        
        foodSumStatisticLabel.snp.makeConstraints { make in
            make.centerY.equalTo(foodStatisticLabel.snp.centerY)
            make.leading.equalTo(foodStatisticLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(indentValue20)
        }
        
        foodProgressView.snp.makeConstraints { make in
            make.top.equalTo(foodStatisticLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
        }
        
        transportStatisticLabel.snp.makeConstraints { make in
            make.top.equalTo(foodProgressView.snp.bottom).offset(indentValue5)
            make.leading.equalToSuperview().inset(indentValue20)
        }
        
        transportSumStatisticLabel.snp.makeConstraints { make in
            make.centerY.equalTo(transportStatisticLabel.snp.centerY)
            make.leading.equalTo(transportStatisticLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(indentValue20)
        }
        
        transportProgressView.snp.makeConstraints { make in
            make.top.equalTo(transportStatisticLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
        }
        
        entertainmentStatisticLabel.snp.makeConstraints { make in
            make.top.equalTo(transportProgressView.snp.bottom).offset(indentValue5)
            make.leading.equalToSuperview().inset(indentValue20)
        }
        
        entertainmentSumStatisticLabel.snp.makeConstraints { make in
            make.centerY.equalTo(entertainmentStatisticLabel.snp.centerY)
            make.leading.equalTo(entertainmentStatisticLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(indentValue20)
        }
        
        entertainmentProgressView.snp.makeConstraints { make in
            make.top.equalTo(entertainmentStatisticLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
        }
        
        medicineStatisticLabel.snp.makeConstraints { make in
            make.top.equalTo(entertainmentProgressView.snp.bottom).offset(indentValue5)
            make.leading.equalToSuperview().inset(indentValue20)
        }
        
        medicineSumStatisticLabel.snp.makeConstraints { make in
            make.centerY.equalTo(medicineStatisticLabel.snp.centerY)
            make.leading.equalTo(medicineStatisticLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(indentValue20)
        }
        
        medicineProgressView.snp.makeConstraints { make in
            make.top.equalTo(medicineStatisticLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
        }
        
        householdStatisticLabel.snp.makeConstraints { make in
            make.top.equalTo(medicineProgressView.snp.bottom).offset(indentValue5)
            make.leading.equalToSuperview().inset(indentValue20)
        }
        
        householdSumStatisticLabel.snp.makeConstraints { make in
            make.centerY.equalTo(householdStatisticLabel.snp.centerY)
            make.leading.equalTo(householdStatisticLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(indentValue20)
        }
        
        householdProgressView.snp.makeConstraints { make in
            make.top.equalTo(householdStatisticLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
        }
        
        clothStatisticLabel.snp.makeConstraints { make in
            make.top.equalTo(householdProgressView.snp.bottom).offset(indentValue5)
            make.leading.equalToSuperview().inset(indentValue20)
        }
        
        clothSumStatisticLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clothStatisticLabel.snp.centerY)
            make.leading.equalTo(clothStatisticLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(indentValue20)
        }
        
        clothProgressView.snp.makeConstraints { make in
            make.top.equalTo(clothStatisticLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
        }
        
        rentStatisticLabel.snp.makeConstraints { make in
            make.top.equalTo(clothProgressView.snp.bottom).offset(indentValue5)
            make.leading.equalToSuperview().inset(indentValue20)
        }
        
        rentSumStatisticLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rentStatisticLabel.snp.centerY)
            make.leading.equalTo(rentStatisticLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(indentValue20)
        }
        
        rentProgressView.snp.makeConstraints { make in
            make.top.equalTo(rentStatisticLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(indentValue20)
            make.bottom.equalToSuperview().inset(indentValue20)
        }
    }
}

// MARK: - Keyboard events
extension GeneralViewController {
    func hideKeyboardWhenTappedAround() {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc
    func hideKeyboard() {
        scrollView.endEditing(true)
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        scrollView.contentInset.bottom = frame.height
    }
    
    @objc
    func keyboardWillHide() {
        scrollView.contentInset.bottom = .zero
    }
}

// MARK: - Observer
extension GeneralViewController {
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
    }
    
    @objc
    private func updateData() {
        dataSource.getTransactions()
    }
}

// MARK: - UserDefaults
extension UserDefaults {
    static let hideBalanceSetting = UserDefaults(suiteName: "hideBalanceSetting")
}
