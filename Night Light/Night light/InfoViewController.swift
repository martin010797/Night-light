//
//  InfoViewController.swift
//  Night light
//
//  Created by Martin Kostelej on 18/03/2021.
//  Copyright © 2021 Martin Kostelej. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //infoViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoViewCell", for: indexPath) as! InfoViewCell
        switch indexPath.row {
        case 0:
            cell.image.image = UIImage(named: "img1thumbnail")!
            cell.text.text = "prva stranka"
        case 1:
            cell.image.image = UIImage(named: "img2thumbnail")!
            cell.text.text = "druha stranka"
        case 2:
            cell.image.image = UIImage(named: "img3thumbnail")!
            cell.text.text = "tretia stranka"
        default:
            cell.image.image = UIImage(named: "img1thumbnail")!
            cell.text.text = "neznama stranka"
        }
        return cell
    }
}

//extension ViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = collectionView.frame.size
//        return CGSize(width: size.width, height: size.height)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//}
