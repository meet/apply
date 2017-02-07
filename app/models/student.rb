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
    "Amakim Tavor",
    "Baptist High School",
    "Beit Hinuch",
    "Boyer",
    "Branco Vaies",
    "Carmel Zvulun",
    "Christ Church episcopal school",
    "Dar El Tefl el arabi",
    "Dror",
    "Franciscan Sisters school",
    "Frere high school/ Beit Hanina",
    "Frere high school/ Bethlehem",
    "Frere high school/ New Gate",
    "Friends school/ Ramallah",
    "Gymnasia",
    "Ha-Masorati",
    "Haemek Hamaravi Yifat",
    "Hanissui",
    "Hartman boys",
    "Hartman girls",
    "Havat Hanoar",
    "HaYovel",
    "Ibn khaldon Boys School",
    "Ibrahimieh College",
    "Jerusalem School",
    "Kadori",
    "Keshet",
    "Leyada",
    "Maften Migdal HaEmek",
    "Masar",
    "Mekif Gilo",
    "Mgido",
    "Misgav high school",
    "Motran-St. George school for Boys",
    "Motran-St. Joseph seminary - Nazareth",
    "Ort Alon- Afula",
    "Ort Givat Ram",
    "Ort Kiryat Tivon",
    "Ort Mekif Rogozin",
    "Ort Minkuf",
    "Ort Moshe Sharet",
    "Ort Oren- Afula",
    "Ort Yigal alon",
    "Pelech",
    "Pisgat Zeav",
    "Ras al-amoud- for girls",
    "Rene Kasen",
    "Reot",
    "Rosary girls school",
    "Salesian Sister School - Nazareth",
    "Salvatorian Sisters School",
    "Scientific Technological School (Beit Hanina)",
    "Schmidt for girls",
    "Seligsberg",
    "Shufat boys school",
    "Shufat girls School",
    "Sisters of St. Joseph - Nazareth",
    "St. Joseph for girls /Old City",
    "St.Joseph/ Bethlehem",
    "Talitha Kumi/ Bet Jala",
    "Tehila",
    "Terra Sancta/ Old City",
    "Terra Santa for boys/ Bethlehem",
    "Terra Santa School - Nazareth",
    "Vitzo Nahalal",
    "vizo nir haamakim",
    "Yearat HaEmek",
    "Ziv"
  ]
  
  validates_presence_of :_parent_full_name
  validates_format_of :_parent_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_acceptance_of :_permission_to_apply, :accept => true
  
end
