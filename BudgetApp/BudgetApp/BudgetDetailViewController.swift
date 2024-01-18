//
//  BudgetDetailViewController.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 15/1/24.
//

import UIKit
import CoreData

class BudgetDetailViewController: UIViewController {

    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<Transaction>!
    private var budgetCategory: BudgetCategory
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(.required, for: .horizontal)
        return textField
    }()
    
    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction amount"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(.required, for: .horizontal)
        return textField
    }()
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    lazy var saveTransactionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save Transaction", for: .normal)
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return button
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    lazy var amountLabel: UILabel = {
       let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()
    
    lazy var transactionTotalLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private func resetForm() {
        nameTextField.text = ""
        amountTextField.text = ""
        errorMessageLabel.text = ""
    }
    
    private func updateTransactionTotal() {
        transactionTotalLabel.text = budgetCategory.transactionTotal.formatAsCurrency()
    }
    
    init(persistentContainer: NSPersistentContainer, budgetCategory: BudgetCategory) {
        self.persistentContainer = persistentContainer
        self.budgetCategory = budgetCategory
        super.init(nibName: nil, bundle: nil)
        
        // create request based on selected budget category
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            errorMessageLabel.text = "Unable to fetch transactions."
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateTransactionTotal()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        
        //stackview
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        stackView.distribution = .fill
        
        stackView.addArrangedSubviews(amountLabel,
                                      nameTextField,
                                      amountTextField,
                                      saveTransactionButton,
                                      errorMessageLabel,
                                      transactionTotalLabel,
                                      tableView)
        
        stackView.setCustomSpacing(50, after: amountLabel)
        
        view.addSubview(stackView)
        saveTransactionButton.addTarget(self, action: #selector(saveTransactionButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
            amountTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
            saveTransactionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private var isFormValid: Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else { return false }
        
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreatorThan(0)
    }
    
    private func saveTransaction() {
        
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }
        
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.category = budgetCategory
        transaction.dateCreated = Date()
        
        do {
            try persistentContainer.viewContext.save()
            tableView.reloadData()
            resetForm()
        } catch {
            errorMessageLabel.text = "Unable to save transaction."
        }
    }
    
    @objc func saveTransactionButtonPressed(_ sender: UIButton) {
        if isFormValid {
            saveTransaction()
        } else {
            errorMessageLabel.text = "Make sure name and amount is valid."
        }
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            errorMessageLabel.text = "Unable to delete transaction"
        }
    }
    

}

//MARK: - UITableViewDataSource
extension BudgetDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        
        let transaction = fetchedResultsController.object(at: indexPath)
        
        //cell configuration
        var content = cell.defaultContentConfiguration()
        content.text = transaction.name
        content.secondaryText = transaction.amount.formatAsCurrency()
        cell.contentConfiguration = content
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension BudgetDetailViewController: UITableViewDelegate {
    //allow swipe cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transaction = fetchedResultsController.object(at: indexPath)
            deleteTransaction(transaction)
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension BudgetDetailViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        updateTransactionTotal()
    }
}
