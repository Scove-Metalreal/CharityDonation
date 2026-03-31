package org.tnphuong.charity.donation.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class DonationDTO {
    private Integer id;
    private Integer userId;
    private String donorName;
    private Integer campaignId;
    private String campaignName;
    private String paymentMethodName;
    private BigDecimal amount;
    private String message;
    private Integer isAnonymous;
    private Integer status;
    private LocalDateTime createdAt;
}
