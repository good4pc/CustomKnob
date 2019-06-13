//
//  PlayLogViewController.swift
//  PlayLog
//
//  Created by Prasanth pc on 2019-03-30.
//  Copyright © 2019 Prasanth pc. All rights reserved.
//

import UIKit
import OpalImagePicker
import Photos

class PlayLogViewController: UIViewController, RotatingButtonDelegate {
    @IBOutlet weak var rotatingButton: RotatingButton!
    fileprivate let cellIdentifier = "cellIdentifier"
    @IBOutlet weak var slider: UISlider!
    var imagesSelected: [UIImage] = []
    
    let backGroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView  = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        return collectionView
    }()
    
    private let startAngle: CGFloat = -90
    private let endAngle:CGFloat = 270
    @IBOutlet weak var imagesSelectionButton: UIButton!
    
    fileprivate func initializeRotatingButton() {
        rotatingButton.startAngle = startAngle.deg2rad()
        rotatingButton.endAngle = endAngle.deg2rad()
        rotatingButton.setValue(0.0)
        rotatingButton.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        self.title = "Playlog"
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        initializeRotatingButton()
        showImageSelected()
        showImageStack()
        selectionButtonStyle()
    }
    
    private func selectionButtonStyle() {
        imagesSelectionButton.layer.borderColor = UIColor.white.cgColor
        imagesSelectionButton.layer.borderWidth = 2.0
        imagesSelectionButton.layer.cornerRadius = 4.0
    }
    
    func buttonSelectedAtIndex(value: Int) {
        if value < imagesSelected.count {
            self.backGroundImage.image = self.imagesSelected[value]
        }
    }
    
    private func showImageSelected() {
        self.view.insertSubview(backGroundImage, at: 0)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[V0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["V0": backGroundImage]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[V0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["V0": backGroundImage]))
    }
    
    @IBAction func selectImages(_ sender: Any) {
        rotatingButton.setValue(0.0)
        self.imagesSelected.removeAll()
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        let imagePicker = OpalImagePickerController()
        presentOpalImagePickerController(imagePicker, animated: true, select: { (images) in
            
            if images.count > 0 {
                for value in images {
                    if let image = value.getUIImage() {
                        self.imagesSelected.append(image)
                    }
                }
                self.rotatingButton.selectedImage(count : images.count)
                self.collectionView.reloadData()
                self.displayBackGroundImage(with: self.imagesSelected[0])
            }
            else {
                let controller = UIAlertController(title: "Playlog", message: "Select atleast one image", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                }))
                self.present(controller, animated: true, completion: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }, cancel: {
            self.dismiss(animated: true, completion: nil)
        }) {
            
        }
    }
    
   private func showImageStack() {
       
        self.view.addSubview(collectionView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[V0]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["V0": collectionView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[V0(90)]-30-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["V0": collectionView]))
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        rotatingButton.setValue(slider.value)
    }
    
    private func displayBackGroundImage(with image: UIImage) {
        backGroundImage.image = image
    }
}

//MARK: CollectionView Delegate

extension PlayLogViewController: UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        cell.imageView.image = imagesSelected[indexPath.row]
        return cell
    }
}



