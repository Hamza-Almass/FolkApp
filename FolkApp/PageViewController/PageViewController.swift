//
//  PageViewController.swift
//  FolkApp
//
//  Created by Hamza Almass on 8/31/21.
//

import UIKit
import EasyPeasy
import Onboard

class PageViewController: UIPageViewController , UIPageViewControllerDelegate , UIPageViewControllerDataSource {
    
    let pages: [UIViewController] = [PageVC(icon: "57183-character-draw-in-the-air", title: "Share your news with World", body: "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the") , PageVC(icon: "57182-boy-touch-tablet", title: "Share your news wih world!", body: "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the")]
    
    var completion: (() -> Void)?
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightArrow"), for: .normal)
        button.backgroundColor = UIColor(red: 251 / 155, green: 173 / 255, blue: 24 / 255, alpha: 1)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()
    
    let prevButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "leftArrow"), for: .normal)
        button.backgroundColor = UIColor(red: 85 / 255, green: 0, blue: 150 / 255, alpha: 1)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    var initialPage: Int = 0
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: kBGCOLOR)
        
        view.accessibilityIdentifier = "onboardingView"
        
        self.delegate = self
        self.dataSource = self
        
        prevButton.isHidden = true
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        
        style()
        
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        
        nextButton.accessibilityIdentifier = "next"
        prevButton.accessibilityIdentifier = "prev"
       
    }
    
    //MARK:- Handle next page
    /**
     - Description: Handle next page in page view controller
     - Parameter: No
     - Return: No
     */
    @objc fileprivate func handleNext(){
        initialPage += 1
        if  initialPage <= pages.count - 1 {
            prevButton.isHidden = false
            setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        }else{
            //initialPage = pages.count - 1
            self.dismiss(animated: true, completion: { [weak self] in
                guard let s = self else { return }
                s.completion?()
            })
        }
    }
    
    //MARK:- Handle prev page
    
    /**
     - Description: Handle prev page in page view controller
     - Parameter: No
     - Return: No
     */
    
    @objc fileprivate func handlePrev(){
        initialPage -= 1
        if initialPage >= 0 && initialPage < pages.count - 1 {
            setViewControllers([pages[initialPage]], direction: .reverse, animated: true, completion: nil)
            prevButton.isHidden = true
        }else{
            initialPage = 0
        }
    }
    
    /**
     - Description: To style the next and prev button at bottom page view controller
     */
    fileprivate func style(){
        view.addSubview(nextButton)
        view.addSubview(prevButton)
        nextButton.easy.layout(Trailing(0),Width(55),Height(55),Bottom(0))
        prevButton.easy.layout(Leading(0),Bottom(0),Width(55),Height(55))
    }
    
}

//MARK:- Extension Pageview controller data source & delegate
extension PageViewController {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil}
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil}
        
        if  (currentIndex) > 0{
            return pages[currentIndex - 1]
        }else if currentIndex == 0 {
            return nil
        }
    
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let controllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: controllers[0]) else { return }
        initialPage = currentIndex
        if currentIndex > 0 {
            prevButton.isHidden = false
        }else{
            prevButton.isHidden = true
        }
     
    }
}
