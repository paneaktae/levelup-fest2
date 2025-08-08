//
//  ViewController.swift
//  POCMultibanner
//
//  Created by Teravat Netpiyachat on 8/8/2568 BE.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var autoScrollTimer: Timer?
    
    // MARK: - Banner Data
    private let bannerData = [
        BannerItem(
            title: "สมัครบัตรนี้",
            subtitle: "ลูกค้าใหม่ ใช้จ่ายครบ\nแลกรับคะแนน X2",
            buttonText: "เข้าสู่ K PLUS",
            imageName: "banner1",
            backgroundColor: UIColor(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
        ),
        BannerItem(
            title: "FINAL CALL!",
            subtitle: "โอกาสสุดท้าย\nรับสิทธิพิเศษ",
            buttonText: "เข้าสู่ K PLUS",
            imageName: "banner2",
            backgroundColor: UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        ),
        BannerItem(
            title: "ข้อเสนอพิเศษ",
            subtitle: "สำหรับสมาชิก\nKbank เท่านั้น",
            buttonText: "เข้าสู่ K PLUS",
            imageName: "banner3",
            backgroundColor: UIColor(red: 0.9, green: 0.4, blue: 0.6, alpha: 1.0)
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBanners()
        startAutoScroll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
    deinit {
        stopAutoScroll()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = UIColor.black
        
        setupScrollView()
        setupPageControl()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = bannerData.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupBanners() {
        let bannerWidth = view.frame.width - 40 // 20 margin on each side
        scrollView.contentSize = CGSize(width: bannerWidth * CGFloat(bannerData.count), height: 400)
        
        for (index, banner) in bannerData.enumerated() {
            let bannerView = createBannerView(for: banner, at: index, width: bannerWidth)
            scrollView.addSubview(bannerView)
        }
    }
    
    private func createBannerView(for banner: BannerItem, at index: Int, width: CGFloat) -> UIView {
        let containerView = UIView()
        containerView.frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: 400)
        containerView.backgroundColor = banner.backgroundColor
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        // Background gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [
            banner.backgroundColor.cgColor,
            banner.backgroundColor.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = banner.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.text = banner.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        // Button
        let button = UIButton(type: .system)
        button.setTitle(banner.buttonText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.6, green: 0.9, blue: 0.8, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(button)
        
        // Credit card mockup view
        let cardView = createCreditCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cardView)
        
        // Person image placeholder
        let personImageView = UIImageView()
        personImageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        personImageView.layer.cornerRadius = 8
        personImageView.contentMode = .scaleAspectFill
        personImageView.clipsToBounds = true
        personImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(personImageView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.centerXAnchor, constant: -10),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.centerXAnchor, constant: -10),
            
            // Button
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            // Credit card
            cardView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            cardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cardView.widthAnchor.constraint(equalToConstant: 120),
            cardView.heightAnchor.constraint(equalToConstant: 75),
            
            // Person image
            personImageView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
            personImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            personImageView.widthAnchor.constraint(equalToConstant: 150),
            personImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        return containerView
    }
    
    private func createCreditCardView() -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = UIColor.darkGray
        cardView.layer.cornerRadius = 8
        
        // Card number placeholder
        let cardNumberLabel = UILabel()
        cardNumberLabel.text = "**** **** **** 1234"
        cardNumberLabel.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .medium)
        cardNumberLabel.textColor = .white
        cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(cardNumberLabel)
        
        // Bank logo placeholder
        let logoLabel = UILabel()
        logoLabel.text = "K"
        logoLabel.font = UIFont.boldSystemFont(ofSize: 20)
        logoLabel.textColor = .white
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(logoLabel)
        
        // VISA logo
        let visaLabel = UILabel()
        visaLabel.text = "VISA"
        visaLabel.font = UIFont.boldSystemFont(ofSize: 10)
        visaLabel.textColor = .white
        visaLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(visaLabel)
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            logoLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            
            cardNumberLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardNumberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            
            visaLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            visaLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8)
        ])
        
        return cardView
    }
    
    // MARK: - Auto Scroll Methods
    private func startAutoScroll() {
        stopAutoScroll() // Stop any existing timer
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScrollToNext), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    @objc private func autoScrollToNext() {
        let nextPage = (pageControl.currentPage + 1) % bannerData.count
        scrollToPage(nextPage, animated: true)
    }
    
    private func scrollToPage(_ page: Int, animated: Bool) {
        let bannerWidth = view.frame.width - 40
        let offset = CGPoint(x: bannerWidth * CGFloat(page), y: 0)
        scrollView.setContentOffset(offset, animated: animated)
    }
    
    @objc private func pageControlChanged() {
        scrollToPage(pageControl.currentPage, animated: true)
        // Restart auto scroll timer when user manually changes page
        startAutoScroll()
    }
}

// MARK: - UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bannerWidth = view.frame.width - 40
        let currentPage = Int((scrollView.contentOffset.x + bannerWidth / 2) / bannerWidth)
        pageControl.currentPage = currentPage
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Stop auto scroll when user starts dragging
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Restart auto scroll after user stops dragging
        if !decelerate {
            startAutoScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Restart auto scroll after deceleration ends
        startAutoScroll()
    }
}

// MARK: - Banner Data Model
struct BannerItem {
    let title: String
    let subtitle: String
    let buttonText: String
    let imageName: String
    let backgroundColor: UIColor
}

