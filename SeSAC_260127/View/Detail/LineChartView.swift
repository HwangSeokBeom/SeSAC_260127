//
//  LineChartView.swift
//  SeSAC_260127
//
//  Created by Hwangseokbeom on 1/29/26.
//

import UIKit
import DGCharts

final class LineChartView: UIView {

    private let chartView: DGCharts.LineChartView = {
        let v = DGCharts.LineChartView()
        v.backgroundColor = .secondarySystemBackground
        v.layer.cornerRadius = 8
        v.clipsToBounds = true
        return v
    }()

    private var currentData: [DailyStat] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureChartStyle()
        addSubview(chartView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
    }

    func render(_ data: [DailyStat], animated: Bool = true) {
        currentData = data
        applyData(animated: animated)
    }

    private func configureChartStyle() {
        chartView.legend.enabled = false
        chartView.chartDescription.enabled = false

        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false

        chartView.noDataText = "차트 데이터가 없어요"
        chartView.noDataFont = .systemFont(ofSize: 13, weight: .medium)
        chartView.noDataTextColor = .secondaryLabel

        // X axis
        let x = chartView.xAxis
        x.labelPosition = .bottom
        x.drawGridLinesEnabled = false
        x.drawAxisLineEnabled = false
        x.labelFont = .systemFont(ofSize: 11, weight: .medium)
        x.labelTextColor = .secondaryLabel
        x.granularity = 1
        x.avoidFirstLastClippingEnabled = true

        // Left axis
        let left = chartView.leftAxis
        left.drawAxisLineEnabled = false
        left.labelFont = .systemFont(ofSize: 11, weight: .medium)
        left.labelTextColor = .secondaryLabel
        left.gridColor = UIColor.separator.withAlphaComponent(0.35)
        left.gridLineWidth = 1
        left.axisMinimum = 0

        // Right axis off
        chartView.rightAxis.enabled = false

        chartView.highlightPerTapEnabled = false
    }

    private func applyData(animated: Bool) {
        guard currentData.count >= 2 else {
            chartView.data = nil
            return
        }

        // x는 인덱스, 라벨은 날짜로
        let entries: [ChartDataEntry] = currentData.enumerated().map { idx, s in
            ChartDataEntry(x: Double(idx), y: Double(s.value))
        }

        let set = LineChartDataSet(entries: entries, label: "")

        set.mode = LineChartDataSet.Mode.cubicBezier
        set.cubicIntensity = 0.2

        set.lineWidth = 2.5
        set.setColor(UIColor.systemGreen)
        set.drawValuesEnabled = false
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.highlightEnabled = false

        set.drawFilledEnabled = true
        set.fillColor = UIColor.systemGreen
        set.fillAlpha = 0.35

        let data = LineChartData(dataSet: set)
        chartView.data = data

        let labels = currentData.map { FormatterManager.statChartDate.string(from: $0.date) }
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)

        chartView.xAxis.labelCount = min(6, labels.count)

        chartView.notifyDataSetChanged()

        if animated {
            chartView.animate(xAxisDuration: 0.25, easingOption: .easeOutSine)
        }
    }
}
