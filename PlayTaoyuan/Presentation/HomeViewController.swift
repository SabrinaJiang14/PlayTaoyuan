//
//  HomeViewController.swift
//  PlayTaoyuan
//
//  Created by Eileen on 2021/9/11.
//

import UIKit
import Combine
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    
    private let vm = HomeViewModel()
    private var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    private var dataSource:[Attraction] = []
    private let loading = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(loading)
        loading.center = self.view.center
        loading.startAnimating()
        
        initCollection()
        
        vm.viewDidLoad()
        vm.$load
            .receive(on: DispatchQueue.main)
            .sink { isLoad in
            isLoad ? self.loading.startAnimating() : self.loading.stopAnimating()
        }.store(in: &cancellables)
        
        vm.$dataSource
//            .subscribe(on: DispatchQueue.global(qos: .background))
//            .receive(on: DispatchQueue.main)
            .sink { infos in
                self.dataSource = infos ?? []
                self.collection.reloadData()
            }.store(in: &cancellables)
        
    }
    
    private func initCollection() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 10, height: 217)
        self.collection.collectionViewLayout = createLayout() //layout
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.register(UINib(nibName: "SingleLayoutCell", bundle: nil), forCellWithReuseIdentifier: "SingleLayoutCell")
        self.collection.register(UINib(nibName: "ThreeRowsLayoutCell", bundle: nil), forCellWithReuseIdentifier: "ThreeRowsLayoutCell")
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            if section == 0 {
                return self.singleLayout()
            } else if section == 1{
                return self.threeRowsLayout()
            }
            return self.fiveGridLayout()
        }
    }
    
    private func fiveGridLayout() -> NSCollectionLayoutSection{
        let item1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0))
        let item1 = NSCollectionLayoutItem(layoutSize: item1Size)
        

        let item2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let item2 = NSCollectionLayoutItem(layoutSize: item2Size)
        
        let group2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1.0))
        let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: group2Size, subitem: item2, count: 2)
        
        
        let group3Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalHeight(1.0))
        let group3 = NSCollectionLayoutGroup.vertical(layoutSize: group3Size, subitem: group2, count: 2)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item1, group3])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func threeRowsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1/3))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func singleLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .absolute(217))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = dataSource[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: data.cellIdentifier, for: indexPath) as! HomeCellable
        
        cell.setupData(data: data.info[indexPath.row])
        
        return cell as! UICollectionViewCell
    }
    
    
}




























/*
 private func initCollection() {
     let layout = UICollectionViewFlowLayout()
     layout.scrollDirection = .vertical
     layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width/3)-10, height: 217)
     self.collection.collectionViewLayout = layout//createLayout()
     self.collection.delegate = self
     self.collection.dataSource = self
     self.collection.register(UINib(nibName: "SingleLayoutCell", bundle: nil), forCellWithReuseIdentifier: "SingleLayoutCell")
     self.collection.register(UINib(nibName: "ThreeRowsLayoutCell", bundle: nil), forCellWithReuseIdentifier: "ThreeRowsLayoutCell")
 }
 
 private func createLayout() -> UICollectionViewCompositionalLayout {
     return UICollectionViewCompositionalLayout { section, env in
         if section == 0 {
             return self.singleLayout()
         }else if section == 1 {
             return self.threeRowsLayout()
         }
         return self.fiveGridLayout()
     }
 }
 
 private func fiveGridLayout() -> NSCollectionLayoutSection{
     let item1Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                            heightDimension: .fractionalHeight(1.0))
     let item1 = NSCollectionLayoutItem(layoutSize: item1Size)
     

     let item2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                            heightDimension: .fractionalHeight(1))
     let item2 = NSCollectionLayoutItem(layoutSize: item2Size)
     
     let group2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                            heightDimension: .fractionalHeight(1.0))
     let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: group2Size, subitem: item2, count: 2)
     
     
     let group3Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                            heightDimension: .fractionalHeight(1.0))
     let group3 = NSCollectionLayoutGroup.vertical(layoutSize: group3Size, subitem: group2, count: 2)
     
     
     let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .absolute(300))
     let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item1, group3])
     let section = NSCollectionLayoutSection(group: group)
     
     return section
 }
 
 private func threeRowsLayout() -> NSCollectionLayoutSection {
     let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(1/3))
     
     let item = NSCollectionLayoutItem(layoutSize: itemSize)
     
     let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .absolute(250))
     let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
     
     let section = NSCollectionLayoutSection(group: group)
     section.orthogonalScrollingBehavior = .groupPaging
     return section
 }
 
 private func singleLayout() -> NSCollectionLayoutSection {
     let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(1.0))
     let item = NSCollectionLayoutItem(layoutSize: itemSize)
     item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
     
     let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .absolute(217))
     let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
     
     let section = NSCollectionLayoutSection(group: group)
     section.orthogonalScrollingBehavior = .groupPaging
     
     return section
 }
 
 extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource{
     
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return dataSource.count
     }
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return dataSource[section].info.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let data = dataSource[indexPath.section]
         
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: data.cellIdentifier, for: indexPath) as! HomeCellable
         cell.setupData(data: data.info[indexPath.row])
         
         return cell as! UICollectionViewCell
     }
 }
 */
