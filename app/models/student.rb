# Student applications.
class Student < ActiveRecord::Base
  
  include Application
  
  validates_presence_of :_student_first_name, :_student_last_name, :_student_id_number
  validates_inclusion_of :_student_gender, :in => [ 'Male', 'Female' ]
  validates_length_of :_student_id_number, :is => 9
  validates_uniqueness_of :_student_id_number
  validates_numericality_of :_student_id_number
  validates_format_of :_student_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_presence_of :_student_city, :suggest => [
    'Jerusalem',
    'Bet Shemesh',
    'Bethlehem',
    'Mevasseret',
    'Ramallah',
    'Nazareth',
    'Nazareth Illit'
  ]
  
  validates_presence_of :_student_school, :suggest => [
    "Academia",
    "Al-mutran - St. George",
    "Al-tour for Girls",
    "Arab Evangelical Episcopal School",
    "Bet Hinuch",
    "Boyer",
    "Branco Weiss",
    "Christ Church Episcopal School",
    "Dror",
    "Ein Harod",
    "Franciscan Sisters School",
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
    "Jerusalem School",
    "Keshet",
    "Leyada",
    "Mar Metry",
    "Masar",
    "Massorati",
    "Megido",
    "Mekif Gilo",
    "Misgav",
    "Mizra",
    "Nazareth Baptist School",
    "Ort",
    "Ort Kiryat Tivon",
    "Ort Yigdal Allon",
    "Ort Moshe Sharet",
    "Pisgat Zeev",
    "Ras Al-amoud for Girls",
    "Renaissance",
    "Rene Cassin",
    "Reot",
    "Rosary",
    "Salesian Sisters School",
    "Salvatorian Sisters School",
    "Schmidt",
    "Seligsberg",
    "Shufat for Girls",
    "Sisters of St. Joseph School",
    "St. Joseph - Bethlehem",
    "St. Joseph - Jerusalem",
    "St. Joseph Seminary School",
    "Talith Kumi",
    "Tawfiq Ziyad School",
    "Tehila",
    "Terra Sancta - Bethlehem",
    "Terra Sancta - Jerusalem",
    "Terra Sancta - Nazareth",
    "Wizo Nahalal",
    "Wizo Nir Haemek",
    "Ziv"
  ]
  
  validates_presence_of :_parent_full_name
  validates_format_of :_parent_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_acceptance_of :_permission_to_apply, :accept => true
  
end
