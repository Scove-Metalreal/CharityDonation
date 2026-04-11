package org.tnphuong.charity.donation.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "campaigns")
@Data
public class Campaign {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @NotBlank(message = "Mã chiến dịch không được để trống")
    @Size(max = 50, message = "Mã chiến dịch không được vượt quá 50 ký tự")
    @Column(name = "code", length = 50, nullable = false, unique = true)
    private String code;

    @NotBlank(message = "Tên chiến dịch không được để trống")
    @Size(max = 255, message = "Tên chiến dịch không được vượt quá 255 ký tự")
    @Column(name = "name", length = 255, nullable = false)
    private String name;

    @Column(name = "background", columnDefinition = "TEXT")
    private String background;

    @Column(name = "content", columnDefinition = "TEXT")
    private String content;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "image_description", length = 255)
    private String imageDescription;

    @Column(name = "gallery_urls", columnDefinition = "TEXT")
    private String galleryUrls;

    @NotNull(message = "Vui lòng chọn ngày bắt đầu")
    @Column(name = "start_date", nullable = false)
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate startDate;

    @NotNull(message = "Vui lòng chọn ngày kết thúc")
    @Column(name = "end_date", nullable = false)
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate endDate;

    @NotNull(message = "Mục tiêu quyên góp không được để trống")
    @Min(value = 1000000, message = "Mục tiêu tối thiểu là 1,000,000 VNĐ")
    @Column(name = "target_money", precision = 15, scale = 2)
    private BigDecimal targetMoney = BigDecimal.ZERO;

    @Column(name = "current_money", precision = 15, scale = 2)
    @Min(value = 0, message = "Số tiền hiện tại không được âm")
    private BigDecimal currentMoney = BigDecimal.ZERO;

    @Column(name = "beneficiary_phone", length = 20)
    private String beneficiaryPhone;

    @Column(name = "status")
    private Integer status = CampaignStatus.NEW.getValue();

    public CampaignStatus getStatusEnum() {
        return CampaignStatus.fromInt(this.status);
    }

    public void setStatusEnum(CampaignStatus status) {
        this.status = (status != null) ? status.getValue() : CampaignStatus.NEW.getValue();
    }

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @ManyToMany
    @JoinTable(
        name = "campaign_companions",
        joinColumns = @JoinColumn(name = "campaign_id"),
        inverseJoinColumns = @JoinColumn(name = "companion_id")
    )
    private List<Companion> companions;

    @AssertTrue(message = "Ngày kết thúc phải sau hoặc cùng ngày bắt đầu")
    public boolean isEndDateAfterStartDate() {
        if (startDate == null || endDate == null) {
            return true; 
        }
        return !endDate.isBefore(startDate);
    }
}
