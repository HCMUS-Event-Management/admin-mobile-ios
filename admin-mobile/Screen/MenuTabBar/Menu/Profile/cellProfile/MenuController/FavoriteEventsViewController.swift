//
//  FavoriteEventsViewController.swift
//  mobile
//
//  Created by NguyenSon_MP on 23/02/2023.
//

import UIKit

class FavoriteEventsViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var clEvent: UICollectionView!
    @IBOutlet weak var clType: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configCl()
    }
    func configCl() {
        
        self.clEvent.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventCollectionViewCell")
        self.clType.register(UINib(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TypeCollectionViewCell")
//
        self.clType.dataSource = self
        self.clType.delegate = self

        self.clEvent.dataSource = self
        self.clEvent.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false

       configNaviBar()
    }
    
    func configNaviBar() {
        navigationController?.navigationBar.tintColor = .label
        
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        title.text = "Favorite Events"
        title.font = UIFont(name: "Helvetica Bold", size: 18)
        title.textAlignment = .center
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backScreen)),UIBarButtonItem(customView: title)]
    }
    
    @objc func backScreen() {
        navigationController?.popViewController(animated: true)
    }
    

}

extension FavoriteEventsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.clType {
            return 12
        } else if collectionView == self.clEvent {
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.clType {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as? TypeCollectionViewCell {
                cell.layer.cornerRadius = 30
                cell.layer.masksToBounds = true
                
                return cell
            }
            
        }else if collectionView == self.clEvent {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell {
                
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
     
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.clType {
            return 1
        } else if collectionView == self.clEvent {
            return 10
        }
        return 0
    }
    

    
}


    extension FavoriteEventsViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == self.clEvent {
                return CGSize(width: collectionView.frame.width/2 - 10, height: 220)

            } else if collectionView == self.clType {
                return CGSize(width: collectionView.frame.width/4, height: 50)
            }
            return CGSize(width: collectionView.frame.width/2 - 10, height: 220)

        }
        
        
    }
    


