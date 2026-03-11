package org.tnphuong.charity.donation.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.tnphuong.charity.donation.entity.Role;
import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Integer> {
    Optional<Role> findByRoleName(String roleName);
}
