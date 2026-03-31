package org.tnphuong.charity.donation.service;

import org.tnphuong.charity.donation.entity.Role;
import java.util.List;
import java.util.Optional;

public interface RoleService {
    List<Role> getAllRoles();
    Optional<Role> getRoleById(Integer id);
}
