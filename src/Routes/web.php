<?php

use App\Core\Router;

/* Controladores */
use App\Controllers\UserController;
use App\Controllers\AttendanceController;
use App\Controllers\StudentsController;
use App\Controllers\DashboardController;


$router = new Router();


/* Ruta principal */
$router->get('/app/dashboard', [DashboardController::class, 'index'])->middleware('auth');

/* ============================================
   RUTAS DE USUARIOS
============================================ */
$user = '/users';
$ctrl_user = UserController::class;

$router->post("$user/login", [$ctrl_user, 'login']);
$router->post("$user/register", [$ctrl_user, 'register']);

$router->get("$user/all",       [$ctrl_user, 'getAll'])->middleware('auth');
$router->get("$user/profile",   [$ctrl_user, 'infomation'])->middleware('auth');
$router->put("$user/profile/update", [$ctrl_user, 'update'])->middleware('auth');
$router->delete("$user/profile/delete", [$ctrl_user, 'delete'])->middleware('auth');


/* ============================================
   RUTAS EDUCATIVAS (MODE, GROUP, TEACHER, CLASS)
============================================ */
$edu = '/edu';
$ctrl_edu = AttendanceController::class;

/* Modalidad */
$router->post("$edu/mode/insert",  [$ctrl_edu, 'insert_Mode'])->middleware('auth');
$router->get("$edu/mode/all",      [$ctrl_edu, 'get_Modes'])->middleware('auth');
$router->put("$edu/mode/update",   [$ctrl_edu, 'update_Mode'])->middleware('auth');
$router->delete("$edu/mode/delete",[$ctrl_edu, 'delete_Mode'])->middleware('auth');

/* Grupos */
$router->post("$edu/group/insert", [$ctrl_edu, 'insert_Group'])->middleware('auth');
$router->get("$edu/group/all",     [$ctrl_edu, 'get_Groups'])->middleware('auth');
$router->put("$edu/group/update",  [$ctrl_edu, 'update_Group'])->middleware('auth');
$router->delete("$edu/group/delete", [$ctrl_edu, 'delete_Group'])->middleware('auth');

/* Docentes */
$router->post("$edu/teacher/insert", [$ctrl_edu, 'insert_Teacher'])->middleware('auth');
$router->get("$edu/teacher/all",     [$ctrl_edu, 'get_Teachers'])->middleware('auth');
$router->put("$edu/teacher/update",   [$ctrl_edu, 'update_Teacher'])->middleware('auth');
$router->delete("$edu/teacher/delete",[$ctrl_edu, 'delete_Teacher'])->middleware('auth');

/* Clases */
$router->post("$edu/class/insert",  [$ctrl_edu, 'insert_Class'])->middleware('auth');
$router->get("$edu/class/all",      [$ctrl_edu, 'get_Classes'])->middleware('auth');
$router->put("$edu/class/update",   [$ctrl_edu, 'update_Class'])->middleware('auth');
$router->delete("$edu/class/delete",[$ctrl_edu, 'delete_Class'])->middleware('auth');

/* Alumnos */
$ctrl_student = StudentsController::class;

$router->post("$edu/student/insert",  [$ctrl_student, 'createStudent'])->middleware('auth');
$router->get("$edu/student/get/{id}", [$ctrl_student, 'getStudent'])->middleware('auth');
$router->get("$edu/student/all",      [$ctrl_student, 'getAllStudents'])->middleware('auth');
$router->put("$edu/student/update",   [$ctrl_student, 'updateStudent'])->middleware('auth');
$router->delete("$edu/student/delete",[$ctrl_student, 'deleteStudent'])->middleware('auth');

/* listado de clases asignadas con profesores y estudiantes de la clase + lista de asistencia */
$router->get("$edu/class/assigned", [$ctrl_edu, 'getClassesAssigned'])->middleware('auth');
$router->get("$edu/class/students/{id}", [$ctrl_student, 'getStudentsByAssignment'])->middleware('auth');
$router->post("$edu/class/attendance/insert", [$ctrl_edu, 'insert_Attendance'])->middleware('auth');
$router->post("$edu/class/attendance/list", [$ctrl_edu, 'show_Attendance'])->middleware('auth');
$router->put("$edu/class/attendance/update", [$ctrl_edu, 'update_Attendance'])->middleware('auth');


return $router;