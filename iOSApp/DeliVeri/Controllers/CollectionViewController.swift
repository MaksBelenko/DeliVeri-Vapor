//
//  CollectionViewController.swift
//  DeliVeri
//
//  Created by Maksim on 02/07/2020.
//  Copyright © 2020 Maksim. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "Cell"

class CollectionViewController: UIViewController {

    private let images = Pictures()
    private let networkHelper = NetworkingHelper()
    private var restaurants = [Restaurant]()

    private var currentCard = 0
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.decelerationRate = .fast
        cv.contentInsetAdjustmentBehavior = .always
        cv.showsHorizontalScrollIndicator = false
        cv.register(ImageViewerCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        return cv
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .arialBold(ofSize: 25)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descrLabel: UILabel = {
        let label = UILabel()
        label.font = .arial(ofSize: 20)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attrString = NSMutableAttributedString(string: "Attributed String")
        attrString.addAttribute(.paragraphStyle,
                                value: paragraphStyle,
                                range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "DeliVeri"
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleRefresh))
        setupCollectionView()
        setupText()
        
        networkHelper.restaurants.bind { [unowned self] restaurants in
            self.restaurants = restaurants
            self.updateCurrentCardText()
            self.collectionView.reloadData()
        }
        
        networkHelper.fetchData()
    }
    
    
    
    private func updateCurrentCardText() {
        if self.currentCard <= restaurants.count - 1 {
            self.priceLabel.text = "£\(restaurants[self.currentCard].price)"
            self.descrLabel.text =  restaurants[self.currentCard].description
        } else {
            currentCard = 0
            if restaurants.count > 0 {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: true)
                self.priceLabel.text = "£\(restaurants[0].price)"
                self.descrLabel.text =  restaurants[0].description
            }
        }
    }
    
    
    // MARK: - Button actions
    
    @objc private func handleRefresh() {
        networkHelper.fetchData()
    }
    
    
    // MARK: - Configure UI
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
//        collectionView.backgroundColor = .black
        view.layoutIfNeeded()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CollectionViewFlowLayout(size: CGSize(width: collectionView.frame.width * 0.65,
                                                                                    height: collectionView.frame.height * 0.7))
    }
    
    
    private func setupText() {
        let sideOffset: CGFloat = 35
        
        view.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideOffset).isActive = true
        
        view.addSubview(descrLabel)
        descrLabel.translatesAutoresizingMaskIntoConstraints = false
        descrLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 15).isActive = true
        descrLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        descrLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -sideOffset * 2).isActive = true
    }
}




// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = CGPoint(x: collectionView.center.x + collectionView.contentOffset.x,
                            y: collectionView.center.y + collectionView.contentOffset.y)
        
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        currentCard = indexPath.row
        priceLabel.text = "£\(restaurants[indexPath.row].price)"
        descrLabel.text = restaurants[indexPath.row].description
    }
}


// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource  {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! ImageViewerCell
        let restaurant = restaurants[indexPath.row]
        cell.name = restaurant.name
        cell.picture = images.all[0].roundCorners(proportion: 20)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        
        let ac = UIAlertController(title: "Order a \(restaurant.name)", message: "Please enter your name", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Order it!", style: .default, handler: { [unowned self] action in
            guard let name = ac.textFields?[0].text else { return }
            self.networkHelper.order(restaurant, for: name)
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

}
