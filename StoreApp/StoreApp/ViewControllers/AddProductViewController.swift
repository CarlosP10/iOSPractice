//
//  AddProductViewController.swift
//  StoreApp
//
//  Created by Carlos Paredes on 22/1/24.
//

import Foundation
import UIKit
import SwiftUI

enum AddProductTextFieldType: Int {
    case title, price, imageURL
}

struct AddProductFormState {
    var title: Bool = false
    var price: Bool = false
    var description: Bool = false
    var imageUrl: Bool = false
    
    var isValid: Bool {
        title && price && imageUrl && description
    }
}

class AddProductViewController: UIViewController {
    
    private var selectedCategory: Category?
    private var addProductFormState = AddProductFormState()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter title"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.tag = AddProductTextFieldType.title.rawValue
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter price (Numbers only)"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.tag = AddProductTextFieldType.price.rawValue
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var imageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter image url"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.tag = AddProductTextFieldType.imageURL.rawValue
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInsetAdjustmentBehavior = .automatic
        textView.backgroundColor = .lightGray
        textView.delegate = self
        return textView
    }()
    
    lazy var categoryPickView: CategoryPickerView = {
        let pickerView = CategoryPickerView { [weak self] category in
            print(category)
            self?.selectedCategory = category
        }
        return pickerView
    }()
    
    lazy var cancelBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        return barButtonItem
    }()
    
    lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
        barButtonItem.isEnabled = false
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        self.hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(priceTextField)
        stackView.addArrangedSubview(descriptionTextView)
        
        //category picker view
        let hostingController = UIHostingController(rootView: categoryPickView)
        stackView.addArrangedSubview(hostingController.view)
        addChild(hostingController)
        hostingController.didMove(toParent: self)
        
        stackView.addArrangedSubview(imageTextField)
        
        view.addSubview(stackView)
        
        //add constraints
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        guard let text = sender.text else {
            return
        }
        
        switch sender.tag {
        case AddProductTextFieldType.title.rawValue:
            addProductFormState.title = !text.isEmpty
        case AddProductTextFieldType.price.rawValue:
            addProductFormState.price = !text.isEmpty && text.isNumeric
        case AddProductTextFieldType.imageURL.rawValue:
            addProductFormState.imageUrl = !text.isEmpty
        default:
            break
        }
        
        saveBarButtonItem.isEnabled = addProductFormState.isValid
    }
    
    @objc func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func saveButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
}

struct AddProductViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        //Allow navigation bar convert into UINavigationController
        UINavigationController(rootViewController: AddProductViewController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct AddProductViewController_Preview: PreviewProvider {
    static var previews: some View {
        AddProductViewControllerRepresentable()
    }
}

extension AddProductViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        addProductFormState.description = !textView.text.isEmpty
        saveBarButtonItem.isEnabled = addProductFormState.isValid
    }
}
