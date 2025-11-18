package com.example.testbeapi.controller;

import com.example.testbeapi.entity.Student;
import com.example.testbeapi.service.StudentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/students")
@RequiredArgsConstructor
@Tag(name = "Student", description = "학생 관리 API")
public class StudentController {

    private final StudentService studentService;

    @GetMapping
    @Operation(summary = "모든 학생 조회", description = "등록된 모든 학생 목록을 조회합니다")
    @ApiResponse(responseCode = "200", description = "조회 성공", 
                 content = @Content(schema = @Schema(implementation = Student.class)))
    public ResponseEntity<List<Student>> getAllStudents() {
        List<Student> students = studentService.getAllStudents();
        return ResponseEntity.ok(students);
    }

    @GetMapping("/{id}")
    @Operation(summary = "학생 조회", description = "ID로 특정 학생을 조회합니다")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "조회 성공",
                     content = @Content(schema = @Schema(implementation = Student.class))),
        @ApiResponse(responseCode = "404", description = "학생을 찾을 수 없음")
    })
    public ResponseEntity<Student> getStudentById(
            @Parameter(description = "학생 ID", required = true) @PathVariable Long id) {
        return studentService.getStudentById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @Operation(summary = "학생 생성", description = "새로운 학생을 등록합니다")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "생성 성공",
                     content = @Content(schema = @Schema(implementation = Student.class))),
        @ApiResponse(responseCode = "400", description = "잘못된 요청")
    })
    public ResponseEntity<Student> createStudent(
            @Parameter(description = "학생 정보", required = true) 
            @Valid @RequestBody Student student) {
        try {
            Student createdStudent = studentService.createStudent(student);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdStudent);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PutMapping("/{id}")
    @Operation(summary = "학생 수정", description = "기존 학생 정보를 수정합니다")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "수정 성공",
                     content = @Content(schema = @Schema(implementation = Student.class))),
        @ApiResponse(responseCode = "400", description = "잘못된 요청"),
        @ApiResponse(responseCode = "404", description = "학생을 찾을 수 없음")
    })
    public ResponseEntity<Student> updateStudent(
            @Parameter(description = "학생 ID", required = true) @PathVariable Long id,
            @Parameter(description = "수정할 학생 정보", required = true) 
            @Valid @RequestBody Student studentDetails) {
        try {
            Student updatedStudent = studentService.updateStudent(id, studentDetails);
            return ResponseEntity.ok(updatedStudent);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "학생 삭제", description = "ID로 학생을 삭제합니다")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "삭제 성공"),
        @ApiResponse(responseCode = "404", description = "학생을 찾을 수 없음")
    })
    public ResponseEntity<Void> deleteStudent(
            @Parameter(description = "학생 ID", required = true) @PathVariable Long id) {
        try {
            studentService.deleteStudent(id);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }
}

