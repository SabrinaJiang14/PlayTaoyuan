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
    private var dataSource:[[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollection()
        
        vm.$dataSource
            .sink { infos in
                self.dataSource = infos
                self.collection.reloadData()
            }.store(in: &cancellables)
        
        vm.viewDidLoad()

    }
    
    private func initCollection() {
        self.collection.collectionViewLayout = createLayout()
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.register(UINib(nibName: "SingleLayoutCell", bundle: nil), forCellWithReuseIdentifier: "SingleLayoutCell")
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, env in
            return self.singleLayout()
        }
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
}

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleLayoutCell", for: indexPath) as! SingleLayoutCell
        
        let data = dataSource[indexPath.section][indexPath.row]
        cell.setupData(data: data)
        
        return cell
    }
}
