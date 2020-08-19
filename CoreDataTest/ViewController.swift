//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Victor Vieira on 19/08/20.
//  Copyright © 2020 Victor Vieira. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textCodigo: UITextField!
    @IBOutlet var textDescricao: UITextField!
    @IBOutlet var tbDados: UITableView!
    @IBOutlet var btnSalvar: UIButton!
    @IBOutlet var btnExcluir: UIButton!
    @IBOutlet var btnAlterar: UIButton!
    
    
    var tbAtividade: TBatividade? = nil
    var listaAtividade: [TBatividade] = []
    var atividadeSel: TBatividade? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textCodigo.delegate = self
        textDescricao.delegate = self
        atualizaDados()
        
    }
    
    func atualizaDados(){
        let fetch:NSFetchRequest = TBatividade.fetchRequest()
        do{
            listaAtividade = try DataBaseController.getContext().fetch(fetch)
        } catch{
            
        }
        tbDados.reloadData()
        textCodigo.text = ""
        textDescricao.text = ""
        btnSalvar.isEnabled = true
        btnAlterar.isEnabled = false
        btnExcluir.isEnabled = false
        atividadeSel = nil
    }
    
    
    @IBAction func salvar(){
        if textCodigo.text?.count ?? 0 > 0 && textDescricao.text?.count ?? 0 > 0{
            let db = DataBaseController.getContext()
            tbAtividade = NSEntityDescription.insertNewObject(forEntityName: "TBatividade", into: db) as! TBatividade
            tbAtividade?.atiCodigo = Int32(textCodigo.text!) ?? 0
            tbAtividade?.atiDescricao = textDescricao.text
            tbAtividade?.atiSituacao = true
            DataBaseController.saveContext(db)
            atualizaDados()
        }
    }
    
    @IBAction func excluir(){
        if atividadeSel != nil{
            let fetchExcluir: NSFetchRequest = TBatividade.fetchRequest()
            fetchExcluir.predicate = NSPredicate(format: " atiCodigo == %@ ", "\(atividadeSel!.atiCodigo)")// " atiCodigo == %@ and atiDescricao == %@ ", "\(atividadeSel!.atiCodigo)","\(atividadeSel!.atiDescricao)"
            let delRequest = NSBatchDeleteRequest(fetchRequest: fetchExcluir as! NSFetchRequest<NSFetchRequestResult>)
            do{
                try DataBaseController.getContext().execute(delRequest)
            } catch{}
            atualizaDados()
        }
            
    }
    
    @IBAction func alterar(){
        if textCodigo.text?.count ?? 0 > 0 && textDescricao.text?.count ?? 0 > 0{
            atividadeSel?.setValue(textDescricao.text, forKey: "atiDescricao")
            atividadeSel?.setValue(Int32(textCodigo.text!) ?? 0, forKey: "atiCodigo")
            DataBaseController.saveContext(DataBaseController.getContext())
            atualizaDados()
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaAtividade.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CellDados", owner: self, options: nil)?.first as! CellDados
        let atividade = listaAtividade[indexPath.row]
        cell.lblDescricao.text = "\(atividade.atiCodigo)- \(atividade.atiDescricao!)"
        
        if atividade.atiSituacao{
            cell.lblSituacao.text = "Ativo"
        }
        else {
            cell.lblSituacao.text = "Inativo"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        atividadeSel = listaAtividade[indexPath.row]
        textDescricao.text = atividadeSel!.atiDescricao
        textCodigo.text = String(atividadeSel!.atiCodigo)
        
        btnSalvar.isEnabled = false
        btnAlterar.isEnabled = true
        btnExcluir.isEnabled = true
    }
    
    
}

extension ViewController: UITableViewDelegate{
     
}
