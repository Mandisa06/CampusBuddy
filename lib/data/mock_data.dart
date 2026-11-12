import 'package:flutter/material.dart';
import '../models/models.dart';

const kProvinces = [
  'Eastern Cape', 'Free State', 'Gauteng', 'KwaZulu-Natal', 'Limpopo',
  'Mpumalanga', 'North West', 'Northern Cape', 'Western Cape',
];
const kUniversities = [
  'Walter Sisulu University', 'University of KwaZulu-Natal', 'University of Johannesburg',
  'University of the Witwatersrand', 'University of Pretoria', 'University of Mpumalanga',
  'Tshwane University of Technology', 'Durban University of Technology',
];
const kDates = ['15 Jan', '16 Jan', '17 Jan', '18 Jan'];
const kInterests = ['Football', 'Coding', 'Gospel', 'Gaming', 'Music', 'Fitness', 'Art', 'Debating'];

const _wsu = 'Walter Sisulu University';

/// Sample students. Replace with Firestore data later (see README).
List<Student> mockStudents() => const [
      Student(id: 's1', name: 'Sipho Mokoena', province: 'Mpumalanga', town: 'Mbombela', university: _wsu, course: 'BCom Accounting', interests: ['Football', 'Coding'], travelDate: '17 Jan', verified: true, lat: -25.4658, lng: 30.9853, color: Color(0xFF4338CA)),
      Student(id: 's2', name: 'Lerato Khumalo', province: 'Mpumalanga', town: 'eMalahleni', university: _wsu, course: 'Information Technology', interests: ['Coding', 'Music'], travelDate: '17 Jan', verified: true, lat: -25.8771, lng: 29.2332, color: Color(0xFFDB2777)),
      Student(id: 's3', name: 'Ayanda Nkosi', province: 'Mpumalanga', town: 'Secunda', university: _wsu, course: 'Nursing', interests: ['Gospel', 'Fitness'], travelDate: '18 Jan', verified: false, lat: -26.5, lng: 29.17, color: Color(0xFF0F766E)),
      Student(id: 's4', name: 'Thabo Dlamini', province: 'Mpumalanga', town: 'Mbombela', university: _wsu, course: 'Engineering', interests: ['Gaming', 'Football'], travelDate: '17 Jan', verified: true, lat: -25.47, lng: 30.97, color: Color(0xFFB45309)),
      Student(id: 's5', name: 'Naledi Sithole', province: 'Gauteng', town: 'Soweto', university: _wsu, course: 'Information Technology', interests: ['Coding', 'Art'], travelDate: '17 Jan', verified: true, lat: -26.2485, lng: 27.854, color: Color(0xFF7B4FB3)),
      Student(id: 's6', name: 'Musa Zulu', province: 'KwaZulu-Natal', town: 'Durban', university: _wsu, course: 'BCom Accounting', interests: ['Debating', 'Music'], travelDate: '16 Jan', verified: false, lat: -29.8587, lng: 31.0218, color: Color(0xFF2563EB)),
      Student(id: 's7', name: 'Zanele Mthembu', province: 'Mpumalanga', town: 'Mbombela', university: 'University of Mpumalanga', course: 'Agriculture', interests: ['Art'], travelDate: '17 Jan', verified: true, lat: -25.46, lng: 30.98, color: Color(0xFFBE123C)),
    ];

const kBuses = [
  BusOption('Sample coach A', '17:30', '07:10', 'R450', 'Best for groups'),
  BusOption('Sample coach B', '19:00', '09:00', 'R520'),
  BusOption('Sample coach C', '20:15', '10:30', 'R480'),
];
