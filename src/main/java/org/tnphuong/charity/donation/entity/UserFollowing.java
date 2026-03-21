package org.tnphuong.charity.donation.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_following")
@Data
public class UserFollowing {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "campaign_id")
    private Campaign campaign;

    @Column(name = "receive_email")
    private Integer receiveEmail = 0; // 1: Yes, 0: No

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
}
