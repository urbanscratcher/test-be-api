package com.example.testbeapi.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "students")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "이름은 필수입니다")
    @Column(nullable = false)
    private String name;

    @NotNull(message = "나이는 필수입니다")
    @Column(nullable = false)
    private Integer age;

    @Email(message = "유효한 이메일 형식이 아닙니다")
    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "student_number", unique = true)
    private String studentNumber;

    @Column(name = "nickname")
    private String nickname;

}

