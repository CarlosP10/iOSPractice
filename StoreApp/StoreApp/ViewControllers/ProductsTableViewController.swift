//
//  ProductsTableViewController.swift
//  StoreApp
//
//  Created by Carlos Paredes on 19/1/24.
//

import Foundation
import UIKit
import SwiftUI

class ProductsTableViewController: UITableViewController {
    
    lazy var addProductBarItemButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductButtonPressed))
        return barButtonItem
    }()
    
    private var category: Category
    private var client = StoreHTTTPClient()
    private var products: [Product] = []
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        navigationItem.rightBarButtonItem = addProductBarItemButton
        
        Task {
            await populateProdcuts()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            await populateProdcuts()
            tableView.reloadData()
        }
    }
    
    @objc
    private func addProductButtonPressed(_ sender: UIBarButtonItem) {
        let addProductVC = AddProductViewController()
        addProductVC.delegate = self
        let navigationController = UINavigationController(rootViewController: addProductVC)
        present(navigationController, animated: true)
    }
    
    private func populateProdcuts() async {
        do {
            products = try await client.load(Resource(url: URL.productsByCategory(category.id)))
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let product = products[indexPath.row]
        
//        var configuration = cell.defaultContentConfiguration()
//        configuration.text = product.title
//        configuration.secondaryText = product.description
//        cell.contentConfiguration = configuration
        
        cell.contentConfiguration = UIHostingConfiguration(content: {
            ProductCellView(product: product)
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        
        self.navigationController?.pushViewController(ProductDetailViewController(product: product), animated: true)
    }
}

//MARK: - AddProductViewController
extension ProductsTableViewController: AddProductViewControllerDelegate {
    func addProductViewControllerDidCancel(controller: AddProductViewController) {
        controller.dismiss(animated: true)
    }
    
    func addProductViewControllerDidSave(product: Product, controller: AddProductViewController) {
        
        let createProductRequest = CreateProductRequest(product: product)
        
        Task {
            do {
                //let newProduct = try await client.createProduct(productRequest: createProductRequest)
                let data = try JSONEncoder().encode(createProductRequest)
                //we need to provide the type
                let newProduct: Product = try await client.load(Resource(url: URL.createProduct, method: .post(data)))
                
                products.insert(newProduct, at: 0)
                tableView.reloadData()
                controller.dismiss(animated: true)
            } catch {
                print(error)
            }
            
        }
        
    }
    
}
