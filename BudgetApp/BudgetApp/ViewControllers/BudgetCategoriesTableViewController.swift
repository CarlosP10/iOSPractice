//
//  BudgetCategoriesTableViewController.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 10/1/24.
//

import UIKit
import CoreData

class BudgetCategoriesTableViewController: UITableViewController {

    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<BudgetCategory>!
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        //registe cell
        tableView.register(BudgetCategoryTableViewCell.self, forCellReuseIdentifier: "BudgetTableViewCell")
    }
    
    @objc func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let navController = UINavigationController(rootViewController: AddBudgetCategoryViewController(persistentContainer: persistentContainer))
        present(navController, animated: true)
    }
    
    private func setupUI() {
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategory))
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }
    
    private func deleteBudgetCategory(_ budgetCategory: BudgetCategory) {
        
        persistentContainer.viewContext.delete(budgetCategory)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            //show an alert
            showAlert(title: "Error", message: "Unable to delete budget categroy")
        }
    }

    //UITableViewDataSource delegate functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath) as? BudgetCategoryTableViewCell else {
            return BudgetCategoryTableViewCell(style: .default, reuseIdentifier: "BudgetTableViewCell")
        }
        cell.accessoryType = .disclosureIndicator
        
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        cell.configure(budgetCategory)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budgetCategory = fetchedResultsController.object(at: indexPath)
            deleteBudgetCategory(budgetCategory)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        //perform navigation
        self.navigationController?.pushViewController(BudgetDetailViewController(persistentContainer: persistentContainer, budgetCategory: budgetCategory), animated: true)
    }

}

//MARK: - NSFetchedResultsControllerDelegate
extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
     
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
