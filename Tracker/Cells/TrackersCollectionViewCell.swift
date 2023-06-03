

import UIKit



final class TrackersCollectionViewCell: UICollectionViewCell {
    
    let emojiLabel: UILabel = {
        let label = RoundedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.layer.cornerRadius = label.bounds.height / 2
        label.layer.masksToBounds = true
        return label
    }()
    
    let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = Resources.Colors.Sections.colorSection2
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let trackerTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Resources.Colors.ypWhite
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        label.text = "Привет, как твои дела?"
        return label
    }()
    
    let trackerCompleteButton: RoundedButton = {
        let button = RoundedButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Resources.Colors.Sections.colorSection2
        let image = UIImage(systemName: "plus")
        button.tintColor = .white
        button.setImage(image, for: .normal)
        return button
    }()
    
    let counterTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "1 день"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
        setupLayout()
    }
    
    private func setupCellUI() {
        contentView.addSubview(colorView)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(trackerTextLabel)
        contentView.addSubview(trackerCompleteButton)
        contentView.addSubview(counterTextLabel)
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(contentView.bounds.height * 0.39)),
            
            trackerTextLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            trackerTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            trackerTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44),
            trackerTextLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            
            trackerCompleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            trackerCompleteButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            trackerCompleteButton.heightAnchor.constraint(equalToConstant: 34),
            trackerCompleteButton.widthAnchor.constraint(equalToConstant: 34),
            
            counterTextLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            counterTextLabel.centerYAnchor.constraint(equalTo: trackerCompleteButton.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
