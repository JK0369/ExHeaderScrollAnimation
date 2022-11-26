//
//  CollectionViewCell.swift
//  ExHeaderAnimation
//
//  Created by 김종권 on 2022/11/26.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
  static let id = "ContainerCell"
  
  // MARK: UI
  private let myView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: Initializer
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(myView)
    NSLayoutConstraint.activate([
      myView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      myView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      myView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      myView.topAnchor.constraint(equalTo: contentView.topAnchor),
    ])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.prepare(.clear)
  }
  
  func prepare(_ color: UIColor) {
    myView.backgroundColor = color
  }
}

extension CGFloat {
  static func random() -> CGFloat {
    CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
}

extension UIColor {
  static func random() -> UIColor {
    UIColor(
      red: .random(),
      green: .random(),
      blue: .random(),
      alpha: 1.0
    )
  }
}
