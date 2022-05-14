//
//  CryptoTableViewCell.swift
//  CryptoTracker
//
//  Created by Claudius Kockelmann on 08.05.22.
//

import Foundation
import UIKit

class CryptoTableViewCellViewModel {
    let name: String
    let symbol: String
    let price: String
    let iconUrl: URL?
    var iconData: Data?
    
    init(name: String, symbol: String, price: String, iconUrl: URL?) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
}

class CryptoTableViewCell : UITableViewCell {
    static let identifier = "CryptoTableViewCell"
    
    // Subviews
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.symbolLabel)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.iconImageView)
        
        self.setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    // Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let size: CGFloat = self.contentView.frame.size.height/1.1
//        self.iconImageView.frame = CGRect(x: 20, y: (self.contentView.frame.size.height-size)/2, width: size, height: size)
//
//
//        self.nameLabel.sizeToFit()
//        self.priceLabel.sizeToFit()
//        self.symbolLabel.sizeToFit()
//
//        self.nameLabel.frame = CGRect(x: 30 + size, y: 0, width: self.contentView.frame.size.width/2, height: self.contentView.frame.size.height/2)
//        self.symbolLabel.frame = CGRect(x: 30 + size, y: self.contentView.frame.size.height/2, width: self.contentView.frame.size.width/2, height: self.contentView.frame.size.height/2)
//        self.priceLabel.frame = CGRect(x: self.contentView.frame.size.width/2, y: 0, width: (self.contentView.frame.size.width/2)-15, height: self.contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.image = nil
        self.nameLabel.text = nil
        self.priceLabel.text = nil
        self.symbolLabel.text = nil
    }
    
    func setupConstraints() {
        
        self.iconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        self.iconImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        self.iconImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        self.iconImageView.widthAnchor.constraint(equalToConstant: self.contentView.frame.size.height).isActive = true
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.priceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        self.priceLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        self.priceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 10).isActive = true
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.symbolLabel.leftAnchor.constraint(equalTo: self.iconImageView.rightAnchor, constant: 10).isActive = true
        self.symbolLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        self.symbolLabel.translatesAutoresizingMaskIntoConstraints = false

    }
    
    // Configure
    
    func configure(with viewModel: CryptoTableViewCellViewModel) {
        self.nameLabel.text = viewModel.name
        self.symbolLabel.text = viewModel.symbol
        self.priceLabel.text = viewModel.price
        
        if let data = viewModel.iconData {
            self.iconImageView.image = UIImage(data: data)
        } else if let url = viewModel.iconUrl {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data {
                    viewModel.iconData = data
                    DispatchQueue.main.async {
                        self?.iconImageView.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
}
