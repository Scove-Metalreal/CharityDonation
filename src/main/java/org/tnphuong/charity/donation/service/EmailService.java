package org.tnphuong.charity.donation.service;

public interface EmailService {
    void sendDonationSubmissionEmail(String toEmail, String donorName, String campaignName, java.math.BigDecimal amount, String transactionCode);
    void sendDonationApprovalEmail(String toEmail, String donorName, String campaignName, java.math.BigDecimal amount);
    void sendDonationRejectionEmail(String toEmail, String donorName, String campaignName, java.math.BigDecimal amount, String reason);
}
