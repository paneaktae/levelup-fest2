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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
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
        let bannerWidth = view.frame.width - 30 // 15 margin on each side
        let bannerHeight = view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 130 // Space for navigation and page control
        scrollView.contentSize = CGSize(width: bannerWidth * CGFloat(bannerData.count), height: bannerHeight)
        
        for (index, banner) in bannerData.enumerated() {
            let bannerView = createBannerView(for: banner, at: index, width: bannerWidth, height: bannerHeight)
            scrollView.addSubview(bannerView)
        }
    }
    
    private func createBannerView(for banner: BannerItem, at index: Int, width: CGFloat, height: CGFloat) -> UIView {
        let containerView = UIView()
        containerView.frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: height)
        containerView.backgroundColor = banner.backgroundColor
        containerView.layer.cornerRadius = 20
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.text = banner.subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 20)
        subtitleLabel.textColor = .white
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        // Button
        let button = UIButton(type: .system)
        button.setTitle(banner.buttonText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.6, green: 0.9, blue: 0.8, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(button)
        
        // Credit card mockup view
        let cardView = createCreditCardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cardView)
        
        // Person image placeholder (larger for full screen effect)
        let personImageView = UIImageView()
        personImageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        personImageView.layer.cornerRadius = 12
        personImageView.contentMode = .scaleAspectFill
        personImageView.clipsToBounds = true
        personImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(personImageView)
        
        // Add decorative elements similar to the image
        let decorativeView1 = createDecorativeElement(color: UIColor.white.withAlphaComponent(0.1))
        decorativeView1.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(decorativeView1)
        
        let decorativeView2 = createDecorativeElement(color: UIColor.white.withAlphaComponent(0.15))
        decorativeView2.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(decorativeView2)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.centerXAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.centerXAnchor, constant: -20),
            
            // Button
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            button.heightAnchor.constraint(equalToConstant: 55),
            
            // Credit card (positioned better for full screen)
            cardView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -40),
            cardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            cardView.widthAnchor.constraint(equalToConstant: 140),
            cardView.heightAnchor.constraint(equalToConstant: 88),
            
            // Person image (much larger for full screen effect)
            personImageView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -30),
            personImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            personImageView.widthAnchor.constraint(equalToConstant: min(width * 0.4, 200)),
            personImageView.heightAnchor.constraint(equalToConstant: min(height * 0.4, 250)),
            
            // Decorative elements
            decorativeView1.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            decorativeView1.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            decorativeView1.widthAnchor.constraint(equalToConstant: 80),
            decorativeView1.heightAnchor.constraint(equalToConstant: 80),
            
            decorativeView2.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 50),
            decorativeView2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: width * 0.6),
            decorativeView2.widthAnchor.constraint(equalToConstant: 60),
            decorativeView2.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return containerView
    }
    
    private func createCreditCardView() -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = UIColor.darkGray
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowRadius = 8
        
        // Card number placeholder
        let cardNumberLabel = UILabel()
        cardNumberLabel.text = "**** **** **** 1234"
        cardNumberLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .medium)
        cardNumberLabel.textColor = .white
        cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(cardNumberLabel)
        
        // Bank logo placeholder
        let logoLabel = UILabel()
        logoLabel.text = "K"
        logoLabel.font = UIFont.boldSystemFont(ofSize: 24)
        logoLabel.textColor = .white
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(logoLabel)
        
        // VISA logo
        let visaLabel = UILabel()
        visaLabel.text = "VISA"
        visaLabel.font = UIFont.boldSystemFont(ofSize: 12)
        visaLabel.textColor = .white
        visaLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(visaLabel)
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            logoLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            cardNumberLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardNumberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            visaLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            visaLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12)
        ])
        
        return cardView
    }
    
    private func createDecorativeElement(color: UIColor) -> UIView {
        let decorativeView = UIView()
        decorativeView.backgroundColor = color
        decorativeView.layer.cornerRadius = 30
        decorativeView.alpha = 0.6
        return decorativeView
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
        let bannerWidth = view.frame.width - 30
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
        let bannerWidth = view.frame.width - 30
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

