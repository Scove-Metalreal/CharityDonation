package org.tnphuong.charity.donation.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UserDTO {
    private Integer id;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String address;
    private String avatarUrl;
    private String authProvider;
    private String roleName;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime lastLogin;
}
