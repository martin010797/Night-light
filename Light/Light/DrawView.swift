//
//  drawView.swift
//  Light
//
//  Created by Martin Kostelej on 15/08/2020.
//  Copyright © 2020 Martin Kostelej. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    override func draw(_ rect: CGRect) {
        let ovalBounds = self.bounds.insetBy(dx: 10, dy: 10)
        let oval = UIBezierPath(ovalIn: ovalBounds)
        let brightRed = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        brightRed.setFill()
        oval.fill()
    }
}
