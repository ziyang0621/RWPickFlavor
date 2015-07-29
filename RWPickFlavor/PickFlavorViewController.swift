//
//  ViewController.swift
//  IceCreamShop
//
//  Created by Joshua Greene on 2/8/15.
//  Copyright (c) 2015 Razeware, LLC. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

public class PickFlavorViewController: UIViewController, UICollectionViewDelegate {
  
  // MARK: Instance Variables
  
  var flavors: [Flavor] = [] {
    
    didSet {
      pickFlavorDataSource?.flavors = flavors
    }
  }
  
  private var pickFlavorDataSource: PickFlavorDataSource? {
    return collectionView?.dataSource as! PickFlavorDataSource?
  }
  
  private let flavorFactory = FlavorFactory()
  
  // MARK: Outlets
  
  @IBOutlet var contentView: UIView!
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var iceCreamView: IceCreamView!
  @IBOutlet var label: UILabel!
  
  // MARK: View Lifecycle
  
  public override func viewDidLoad() {
    
    super.viewDidLoad()    
    loadFlavors()
  }
  
  private func loadFlavors() {
    let urlString = "http://www.raywenderlich.com/downloads/Flavors.plist"
    
    showLoadingHUD()
    Alamofire.request(.GET, urlString, encoding: .PropertyList(.XMLFormat_v1_0, 0))
      .responsePropertyList{ request, response, array, error in
      
        self.hideLoadingHUD()
        if let error = error {
          println("Error: \(error)")
        } else if let array = array as? [[String: String]] {
          if array.isEmpty {
            println("No flavors were found!")
          } else {
            self.flavors = self.flavorFactory.flavorsFromDictionaryArray(array)
            self.collectionView.reloadData()
            self.selectFirstFlavor()
          }
        }
    }
  }
    
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(contentView, animated: true)
        hud.labelText = "Loading..."
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(contentView, animated: true)
    }
  
  private func selectFirstFlavor() {
    
    if let flavor = flavors.first {
      updateWithFlavor(flavor)
    }
  }
  
  // MARK: UICollectionViewDelegate
  
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    let flavor = flavors[indexPath.row]
    updateWithFlavor(flavor)
  }
  
  // MARK: Internal
  
  private func updateWithFlavor(flavor: Flavor) {
    
    iceCreamView.updateWithFlavor(flavor)
    label.text = flavor.name
  }
}
