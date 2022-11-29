//
//  ViewController.swift
//  Happy
//
//  Created by ahmed on 11/22/22.
//

import UIKit

class ViewController: UIViewController, FaceViewDataSource {
    
    
    func smilinessforHappiness(_ sender: FaceView) -> Double {
        return Double(happiness - 50) / 50
    }
    
    
    var happiness: Int = 50{
        didSet{
            self.faceView.dataSource = self
            happiness = min(max(happiness, 0), 100)
            faceView.setNeedsDisplay()
        }
    }
    
    @IBOutlet var faceView: FaceView!{
        didSet{
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: Selector(("scale:"))))
        }
    }
    
    @IBAction func changeColor(_ sender: UITapGestureRecognizer) {
        switch sender.state{
        case .ended:
            fallthrough
        case .changed:
            if faceView.color == UIColor.red{
                faceView.color = UIColor.green
            }else if faceView.color == UIColor.green{
                faceView.color = UIColor.blue
            }else{
                faceView.color = UIColor.red
            }
        default:
            break
        }
    }
    
    @IBAction func changeHappiness(_ sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .ended:
            fallthrough
        case .changed:
            let translation = sender.translation(in: faceView)
            let happinessChange = -Int(translation.y) / 4
            happiness += happinessChange
            sender.setTranslation(CGPoint.zero, in: faceView)
        default:
            break
        }
    }
    
}

