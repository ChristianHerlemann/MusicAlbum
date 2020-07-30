//
//  OnboardingViewController.swift
//  MusicAlbum
//
//  Created by Chris Herlemann on 2020-07-25.
//  Copyright © 2020 Chris Herlemann. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
   func onboardingDidFinish(_ controller: OnboardingViewController)
}

class OnboardingViewController: UIViewController, Storyboarded {
 
   weak var delegate: OnboardingViewControllerDelegate?
   
   @IBAction func skipTapped(_ sender: Any) {
      self.closeOnboarding()
   }
   
   func closeOnboarding() {
      delegate?.onboardingDidFinish(self)
   }
}

class OnboardingStepsViewController: UIViewController, Storyboarded {

   weak var delegate: OnboardingViewControllerDelegate?
   
   @IBOutlet weak var svIntroSteps: UIScrollView!
   @IBOutlet weak var btnNext: UIButton!
   @IBOutlet weak var pageControl: UIPageControl!
   var pageWidth: CGFloat = 0
   var onboardingSteps:[OnboardingStepView] = [];
   
   override func viewDidLoad()
   {
      super.viewDidLoad()
      
      onboardingSteps = createOnboardingSteps()
      setupIntroStepsScrollView()
      svIntroSteps.delegate = self
      svIntroSteps.showsHorizontalScrollIndicator = false
      
      pageWidth = view.frame.width
   }
   
   @IBAction func dismiss(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
   }
   
   func createOnboardingSteps() -> [OnboardingStepView] {

      let slide1:OnboardingStepView = Bundle.main.loadNibNamed("OnboardingStep", owner: self, options: nil)?.first as! OnboardingStepView
      slide1.onboardingImage.image = UIImage(named: "onboardingSave")
      slide1.onboardingTitle.text = "Home"
      slide1.onboardingDescription.text = "Save all your favorite Albums right at your fingertip."
       
      let slide2:OnboardingStepView = Bundle.main.loadNibNamed("OnboardingStep", owner: self, options: nil)?.first as! OnboardingStepView
      slide2.onboardingImage.image = UIImage(named: "onboardingSearch")
      slide2.onboardingTitle.text = "Search"
      slide2.onboardingDescription.text = "Search for new albums fast and easy"
       
      let slide3:OnboardingStepView = Bundle.main.loadNibNamed("OnboardingStep", owner: self, options: nil)?.first as! OnboardingStepView
      slide3.onboardingImage.image = UIImage(named: "onboardingDetail")
      slide3.onboardingTitle.text = "Details"
      slide3.onboardingDescription.text = "Show all details about your Album"
       
       return [slide1, slide2, slide3]
   }

   @IBAction func btnNextTapped(_ sender: Any)
   {
      guard pageControl.currentPage < onboardingSteps.count - 1 else {
         self.dismiss(animated: true, completion: nil)
         return
      }
      
      UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
         self.svIntroSteps.contentOffset.x = CGFloat(self.pageControl.currentPage + 1) * self.pageWidth
      }, completion: nil)
      
   }
}

extension OnboardingStepsViewController: UIScrollViewDelegate {
   func setupIntroStepsScrollView() {
       svIntroSteps.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
      svIntroSteps.contentSize = CGSize(width: view.frame.width * CGFloat(onboardingSteps.count), height: view.frame.height-80)
       svIntroSteps.isPagingEnabled = true
       
       for i in 0 ..< onboardingSteps.count {
           onboardingSteps[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
           svIntroSteps.addSubview(onboardingSteps[i])
       }
   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
      pageControl.currentPage = Int(pageIndex)
   }
}

class OnboardingStepView: UIView{
   
   @IBOutlet weak var onboardingImage: UIImageView!
   @IBOutlet weak var onboardingTitle: UILabel!
   @IBOutlet weak var onboardingDescription: UILabel!
}
