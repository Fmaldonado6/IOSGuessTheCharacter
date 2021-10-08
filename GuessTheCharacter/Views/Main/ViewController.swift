//
//  ViewController.swift
//  RESTTutorial
//
//  Created by Fernando Maldonado on 07/10/21.
//

import UIKit
import Kingfisher
import Combine

class ViewController: UIViewController {
    
    @IBOutlet private weak var imageView:UIImageView!
    @IBOutlet private weak var textView:UILabel!
    @IBOutlet private weak var loadingIndicator:UIActivityIndicatorView!
    @IBOutlet private var buttons:[UIButton]!
    
    lazy var viewModel:MainViewModel = {
        let viewModel = MainViewModel()
        return viewModel
    }()
    
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadCharacters()
       
        viewModel.$status
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] status in
                self?.changeStatus(status: status)
        }).store(in: &cancellables)
        
        viewModel.$score
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] score in
                self?.textView.text = String(score)
        }).store(in: &cancellables)
        
        viewModel.$selectedCharacters
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] (characters )in
                guard let selected = characters else{
                    return
                }
                
                guard self != nil else{
                    return
                }
                
                for i in selected.indices{
                    let currentButton = self!.buttons[i]
                    let currentCharacter = selected[i]
                    currentButton.setTitle(currentCharacter.title, for: .normal)
                    currentButton.tag = currentCharacter.mal_id
                }
        }).store(in: &cancellables)
        
        viewModel.$selectedCharacter
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] (character) in
                
                guard let selected = character else{
                    return
                }
                
                self?.imageView.kf.setImage(with:URL(string: selected.image_url))
        }).store(in: &cancellables)
        
        
    }

    @IBAction private func buttonClicked(_ button:UIButton!){

        
        if viewModel.checkAnswer(id: button.tag) {
            viewModel.getRandomCharacter()
            return
        }
        
        let alert = UIAlertController(
            title: "Game Over",
            message: "Correct answer: \(viewModel.selectedCharacter.title)",
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Restart",
                style: .default,
                handler: {_ in
            self.viewModel.restart()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func changeStatus(status:Status){
        imageView.isHidden = status != Status.Loaded
        buttons.forEach{ button in
            button.isHidden = status != Status.Loaded
        }
        textView.isHidden = status != Status.Loaded
        loadingIndicator.isHidden = status != Status.Loading
    }
    
    


}

