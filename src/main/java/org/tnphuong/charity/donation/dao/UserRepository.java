package org.tnphuong.charity.donation.dao;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.tnphuong.charity.donation.entity.User;
import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {
    Optional<User> findByEmail(String email);
    Optional<User> findByPhoneNumber(String phoneNumber);
    
    @Query("SELECT u FROM User u WHERE u.fullName LIKE %:keyword% OR u.email LIKE %:keyword% OR u.phoneNumber LIKE %:keyword%")
    List<User> searchUsers(String keyword);

    @Query("SELECT u FROM User u WHERE " +
           "(:keyword IS NULL OR u.fullName LIKE %:keyword% OR u.email LIKE %:keyword% OR u.phoneNumber LIKE %:keyword%) AND " +
           "(:roleId IS NULL OR u.role.id = :roleId) AND " +
           "(:status IS NULL OR u.status = :status) AND " +
           "(:inactiveSince IS NULL OR u.lastLogin IS NULL OR u.lastLogin < :inactiveSince)")
    Page<User> searchUsers(@Param("keyword") String keyword, 
                          @Param("roleId") Integer roleId, 
                          @Param("status") Integer status, 
                          @Param("inactiveSince") java.time.LocalDateTime inactiveSince,
                          Pageable pageable);
    @Query("SELECT r.roleName, COUNT(u) FROM User u JOIN u.role r GROUP BY r.roleName")
    List<Object[]> countUsersByRole();
}
