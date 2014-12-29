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
    "Al Tour Girls School",
    "Beit Hinuch",
    "Boyer",
    "Branco Vaies",
    "Dar El Tefl el arabi",
    "Dror",
    "Frere high school/ Beit hanena",
    "Frere high school/ Bethlehem",
    "Frere high school/ New Gate",
    "Friends school/ Ramallah",
    "Gymnasia",
    "Ha-Masorati",
    "Hanissui",
    "Hartman boys",
    "Hartman girls",
    "Havat Hanoar",
    "Hayovel",
    "Ibn khaldon Boys School",
    "Ibrahimieh College",
    "Jerusalem School",
    "Keshet",
    "Leyada",
    "Mekif Gilo",
    "Motran-St. George school for Boys",
    "Ort Givat Ram",
    "Ort Minkuf",
    "Pelech",
    "Pisgat Zeav",
    "Ras al-amoud- for girls",
    "Rene Kasen",
    "Reot",
    "Rosary girls school",
    "Schmidt for girls",
    "Seligsberg",
    "Shufat boys school",
    "Shufat girls School",
    "St. Joseph for girls /Old City",
    "St.Joseph/ Bethlehem",
    "Talitha Kumi/ Bet Jala",
    "Tehila",
    "Terra Sancta/ Old City",
    "Terra Santa for boys/ Bethlehem",
    "Ziv"
  ]
  
  validates_presence_of :_parent_full_name
  validates_format_of :_parent_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_acceptance_of :_permission_to_apply, :accept => true
  
end
