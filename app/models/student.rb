# Student applications.
class Student < ActiveRecord::Base
  
  include Application
  
  validates_presence_of :_student_first_name, :_student_last_name, :_student_id_number
  validates_inclusion_of :_student_gender, :in => [ 'Male', 'Female' ]
  validates_length_of :_student_id_number, :is => 9
  validates_uniqueness_of :_student_id_number
  validates_numericality_of :_student_id_number
  validates_format_of :_student_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_inclusion_of :_student_city, :in => [
    'Jerusalem', 'Bet Shemesh', 'Bethlehem', 'Mevasseret', 'Ramallah', '-Other-'
  ]
  
  validates_inclusion_of :_student_school, :in => [
    "Academia",
    "Al-mutran - St. George",
    "Al-tour for Girls",
    "Arab Evangelical Episcopal School",
    "Bet Hinuch",
    "Boyer",
    "Branco Weiss",
    "Dror",
    "Frere - Bethlehem",
    "Frere - Jerusalem",
    "Friends School",
    "Givat Gonen",
    "Gymnasia",
    "Hanissoye",
    "Haomaneyot",
    "Hartman",
    "Havat Hanoar",
    "Hayovel",
    "Iben Khaldun",
    "Keshet",
    "Leyada",
    "Mar Metry",
    "Massorati",
    "Mekif Gilo",
    "Ort",
    "Pisgat Zeev",
    "Renaissance",
    "Rene Cassin",
    "Reot", 
    "Rosary",
    "Schmidt",
    "Seligsberg",
    "Shufat for Girls",
    "Silwan",
    "St. Joseph - Bethlehem",
    "St. Joseph - Jerusalem",
    "Talith Kumi",
    "Tehila",
    "Terra Sancta - Bethlehem",
    "Terra Sancta - Jerusalem",
    "Ziv",
    "-Other-"
  ]
  
  validates_presence_of :_parent_full_name
  validates_format_of :_parent_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_acceptance_of :_permission_to_apply, :accept => true
  
end
