//
//  ViewController.swift
//  ExHeaderAnimation
//
//  Created by 김종권 on 2022/11/27.
//

import UIKit

class ViewController: UIViewController {
  // MARK: Constants
  private enum Metric {
    static let headerHeight = 250.0
  }
  
  // MARK: UI
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 4.0
    layout.minimumInteritemSpacing = 0
    layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 150)
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.isScrollEnabled = true
    view.showsHorizontalScrollIndicator = false
    
    // indicator 숨기기
    view.showsVerticalScrollIndicator = true
    
    // top의 간격
    view.contentInset = .init(top: Metric.headerHeight, left: 0, bottom: 0, right: 0)
    view.backgroundColor = .clear
    view.clipsToBounds = true
    view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.id)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private let headerImageView: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "image")
    // contentMode를 .scaleAspectFill로
    view.clipsToBounds = true
    view.contentMode = .scaleAspectFill
    
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: Properties
  private var headerHeightConstraint: NSLayoutConstraint?
  
  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    [collectionView, headerImageView]
      .forEach(view.addSubview)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    headerHeightConstraint = headerImageView.heightAnchor.constraint(equalToConstant: Metric.headerHeight)
    headerHeightConstraint?.isActive = true
    NSLayoutConstraint.activate([
      headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
      headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    (0...50).count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.id, for: indexPath) as! CollectionViewCell
    cell.prepare(.random())
    return cell
  }
}

extension ViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let constraint = headerHeightConstraint else { return }
    //    print(scrollView.contentOffset.y)
    
    /* 기본 지식
     * contentOffset.y의 값 = 최상단에 닿으면 0, 시작점이 최상단보다 밑에 있으면 -, 시작점이 최상단보다 위에 있으면 +
     
     * 3가지 상태밖에 없다고 생각
      1) 초기 상태: UIImageView가 지정한 크기만큼 커졌고, 스크롤뷰의 시작점이 최상단보다 아래 존재
      2) 스크롤 뷰의 시작점이 최상단보다 위에 존재
      3) 스크롤 뷰의 시작점이 최상단보다 밑에 있고, 스크롤뷰 상단 contentInset이 미리 지정한 UIImageView 높이인, Metric.headerHeight보다 큰 경우
     */
    
    let remainingTopSpacing = abs(scrollView.contentOffset.y)
    let lowerThanTop = scrollView.contentOffset.y < 0
    let stopExpandHeaderHeight = scrollView.contentOffset.y > -Metric.headerHeight
    
    if stopExpandHeaderHeight, lowerThanTop {
      // 1) 초기 상태: UIImageView가 지정한 크기만큼 커졌고, 스크롤뷰의 시작점이 최상단보다 아래 존재
      collectionView.contentInset = .init(top: remainingTopSpacing, left: 0, bottom: 0, right: 0)
      constraint.constant = remainingTopSpacing
      headerImageView.alpha = remainingTopSpacing / Metric.headerHeight
      view.layoutIfNeeded()
    } else if !lowerThanTop {
      // 2) 스크롤 뷰의 시작점이 최상단보다 위에 존재
      collectionView.contentInset = .zero
      constraint.constant = 0
      headerImageView.alpha = 0
    } else {
      // 3) 스크롤 뷰의 시작점이 최상단보다 밑에 있고, 스크롤뷰 상단 contentInset이 미리 지정한 UIImageView 높이인, Metric.headerHeight보다 큰 경우
      constraint.constant = remainingTopSpacing
      headerImageView.alpha = 1
    }
  }
}
