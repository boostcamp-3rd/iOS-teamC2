//
//  RatioGraphView.swift
//  FineDust
//
//  Created by Presto on 22/01/2019.
//  Copyright © 2019 boostcamp3rd. All rights reserved.
//

import UIKit

/// 비율 그래프 뷰
final class RatioGraphView: UIView {
  
  /// 비율을 저장하는  프로퍼티
  var ratio: CGFloat = 0.0 {
    didSet {
      // 원 그래프 비율 변경하는 코드 추가
    }
  }
  
  /// 배경 뷰 높이
  private var backgroundViewHeight: CGFloat {
    return backgroundView.bounds.height - 20
  }
  
  // MARK: IBOutlet
  
  /// 배경 뷰
  @IBOutlet private weak var backgroundView: UIView!
  
  // MARK: View
  
  /// 원 그래프의 전체 비율 부분 뷰
  private lazy var entireSectionView: UIView = {
    let view = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: backgroundViewHeight,
        height: backgroundViewHeight
      )
    )
    backgroundView.addSubview(view)
    return view
  }()
  
  /// 가운데 비어 있는 원
  private var centerHoleView: UIView!
  
  /// 퍼센트 레이블
  private var percentLabel: UILabel!
  
  // MARK: Life Cycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
}

// MARK: - Private Extension

private extension RatioGraphView {
  /// 초기 설정
  private func setup() {
    drawEntireSectionView()
    drawPortionSectionView()
    drawCenterHoleView()
    setPercentLabel()
  }
  
  /// 전체 비율 부분 뷰 그리기
  private func drawEntireSectionView() {
    entireSectionView.backgroundColor = .lightGray
    entireSectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      entireSectionView.width.equal(toConstant: backgroundViewHeight),
      entireSectionView.height.equal(toConstant: backgroundViewHeight),
      entireSectionView.centerX.equal(to: backgroundView.centerX),
      entireSectionView.centerY.equal(to: backgroundView.centerY)
      ])
    entireSectionView.clipsToBounds = true
    entireSectionView.layer.cornerRadius = backgroundViewHeight / 2
  }
  
  /// 일부 비율 부분 뷰 그리기. `endAngle`이 중요하다.
  private func drawPortionSectionView() {
    let path = UIBezierPath()
    path.move(to: entireSectionView.center)
    path.addLine(to: CGPoint(
      x: entireSectionView.frame.width / 2,
      y: entireSectionView.frame.height
    ))
    path.addArc(
      withCenter: entireSectionView.center,
      radius: backgroundViewHeight,
      startAngle: -.pi / 2,
      endAngle: -.pi / 4,
      clockwise: true
    )
    path.close()
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.fillColor = UIColor.black.cgColor
    entireSectionView.layer.addSublayer(shapeLayer)
  }
  
  /// 가운데 빈 효과 내는 원 그리기.
  private func drawCenterHoleView() {
    centerHoleView = UIView()
    centerHoleView.backgroundColor = .white
    backgroundView.addSubview(centerHoleView)
    centerHoleView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      centerHoleView.width.equal(toConstant: backgroundViewHeight / 2),
      centerHoleView.height.equal(toConstant: backgroundViewHeight / 2),
      centerHoleView.centerX.equal(to: backgroundView.centerX),
      centerHoleView.centerY.equal(to: backgroundView.centerY)
      ])
    centerHoleView.clipsToBounds = true
    centerHoleView.layer.cornerRadius = backgroundViewHeight / 2 / 2
  }

  /// 비어 있는 원 안에 퍼센트 레이블 설정하기
  private func setPercentLabel() {
    percentLabel = UILabel()
    percentLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    percentLabel.text = "\(Int(ratio * 100))%"
    percentLabel.translatesAutoresizingMaskIntoConstraints = false
    centerHoleView.addSubview(percentLabel)
    NSLayoutConstraint.activate([
      percentLabel.centerX.equal(to: centerHoleView.centerX),
      percentLabel.centerY.equal(to: centerHoleView.centerY)
      ])
  }
}