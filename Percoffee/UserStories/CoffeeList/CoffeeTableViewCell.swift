//
//  CoffeeTableViewCell.swift
//  Percoffee
//
//  Created by Andrew Vyazovoy on 03/09/2017.
//  Copyright © 2017 vyazovoy. All rights reserved.
//

import UIKit

final class CoffeeTableViewCell: UITableViewCell {
    
    weak var tableView: UITableView?
    
    var imageURL: URL? {
        didSet {
            thumbImageViewStackView.isHidden = imageURL == nil
            
            if let imageURL = imageURL {
                thumbImageView.af_setImage(withURL: imageURL, placeholderImage:nil, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { [weak self] (response) in
                    guard let cell = self else { return }
                    cell.fixImageRatio()

//                    if cell.tableView?.visibleCells.contains(cell) ?? false {
//                        cell.tableView?.beginUpdates()
//                        cell.tableView?.endUpdates()
//                    }
                })
            } else {
                thumbImageView.af_cancelImageRequest()
                thumbImageView.image = nil
                imageAspectRatioConstaraint?.isActive = false
            }
            
            if tableView?.visibleCells.contains(self) ?? false {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
            nameLabel.isHidden = name == nil
        }
    }
    
    var info: String? {
        didSet {
            infoLabel.text = info
            infoLabel.isHidden = info == nil
        }
    }
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9.0/16.0)
        constraint.priority = .defaultLow
        constraint.isActive = true
//        imageView.heightAnchor.constraint(greaterThanOrEqualTo: imageView.widthAnchor, multiplier: 9.0/16.0).isActive = true
        imageView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var thumbImageViewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbImageView, UIView()])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private weak var imageAspectRatioConstaraint: NSLayoutConstraint?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.textColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight: .bold)

        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.textColor = #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1)
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15, weight: .regular)

        return label
    }()
    
    private lazy var customDisclosureView: UIView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "DisclosureIndicatorImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 17).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 11).isActive = true
        
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(customDisclosureView)
        customDisclosureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        customDisclosureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, infoLabel, thumbImageViewStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: customDisclosureView.leadingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageURL = nil
        name = nil
        info = nil
        tableView = nil
    }
    
    private func fixImageRatio() {
        guard let image = thumbImageView.image else {
            imageAspectRatioConstaraint?.isActive = false
            
            return
        }
        let oldRatio = imageAspectRatioConstaraint?.multiplier ?? 0
        let newRatio = min(image.size.height / max(1, image.size.width), 3)
        
        if newRatio != oldRatio {
            imageAspectRatioConstaraint?.isActive = false
            let newConstraint = thumbImageView.heightAnchor.constraint(equalTo: thumbImageView.widthAnchor, multiplier: newRatio)
            newConstraint.priority = .defaultHigh
            newConstraint.isActive = true
            imageAspectRatioConstaraint = newConstraint
        }
    }
    
}
