package org.tnphuong.charity.donation.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.List;

@Entity
@Table(name = "companions")
@Getter
@Setter
public class Companion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "name", length = 255, nullable = false)
    private String name;

    @Column(name = "logo_url", length = 500)
    private String logoUrl;

    @Column(name = "description", length = 500)
    private String description;

    @Column(name = "is_active")
    private Integer isActive = 1;

    @ManyToMany(mappedBy = "companions")
    private List<Campaign> campaigns;
}
