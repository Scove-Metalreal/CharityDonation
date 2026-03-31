package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

@Service
public class EmailServiceImpl implements EmailService {

    @Autowired
    private JavaMailSender mailSender;

    private String formatCurrency(BigDecimal amount) {
        NumberFormat vnFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
        return vnFormat.format(amount);
    }

    @Override
    public void sendDonationSubmissionEmail(String toEmail, String donorName, String campaignName, BigDecimal amount, String transactionCode) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Cảm ơn bạn đã quyên góp - CharityDonation");
        message.setText("Xin chào " + donorName + ",\n\n" +
                "Cảm ơn bạn đã quyên góp số tiền " + formatCurrency(amount) + " cho chiến dịch: " + campaignName + ".\n" +
                "Mã giao dịch của bạn là: " + transactionCode + ".\n\n" +
                "Hiện tại giao dịch của bạn đang được chúng tôi xác minh. Chúng tôi sẽ gửi thông báo cho bạn ngay khi quá trình xác minh hoàn tất.\n\n" +
                "Trân trọng,\n" +
                "Đội ngũ CharityDonation");
        mailSender.send(message);
    }

    @Override
    public void sendDonationApprovalEmail(String toEmail, String donorName, String campaignName, BigDecimal amount) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Xác nhận quyên góp thành công - CharityDonation");
        message.setText("Xin chào " + donorName + ",\n\n" +
                "Chúng tôi vui mừng thông báo rằng khoản quyên góp " + formatCurrency(amount) + " của bạn cho chiến dịch \"" + campaignName + "\" đã được xác minh thành công.\n" +
                "Số tiền này đã được chuyển vào quỹ của chiến dịch.\n\n" +
                "Một lần nữa, chân thành cảm ơn tấm lòng hảo tâm của bạn.\n\n" +
                "Trân trọng,\n" +
                "Đội ngũ CharityDonation");
        mailSender.send(message);
    }

    @Override
    public void sendDonationRejectionEmail(String toEmail, String donorName, String campaignName, BigDecimal amount, String reason) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Thông báo về khoản quyên góp - CharityDonation");
        message.setText("Xin chào " + donorName + ",\n\n" +
                "Chúng tôi rất tiếc phải thông báo rằng khoản quyên góp " + formatCurrency(amount) + " của bạn cho chiến dịch \"" + campaignName + "\" không được chấp nhận.\n" +
                "Lý do: " + reason + "\n\n" +
                "Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi qua email hỗ trợ.\n\n" +
                "Trân trọng,\n" +
                "Đội ngũ CharityDonation");
        mailSender.send(message);
    }
}
