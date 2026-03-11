package org.tnphuong.charity.donation.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "payment_methods")
@Getter
@Setter
public class PaymentMethod {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "method_name", length = 100, nullable = false)
    private String methodName;

    @Column(name = "provider", length = 100)
    private String provider;

    @Column(name = "account_number", length = 100)
    private String accountNumber;

    @Column(name = "logo_url", length = 500)
    private String logoUrl;

    @Column(name = "is_active")
    private Integer isActive = 1;
}
