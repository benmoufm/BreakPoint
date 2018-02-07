//
//  PictureCollectionViewCell.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 06/02/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    var pictureType = PictureType.dark

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.backgroundColor = pictureType.selectedColor
            } else {
                layer.backgroundColor = pictureType.color
            }
        }
    }

    func configure(atIndex index: Int, pictureType: PictureType) {
        self.pictureType = pictureType
        imageView.image = UIImage(named: "\(pictureType.description)\(index)")
        layer.backgroundColor = self.pictureType.color
        imageView.contentMode = .scaleAspectFit
    }

    private func setupView() {
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    private func setupLayout() {
        contentView.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    private func setup() {
        setupView()
        setupLayout()
    }
}
