package org.tnphuong.charity.donation.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
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

    @NotBlank(message = "Tên đối tác không được để trống")
    @Size(max = 255, message = "Tên đối tác không được vượt quá 255 ký tự")
    @Column(name = "name", length = 255, nullable = false)
    private String name;

    @Size(max = 500, message = "Link logo không được vượt quá 500 ký tự")
    @Column(name = "logo_url", length = 500)
    private String logoUrl;

    @Size(max = 500, message = "Mô tả không được vượt quá 500 ký tự")
    @Column(name = "description", length = 500)
    private String description;

    @Column(name = "is_active")
    private Integer isActive = 1;

    @ManyToMany(mappedBy = "companions")
    private List<Campaign> campaigns;
}
