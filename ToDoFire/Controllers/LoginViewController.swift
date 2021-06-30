//
//  ViewController.swift
//  ToDoFire
//
//  Created by macbookp on 20.03.2021.
//
import Firebase
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        bottomLabel.alpha = 0
        scrollViewDueKeyboard()
        checkAuth()
        ref = Database.database().reference(withPath: "users")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    private func checkAuth() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil{
            self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
            }
        }
    }
    
    private func scrollViewDueKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -200.0
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0.0
        }
    }
    
    private func displayBottomLabel(withText text: String) {
        bottomLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {[weak self] in
            self?.bottomLabel.alpha = 1
        }) {[weak self] (complete) in
            self?.bottomLabel.alpha = 0
        }
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonPressed() {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayBottomLabel(withText: "Info is incorrect")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayBottomLabel(withText: "Wrong")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            } else {
                self?.displayBottomLabel(withText: "No such user")
            }
        }
    }
    
    
    @IBAction func registerButtonPressed() {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayBottomLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password,completion:  {[weak self] (result, error) in
            guard error == nil, result != nil else {
                print(error!.localizedDescription)
                return
            }
            let userRef = self?.ref.child((result?.user.uid)!)
            userRef?.setValue(["email":result?.user.email])
        })
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
