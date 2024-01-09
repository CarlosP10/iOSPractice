//
//  ViewController.swift
//  NearMe
//
//  Created by Carlos Paredes on 9/1/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
//        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.backgroundColor = .white
        textField.placeholder = "Search"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
        searchTextField.returnKeyType = .go

        view.addSubview(mapView)
        //searchTextField esta atras de mapView es cuestion de gusto poner lo por orden o usar la siguiente funcion
        view.bringSubviewToFront(searchTextField)
        
        
        NSLayoutConstraint.activate([
            //constraints to search text field
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            
            //constraints to mapview
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }


}

