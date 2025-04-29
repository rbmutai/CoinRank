//
//  DetailViewController.swift
//  CoinRank
//
//  Created by Robert Mutai on 24/04/2025.
//

import UIKit
import SwiftUI
class DetailViewController: UIViewController {
    var viewModel: DetailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Coin Details"
        
        guard let viewModel = viewModel else { return }
        
        //SwiftUI View
        let detailView = DetailView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: detailView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
