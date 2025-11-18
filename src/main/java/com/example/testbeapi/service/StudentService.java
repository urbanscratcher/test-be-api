package com.example.testbeapi.service;

import com.example.testbeapi.entity.Student;
import com.example.testbeapi.repository.StudentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class StudentService {

    private final StudentRepository studentRepository;

    public List<Student> getAllStudents() {
        return studentRepository.findAll();
    }

    public Optional<Student> getStudentById(Long id) {
        return studentRepository.findById(id);
    }

    public Student createStudent(Student student) {
        if (student.getEmail() != null && studentRepository.existsByEmail(student.getEmail())) {
            throw new IllegalArgumentException("이미 존재하는 이메일입니다: " + student.getEmail());
        }
        if (student.getStudentNumber() != null && studentRepository.existsByStudentNumber(student.getStudentNumber())) {
            throw new IllegalArgumentException("이미 존재하는 학번입니다: " + student.getStudentNumber());
        }
        return studentRepository.save(student);
    }

    public Student updateStudent(Long id, Student studentDetails) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("학생을 찾을 수 없습니다. ID: " + id));

        if (studentDetails.getEmail() != null && !studentDetails.getEmail().equals(student.getEmail())) {
            if (studentRepository.existsByEmail(studentDetails.getEmail())) {
                throw new IllegalArgumentException("이미 존재하는 이메일입니다: " + studentDetails.getEmail());
            }
            student.setEmail(studentDetails.getEmail());
        }

        if (studentDetails.getName() != null) {
            student.setName(studentDetails.getName());
        }
        if (studentDetails.getAge() != null) {
            student.setAge(studentDetails.getAge());
        }
        if (studentDetails.getStudentNumber() != null) {
            if (!studentDetails.getStudentNumber().equals(student.getStudentNumber()) 
                    && studentRepository.existsByStudentNumber(studentDetails.getStudentNumber())) {
                throw new IllegalArgumentException("이미 존재하는 학번입니다: " + studentDetails.getStudentNumber());
            }
            student.setStudentNumber(studentDetails.getStudentNumber());
        }

        return studentRepository.save(student);
    }

    public void deleteStudent(Long id) {
        if (!studentRepository.existsById(id)) {
            throw new IllegalArgumentException("학생을 찾을 수 없습니다. ID: " + id);
        }
        studentRepository.deleteById(id);
    }
}

