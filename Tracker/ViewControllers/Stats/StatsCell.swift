import UIKit

final class StatsCell: UITableViewCell {
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        setupBorder()
    }
    
    private func setupBorder() {
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.red.cgColor
        let gradient = CAGradientLayer()
            gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
            gradient.colors = [UIColor.blue.cgColor, UIColor.green.cgColor]

            let shape = CAShapeLayer()
            shape.lineWidth = 2
            shape.path = UIBezierPath(rect: self.bounds).cgPath
            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor
            gradient.mask = shape

            self.layer.addSublayer(gradient)
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        addSubview(countLabel)
        addSubview(headerLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            headerLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: countLabel.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
