package org.tnphuong.charity.donation.entity;

import jakarta.persistence.*;
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

    // Status constants
    public static final int STATUS_NEW = 0;
    public static final int STATUS_IN_PROGRESS = 1;
    public static final int STATUS_ENDED = 2;
    public static final int STATUS_CLOSED = 3;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "code", length = 50, nullable = false, unique = true)
    private String code;

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

    @Column(name = "start_date", nullable = false)
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate startDate;

    @Column(name = "end_date", nullable = false)
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate endDate;

    @Column(name = "target_money", precision = 15, scale = 2)
    private BigDecimal targetMoney = BigDecimal.ZERO;

    @Column(name = "current_money", precision = 15, scale = 2)
    private BigDecimal currentMoney = BigDecimal.ZERO;

    @Column(name = "beneficiary_phone", length = 20)
    private String beneficiaryPhone;

    @Column(name = "status")
    private Integer status = 0;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @ManyToMany
    @JoinTable(
        name = "campaign_companions",
        joinColumns = @JoinColumn(name = "campaign_id"),
        inverseJoinColumns = @JoinColumn(name = "companion_id")
    )
    private List<Companion> companions;
}
