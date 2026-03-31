package org.tnphuong.charity.donation.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class CampaignDTO {
    private Integer id;
    private String code;
    private String name;
    private String background;
    private String content;
    private String imageUrl;
    private String galleryUrls;
    private LocalDate startDate;
    private LocalDate endDate;
    private BigDecimal targetMoney;
    private BigDecimal currentMoney;
    private String beneficiaryPhone;
    private Integer status;
    private LocalDateTime createdAt;
    private Integer donationCount;
    private Long daysRemaining;
    private List<CompanionDTO> companions;
}
