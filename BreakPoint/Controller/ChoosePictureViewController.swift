//
//  ChoosePictureViewController.swift
//  BreakPoint
//
//  Created by Mélodie Benmouffek on 06/02/2018.
//  Copyright © 2018 Mélodie Benmouffek. All rights reserved.
//

import UIKit

class ChoosePictureViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: - Variables
    var navigationView = UIView()
    var closeButton = UIButton()
    var titleLabel = UILabel()
    var doneButton = UIButton()
    var segmentedControl = UISegmentedControl()
    let layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: "pictureCell")
        setup()
    }

    @objc func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    //MARK: - UICollectionViewDelegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as? PictureCollectionViewCell
            else { return UICollectionViewCell() }
        cell.configure(atIndex: indexPath.item)
        return cell
    }

    //MARK: - Private functions
    private func setupLayout() {
        view.addSubview(navigationView)
        navigationView.addSubview(doneButton)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(closeButton)
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)

        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 30.0).isActive = true
        doneButton.rightAnchor.constraint(equalTo: navigationView.rightAnchor, constant: -20.0).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor).isActive = true

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.leftAnchor.constraint(equalTo: navigationView.leftAnchor, constant: 20.0).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: doneButton.centerYAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 20.0).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30.0).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15.0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15.0).isActive = true
    }

    private func setupNavigationView() {
        navigationView.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.168627451, blue: 0.2039215686, alpha: 1)
    }

    private func setupCloseButton() {
        closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchDown)
    }

    private func setupTitleLabel() {
        titleLabel.text = "_picture"
        titleLabel.textColor = #colorLiteral(red: 0.6212110519, green: 0.8334299922, blue: 0.3770503998, alpha: 1)
        titleLabel.font = UIFont(name: "Menlo", size: 18.0)
    }

    private func setupDoneButton() {
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(#colorLiteral(red: 0.6212110519, green: 0.8334299922, blue: 0.3770503998, alpha: 1), for: .normal)
    }

    private func setupSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "Dark", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Light", at: 1, animated: true)
        segmentedControl.tintColor = #colorLiteral(red: 0, green: 0.7235742211, blue: 0.8151144385, alpha: 1)
        segmentedControl.selectedSegmentIndex = 0
    }

    private func setupCollectionView() {
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 80, height: 80)
        collectionView.backgroundColor = #colorLiteral(red: 0.2126879096, green: 0.2239724994, blue: 0.265286684, alpha: 1)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    private func setup() {
        view.backgroundColor = #colorLiteral(red: 0.2126879096, green: 0.2239724994, blue: 0.265286684, alpha: 1)
        setupNavigationView()
        setupCloseButton()
        setupTitleLabel()
        setupDoneButton()
        setupSegmentedControl()
        setupCollectionView()
        setupLayout()
    }
}
