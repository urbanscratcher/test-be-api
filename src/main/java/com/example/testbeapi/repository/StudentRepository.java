package com.example.testbeapi.repository;

import com.example.testbeapi.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    
    Optional<Student> findByEmail(String email);
    
    Optional<Student> findByStudentNumber(String studentNumber);
    
    boolean existsByEmail(String email);
    
    boolean existsByStudentNumber(String studentNumber);
}

