//
//  LineChartView.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/29/26.
//

import UIKit

final class LineChartView: UIView {

    private let axisLayer = CAShapeLayer()
    private let lineLayer = CAShapeLayer()

    private var currentData: [DailyStat] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayers() {
        axisLayer.strokeColor = UIColor.separator.cgColor
        axisLayer.lineWidth = 1
        layer.addSublayer(axisLayer)

        lineLayer.strokeColor = UIColor.label.cgColor
        lineLayer.lineWidth = 2
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round
        layer.addSublayer(lineLayer)
    }

    func render(_ data: [DailyStat]) {
        currentData = data
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawChart(with: currentData)
    }

    private func drawChart(with data: [DailyStat]) {
        guard data.count >= 2 else {
            axisLayer.path = nil
            lineLayer.path = nil
            return
        }

        let values = data.map { CGFloat($0.value) }
        guard let minV = values.min(), let maxV = values.max() else { return }

        let valueRange = max(maxV - minV, 1)

        let inset: CGFloat = 12
        let w = max(bounds.width - inset * 2, 1)
        let h = max(bounds.height - inset * 2, 1)

        func x(_ i: Int) -> CGFloat {
            inset + w * CGFloat(i) / CGFloat(values.count - 1)
        }

        func y(_ v: CGFloat) -> CGFloat {
            let ratio = (v - minV) / valueRange
            return inset + h * (1 - ratio)
        }

        let axis = UIBezierPath()
        axis.move(to: CGPoint(x: inset, y: inset + h))
        axis.addLine(to: CGPoint(x: inset + w, y: inset + h))
        axisLayer.path = axis.cgPath

        let path = UIBezierPath()
        path.move(to: CGPoint(x: x(0), y: y(values[0])))
        for i in 1..<values.count {
            path.addLine(to: CGPoint(x: x(i), y: y(values[i])))
        }
        lineLayer.path = path.cgPath
    }
}
