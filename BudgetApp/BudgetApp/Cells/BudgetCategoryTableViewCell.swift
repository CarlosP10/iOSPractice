//
//  BudgetCategoryTableViewCell.swift
//  BudgetApp
//
//  Created by Carlos Paredes on 17/1/24.
//

import UIKit
import SwiftUI

class BudgetCategoryTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var remainingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.alpha = 0.5
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        //stackview
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 44)
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        
        nameLabel.text = "food"
        amountLabel.text = "$200"
        remainingLabel.text = "Remaining: $50"
        stackView.addArrangedSubviews(nameLabel)
        
        let vStackView = UIStackView()
        vStackView.alignment = .trailing
        vStackView.axis = .vertical
        vStackView.addArrangedSubviews(amountLabel, remainingLabel)
        
        stackView.addArrangedSubview(vStackView)
        
        self.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
}

//Code below works for show a view that we are working at
struct BudgetTableViewCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        return BudgetCategoryTableViewCell(style: .default, reuseIdentifier: "BudgetTableViewCell")
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct BudgetTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        BudgetTableViewCellRepresentable()
    }
}
