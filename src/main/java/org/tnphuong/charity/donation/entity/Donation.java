package org.tnphuong.charity.donation.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "donations")
@Data
public class Donation {

    public static final int STATUS_PENDING = 0;
    public static final int STATUS_CONFIRMED = 1;
    public static final int STATUS_REJECTED = 2;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    @NotNull(message = "Người dùng không được để trống")
    private User user;

    @ManyToOne
    @JoinColumn(name = "campaign_id", nullable = false)
    @NotNull(message = "Chiến dịch không được để trống")
    private Campaign campaign;

    @ManyToOne
    @JoinColumn(name = "payment_method_id", nullable = false)
    @NotNull(message = "Phương thức thanh toán không được để trống")
    private PaymentMethod paymentMethod;

    @Column(name = "amount", precision = 15, scale = 2, nullable = false)
    @NotNull(message = "Số tiền quyên góp không được để trống")
    @DecimalMin(value = "1000", message = "Số tiền quyên góp tối thiểu là 1,000 VNĐ")
    private BigDecimal amount;

    @Column(name = "message", length = 500)
    @Size(max = 500, message = "Lời nhắn không được vượt quá 500 ký tự")
    private String message;

    @Column(name = "is_anonymous")
    private Integer isAnonymous = 0;

    @Column(name = "status")
    private Integer status = 0;

    public DonationStatus getStatusEnum() {
        return DonationStatus.fromInt(this.status);
    }

    public void setStatusEnum(DonationStatus status) {
        this.status = (status != null) ? status.getValue() : 0;
    }

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
}
