//
//  CoffeeDetailTableViewCell.swift
//  Percoffee
//
//  Created by Andrew Vyazovoy on 03/09/2017.
//  Copyright © 2017 vyazovoy. All rights reserved.
//

import UIKit
import AlamofireImage

final class CoffeeDetailTableViewCell: UITableViewCell {
    
    weak var tableView: UITableView?
    
    var imageURL: URL? {
        didSet {
            if let imageURL = imageURL {
                fullImageView.af_setImage(withURL: imageURL, placeholderImage:nil, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { [weak self] (response) in
                    guard let cell = self else { return }
                    cell.fixImageRatio()
                    
                    if cell.tableView?.visibleCells.contains(cell) ?? false {
                        cell.tableView?.beginUpdates()
                        cell.tableView?.endUpdates()
                    }
                })
            } else {
                fullImageView.af_cancelImageRequest()
                fullImageView.image = nil
                fixImageRatio()
            }
            
            if tableView?.visibleCells.contains(self) ?? false {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
    }
    
    var info: String? {
        didSet {
            infoLabel.text = info
            infoLabelContainer.isHidden = info == nil
            
            if tableView?.visibleCells.contains(self) ?? false {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
    }
    
    var date: String? {
        didSet {
            dateLabel.text = "Updated \(date ?? "")"
            dateLabelContainer.isHidden = date == nil
            
            if tableView?.visibleCells.contains(self) ?? false {
                tableView?.beginUpdates()
                tableView?.endUpdates()
            }
        }
    }
    
    private lazy var fullImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(greaterThanOrEqualTo: imageView.widthAnchor, multiplier: 9.0/16.0).isActive = true
        imageView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    private weak var imageAspectRatioConstaraint: NSLayoutConstraint?
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1725490196, alpha: 1)
        label.numberOfLines = 6
        
        return label
    }()
    
    private lazy var infoLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(infoLabel)
        infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        infoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1)
        label.numberOfLines = 1
        label.font = UIFont.italicSystemFont(ofSize: 12)
        
        return label
    }()
    
    private lazy var dateLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [fullImageView, infoLabelContainer, dateLabelContainer])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        fullImageView.af_cancelImageRequest()
        fullImageView.image = nil
        imageAspectRatioConstaraint?.isActive = false
        info = nil
        date = nil
    }
    
    func fixImageRatio() {
        guard let image = fullImageView.image else {
            imageAspectRatioConstaraint?.isActive = false
            
            return
        }
        let oldRatio = imageAspectRatioConstaraint?.multiplier ?? 0
        let newRatio = min(image.size.height / max(1, image.size.width), 3)
        
        if oldRatio != newRatio {
            imageAspectRatioConstaraint?.isActive = false
            let newConstraint = fullImageView.heightAnchor.constraint(equalTo: fullImageView.widthAnchor, multiplier: newRatio)
            newConstraint.priority = .defaultHigh
            newConstraint.isActive = true
            imageAspectRatioConstaraint = newConstraint
        }
    }
    
}
