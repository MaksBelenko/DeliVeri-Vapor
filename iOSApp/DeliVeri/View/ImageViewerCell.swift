//
//  ImageViewerCell.swift
//  ReceiptsSorted
//
//  Created by Maksim on 14/05/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit

class ImageViewerCell: UICollectionViewCell {
    
    var name: String? {
        didSet {
            guard let text = name else { return }
            nameLabel.text = text
        }
    }
    
    var picture: UIImage? {
        didSet {
            guard let picture = picture else { return }
            imageView.image = picture
        }
    }
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 0
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .arialBold(ofSize: 25) //.systemFont(ofSize: 25)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -30).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
