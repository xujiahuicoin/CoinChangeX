//



import UIKit
let textviewText = "长按复制密钥(首次必填)"
import GZIP
class XJH_LoginVC: XJHBaseViewController ,UITextFieldDelegate,UITextViewDelegate{
    
    var listArray : [String] = []
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        XJH_loadServerList()
        
        if appTesting{
            self.XJH_textT_addUI()
            
            
            
            self.XJH_textT_accountTextF.text = ""
            self.XJH_textT_passWordTF.text = ""
            self.XJH_keyPairTextView.text = ""
        }
        
        self.view.backgroundColor = XJHBackgroundColor_dark
    }
    
    //加载服务器
    @objc func XJH_loadServerList(){
        
        XJH_GitHub.GitHubProjectPathdict(pathUrl: xjh_GitServerList, blockSuccess: { (mods) in
            
            DispatchQueue.main.async(execute: {
                for mod in mods {
                    //只加入w
                    if mod.type == "dir"{
                        self.listArray.append(mod.name)
                    }
                }
                
                self.addPickView()
            })
            
        }) { (err) in
            
            self.perform(#selector(self.XJH_loadServerList), with: self, afterDelay: 3)
        }
        
        
    }
    
    func addPickView(){
        
        self.view.addSubview(self.pickview)
        self.pickview.snp.makeConstraints { (ma) in
            
            ma.width.equalTo(SCREEN_WIDTH-50)
            ma.height.equalTo(SCREEN_HEIGHT/2)
            ma.center.equalToSuperview()
        }
        
        
        self.pickview.xjh_updateTableView(datas: listArray)
        self.pickview.alpha = 0
        
    }
    
    func XJH_textT_addUI()  {
        
        self.view.addSubview(self.XJH_view_holeView)
        self.view.addSubview(self.XJH_View_account)
        self.view.addSubview(self.XJH_textT_passWord)
        self.view.addSubview(self.XJH_Button_loginBut)
        self.view.addSubview(XJH_keyPairTextView)
        self.view.addSubview(toolBtn)
        self.toolBtn.addSubview(seaverlab)
        self.view.addSubview(XJH_Button_ChangeData)
        
        
        self.XJH_View_account.snp.makeConstraints { (make) in
            make.top.equalTo(self.XJH_view_holeView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(45)
        }
        self.XJH_textT_passWord.snp.makeConstraints { (make) in
            make.top.equalTo(self.XJH_View_account.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(45)
        }
        
        self.XJH_Button_loginBut.snp.makeConstraints { (make) in
            make.top.equalTo(self.XJH_textT_passWord.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(45)
        }
        
        XJH_keyPairTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.XJH_Button_loginBut.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(75)
        }
        
        toolBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.XJH_keyPairTextView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(45)
            
        }
        seaverlab.snp.makeConstraints { (ma) in
            ma.left.equalTo(20)
            ma.centerY.equalToSuperview()
        }
        
        XJH_Button_ChangeData.snp.makeConstraints { (make) in
                      make.top.equalTo(self.toolBtn.snp.bottom).offset(10)
//                                 make.width.equalToSuperview().offset(150)
                                 make.left.equalTo(30)
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
    
    ///登录按钮
    @objc func XJH_private_loginButtonAction(){
        
        self.view.endEditing(true)
        
        let userNameStr : String = self.XJH_textT_accountTextF.text!
        let passwordStr : String = self.XJH_textT_passWordTF.text!
        let pairTexrStr : String = self.XJH_keyPairTextView.text!
        
        xjh_HUDShow()
        
        XJH_UserDataTool.XJH_Login_ParameterJudgmentBeforeLogin(userNameStr: userNameStr, passwordStr: passwordStr, pairTexrStr: pairTexrStr, Vc: self) { (state) in
            self.xjh_hideHUD()
        }
        
    }
    
    ///加密处理
    @objc func XJH_private_GoinChangeDataVC(){
        
        self.present(XJHDataAESViewController(), animated: true, completion: nil)
    }
    
    ///显示服务器列表
    @objc func transationsString(){
        
        if self.listArray.count < 1 {
            BaseAlertController.showAlertOneAction(message: "服务器正在加载", vc: self) {}
            return
        }
        
        self.pickview.XJH_futuresOperatorTabHide(show: true)
    }
    ///textView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textviewText{
            textView.text = ""
        }
    }
    
    override func xjh_UIViewCollectEvent(eventObject: ViewEventObject) {
        if eventObject.event_CodeType == OkexPageAction.xjh_transactionPairTabRow.rawValue{
            
            self.pickview.XJH_futuresOperatorTabHide(show: false)
            
            //
            let row:Int = eventObject.params as! Int
            let str = listArray[row]
            self.toolBtn.setTitle(str, for: .normal)
            
            //保存服务器到本地
            XJH_UserInfo.XJH_WriteUserInfoPlist(key: serverNameKey, value: str)
        }
    }
    
    //------------------------------------
    var XJH_textT_accountTextF : UITextField!
    var XJH_textT_passWordTF : UITextField!
    
    lazy var XJH_Button_loginBut : UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = XJHMainColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("登录", for: .normal)
        button.addTarget(self, action: #selector(XJH_private_loginButtonAction), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.layer.cornerRadius = 3
        button.maskToBounds = true
        return button
    }()
    
    lazy var XJH_view_holeView : UIView = {
        let view = UIView(frame: CGRect(x: iPhoneWidth(w: 40), y: navHeight + iPhoneWidth(w: 30), width: SCREEN_WIDTH-iPhoneWidth(w: 170), height: iPhoneWidth(w: 170)), backgroundColor: .clear)
        //你好
        let hole = UILabel(frame: CGRect(x: 0, y: 0, width: view.width, height: iPhoneWidth(w: 40)), text: "需指定账号、密码登录", font: FontBold(font: XJHFontNum_Max()), color: XJHMainTextColor_dark, alignment: .center, lines: 1)
        view.addSubview(hole)
        
        //欢迎登录
        let coming = UILabel(frame: CGRect(x: 0, y: iPhoneWidth(w: 40), width: view.width, height: iPhoneWidth(w: 40)), text: "首次登录，需要在登录按钮下方输入密钥", font: FontBold(font: XJHFontNum_Main()), color: XJHMainTextColor_dark, alignment: .center, lines: 1)
        view.addSubview(coming)
        
        return view
    }()
    
    lazy var XJH_View_account : UIView = {
        
        let bgview :UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: xjh_WidthScreen - 50, height: 35) , backgroundColor: XJHMainColor)
        bgview.layer.masksToBounds = true
        bgview.layer.cornerRadius = 3
        let image :UIImageView = UIImageView.init(frame: CGRect(x: 10, y: 12, width: 20, height: 20), image: UIImage(named: "myImage_img1")!)
        
        let acctext : UITextField = UITextField.init(frame:CGRect(x: 40, y: 0, width: xjh_WidthScreen - 90, height: 45))
        acctext.placeholder = "请输入账号"
        acctext.textColor = XJHMainTextColor_dark
        
        
        acctext.backgroundColor = XJHMainColor
        self.XJH_textT_accountTextF = acctext
        bgview.addSubview(image)
        bgview.addSubview(acctext)
        
        return bgview
        
    }()
    
    lazy var XJH_textT_passWord : UIView = {
        let bgview :UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: xjh_WidthScreen - 50, height: 35) , backgroundColor: XJHMainColor)
        bgview.layer.masksToBounds = true
        bgview.layer.cornerRadius = 3
        let image :UIImageView = UIImageView.init(frame: CGRect(x: 10, y: 12, width: 20, height: 20), image: UIImage(named: "yaoshisuo_img1")!)
        
        let passWordTF : UITextField = UITextField.init(frame:CGRect(x: 40, y: 0, width: xjh_WidthScreen - 90, height: 45))
        passWordTF.placeholder = "请输入密码"
        passWordTF.textColor = XJHMainTextColor_dark
        passWordTF.isSecureTextEntry = true
        passWordTF.backgroundColor = XJHMainColor
        self.XJH_textT_passWordTF = passWordTF
        
        bgview.addSubview(image)
        bgview.addSubview(passWordTF)
        
        return bgview
        
    }()
    
    
    lazy var XJH_keyPairTextView : UITextView = {
        let textV = UITextView(Xframe: .zero, text: textviewText, font: Font(font: XJHFontNum_Second()), textAlignment: .left, textColor: XJHMainTextColor_dark, backgroundColor: XJHMainColor, cornerRadius: 4, borderColor: XJHSecondTextColor, borderWidth: 0.5)
        textV.delegate = self
        return textV
    }()
    
    lazy var toolBtn : UIButton = {
        
        let serverName = XJH_UserInfo.XJH_getServerNameInInfo()
        
        let btn = UIButton(Xframe: .zero, title: serverName.count > 0 ? serverName : serverTishi , titleColor: XJHButtonColor_Blue, font: Font(font: XJHFontNum_Main()), backgroundColor: XJHMainColor, cornerRadius: 4, borderWidth: 0.05, borderColor: XJHMainColor)
        btn.addTarget(self, action: #selector(transationsString), for: .touchUpInside)
        
        return btn
    }()
    
    ///服务器提示
    lazy var seaverlab : UILabel = {
        let lab = UILabel(Xframe: .zero, text: "当前服务器:", font: Font(font: XJHFontNum_Second()), textColor: XJHMainTextColor_White, backgroundColor: .clear)
        return lab
    }()
    
    
    
    lazy var pickview : XJH_Okex_CurrencyPairTV = {
        var pick = XJH_Okex_CurrencyPairTV.view()
        pick!.delegate = self
        pick!.xjh_cellHeaderStr = "服务器列表"
        pick?.border(color: .gray, radius: 1, width: 1)
        pick?.cornerRadius(10)
        return pick!
    }()
    
    lazy var XJH_Button_ChangeData : UIButton = {
           let button = UIButton.init(type: .custom)
//           button.backgroundColor = XJHMainColor
           button.setTitleColor(UIColor.white, for: .normal)
           button.setTitle("加密工具🔧", for: .normal)
           button.addTarget(self, action: #selector(XJH_private_GoinChangeDataVC), for: .touchUpInside)
           button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
           button.layer.cornerRadius = 3
           button.maskToBounds = true
           return button
       }()
    
}
