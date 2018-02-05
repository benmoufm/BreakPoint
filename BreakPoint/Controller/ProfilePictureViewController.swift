//
//  ProfilePictureViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 05/02/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class ProfilePictureViewController: UIViewController {
    //MARK: - Variables
    private var size: CGSize
    private var imageView = UIImageView()

    init(size: CGSize) {
        self.size = size
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        preferredContentSize = size
    }

    private func setupLayout() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }

    private func setup() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        imageView.image = #imageLiteral(resourceName: "defaultProfileImage")
        setupLayout()
    }
}
