package org.tnphuong.charity.donation.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@Setter
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @NotBlank(message = "Họ và tên không được để trống")
    @Size(max = 100, message = "Họ và tên không được vượt quá 100 ký tự")
    @Column(name = "full_name", length = 100, nullable = false)
    private String fullName;

    @NotBlank(message = "Email không được để trống")
    @Email(message = "Địa chỉ email không hợp lệ")
    @Size(max = 100, message = "Email không được vượt quá 100 ký tự")
    @Column(name = "email", length = 100, nullable = false, unique = true)
    private String email;

    @Column(name = "password", length = 255)
    private String password;

    @NotBlank(message = "Số điện thoại không được để trống")
    @Pattern(regexp = "^((0|84)(3|5|7|8|9)[0-9]{8}|GUEST_.*)$", message = "Số điện thoại không đúng định dạng Việt Nam")
    @Column(name = "phone_number", length = 20, unique = true)
    private String phoneNumber;

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "avatar_url", length = 500)
    private String avatarUrl;

    @Column(name = "auth_provider", length = 20)
    private String authProvider = "LOCAL"; // "LOCAL", "GOOGLE"

    @Column(name = "provider_id", length = 100)
    private String providerId;

    @ManyToOne
    @JoinColumn(name = "role_id", nullable = false)
    private Role role;

    @Column(name = "status")
    private Integer status = 1;

    public UserStatus getStatusEnum() {
        return UserStatus.fromInt(this.status);
    }

    public void setStatusEnum(UserStatus status) {
        this.status = (status != null) ? status.getValue() : 1;
    }

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "last_login")
    private LocalDateTime lastLogin;
}
