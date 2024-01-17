//
//  DefinitionViewController.swift
//  DictHome
//
//  Created by Kholmumin Tursinboev on 17/01/24.
//

import UIKit
import Lottie

class DefinitionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pronouncedLbl: UILabel!
    @IBOutlet weak var actualWord: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    
    var dataSource: SearchData?
    var word:String = ""
    let dataFetcher = SearchRequest()
    let animationView = LottieAnimationView()
    let audioPlayer = AudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MeaningTableViewCell", bundle: nil), forCellReuseIdentifier: "MeaningTableViewCell")
        tableView.register(UINib(nibName: "SynTableViewCell", bundle: nil), forCellReuseIdentifier: "SynTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearLabels()
        fetchData()
        makeAnimation()
        tableView.isHidden = true
        playBtn.isHidden = true
        tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearLabels()
        tableView.reloadData()
    }
    
    func clearLabels(){
        self.pronouncedLbl.text = ""
        self.actualWord.text = ""
    }
    
    func makeAnimation(){
        animationView.animation = LottieAnimation.named("loading")
        animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        animationView.center = self.view.center
        animationView.loopMode = .loop
        view.addSubview(animationView)
        animationView.play()
        
    }
    
    
    @IBAction func playPressed(_ sender: UIButton) {
        guard let audio = dataSource?.phonetics.first?.audio else{return}
        if let audioURL = URL(string: audio) {
            audioPlayer.playAudio(from: audioURL)
        }
        
    }
}




//MARK: - Fetch Data
extension DefinitionViewController {
    func fetchData(){
        dataFetcher.fetchData(for: word) { result in
            DispatchQueue.main.async {
                self.animationView.stop()
                self.animationView.isHidden = true
            }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.dataSource = success.first
                    self.updateUIWithFetchedData()
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    if self.dataSource?.phonetics.first?.audio != ""{
                        self.playBtn.isHidden = false
                    }
                    
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showFetchError()
                    self.tableView.isHidden = true
                }
            }
        }
    }
    
    func updateUIWithFetchedData() {
        if let dataSource = self.dataSource {
            self.pronouncedLbl.text = dataSource.phonetic
            self.actualWord.text = dataSource.word
        }
    }
    
    func showFetchError() {
        let alert = UIAlertController(title: "Error", message: "Can not find this word", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}


//MARK: - Table Delegates
extension DefinitionViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.meanings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource?.meanings[section].partOfSpeech
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let meaning = dataSource?.meanings[section]
        var rowCount = meaning?.definitions.count ?? 0
        if !(meaning?.synonyms.isEmpty ?? true) || !(meaning?.antonyms.isEmpty ?? true) {
            rowCount += 1
        }
        return rowCount
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meaning = dataSource?.meanings[indexPath.section]
        if indexPath.row < (meaning?.definitions.count ?? 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeaningTableViewCell", for: indexPath) as? MeaningTableViewCell else {
                fatalError("Failed to dequeue MeaningTableViewCell")
            }
            let definition = meaning?.definitions[indexPath.row]
            cell.meaning.text = definition?.definition
            cell.definition.text = definition?.example
            return cell
        } else {
            guard let synAntCell = tableView.dequeueReusableCell(withIdentifier: "SynTableViewCell", for: indexPath) as? SynTableViewCell else {
                fatalError("Failed to dequeue SynTableViewCell")
            }
            synAntCell.synonim.text = (!(meaning?.synonyms.isEmpty)!) ? "Synonyms: \(meaning?.synonyms.joined(separator: ", ") ?? "None")" : ""
            synAntCell.anty.text = (!(meaning?.antonyms.isEmpty)!) ? "Antonyms: \(meaning?.antonyms.joined(separator: ", ") ?? "None")" : ""
            return synAntCell
        }
    }
    
    
}
