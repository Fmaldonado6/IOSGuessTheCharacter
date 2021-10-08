//
//  MainViewModel.swift
//  RESTTutorial
//
//  Created by Fernando Maldonado on 07/10/21.
//

import Foundation

class MainViewModel:ObservableObject{
    
    private let jikanDataSource = JikanDataSource()
    private var characterList:[Character]!
    @Published var selectedCharacter:Character!
    @Published var selectedCharacters:[Character]!
    @Published var status:Status = Status.Loading
    @Published var score = 0
    
    
    func loadCharacters(){
        changeStatus(status: Status.Loading)
        Task{
            do{
                let characters = try await jikanDataSource.getCharacters()
                characterList = characters
                getRandomCharacter()
                changeStatus(status: Status.Loaded)
            }catch {
                print(error)
            }
        }
    }
    
    func getRandomCharacter(){
        let characters = Array(characterList.shuffled().prefix(4))
        selectedCharacter = characters.randomElement()
        selectedCharacters = characters
        characterList = characterList.filter({x in x.mal_id != selectedCharacter.mal_id})
    }
    
    func checkAnswer(id:Int)->Bool{
        if(id == selectedCharacter.mal_id){
            score += 1
            return true
        }
        
        return false
    }
    
    func restart(){
        score = 0
        loadCharacters()
    }
    
    func changeStatus(status:Status){
        self.status = status
    }
    
    
}

