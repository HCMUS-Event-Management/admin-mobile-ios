import UIKit

class PasswordTextField: UITextField {
    
    let showPasswordButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        // Thiết lập hình ảnh cho nút hiển thị mật khẩu
        let showImage = UIImage(systemName: "eye.fill")
        showPasswordButton.setImage(showImage, for: .normal)
        showPasswordButton.tintColor = .gray
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        // Đặt kiểu hiển thị cho trường nhập mật khẩu
        isSecureTextEntry = true
        rightView = showPasswordButton
        rightViewMode = .always
    }
    
    @objc private func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry
        let showImage = UIImage(systemName: isSecureTextEntry ? "eye.fill" : "eye.slash.fill")
        showPasswordButton.setImage(showImage, for: .normal)
    }
}
