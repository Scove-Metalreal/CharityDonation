package org.tnphuong.charity.donation.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
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

    @NotBlank(message = "Tên phương thức không được để trống")
    @Size(max = 100, message = "Tên phương thức không được vượt quá 100 ký tự")
    @Column(name = "method_name", length = 100, nullable = false)
    private String methodName;

    @Size(max = 100, message = "Nhà cung cấp không được vượt quá 100 ký tự")
    @Column(name = "provider", length = 100)
    private String provider;

    @Size(max = 100, message = "Số tài khoản không được vượt quá 100 ký tự")
    @Column(name = "account_number", length = 100)
    private String accountNumber;

    @Size(max = 500, message = "Link logo không được vượt quá 500 ký tự")
    @Column(name = "logo_url", length = 500)
    private String logoUrl;

    @Column(name = "is_active")
    private Integer isActive = 1;
}
