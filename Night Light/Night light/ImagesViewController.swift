//
//  ImagesViewController.swift
//  Night light
//
//  Created by Martin Kostelej on 16/03/2021.
//  Copyright © 2021 Martin Kostelej. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class ImagesViewController: UICollectionViewController {
    
    let NUMBER_OF_IMAGES = 15

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUMBER_OF_IMAGES
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImagesViewCell
        switch indexPath.row {
        case 0:
            cell.image.image = UIImage(named: "img1thumbnail")!
        case 1:
            cell.image.image = UIImage(named: "img2thumbnail")!
        case 2:
            cell.image.image = UIImage(named: "img3thumbnail")!
        case 3:
            cell.image.image = UIImage(named: "img4thumbnail")!
        case 4:
            cell.image.image = UIImage(named: "img5thumbnail")!
        case 5:
            cell.image.image = UIImage(named: "img6thumbnail")!
        case 6:
            cell.image.image = UIImage(named: "img7thumbnail")!
        case 7:
            cell.image.image = UIImage(named: "img8thumbnail")!
        case 8:
            cell.image.image = UIImage(named: "img9thumbnail")!
        case 9:
            cell.image.image = UIImage(named: "img10thumbnail")!
        case 10:
            cell.image.image = UIImage(named: "img11thumbnail")!
        case 11:
            cell.image.image = UIImage(named: "img12thumbnail")!
        case 12:
            cell.image.image = UIImage(named: "img13thumbnail")!
        case 13:
            cell.image.image = UIImage(named: "img14thumbnail")!
        case 14:
            cell.image.image = UIImage(named: "img15thumbnail")!
        default:
            cell.image.image = UIImage(named: "img1thumbnail")!
        }
        cell.image.layer.cornerRadius = 10.0
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        
        if let presenter = presentingViewController as? ViewController {
            presenter.saveImage(imageIndex: indexPath.row)
        }
        dismiss(animated: true, completion: nil)
    }
}
