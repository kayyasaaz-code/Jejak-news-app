/// Enam kategori pendidikan utama aplikasi JEJAK beserta query GNews dan template roadmap.
enum NewsCategory {
  scholarships(
    label: 'Scholarships',
    gnewsQuery: 'scholarship OR beasiswa OR fellowship',
    defaultRoadmap: [
      'Baca informasi resmi & syarat kelayakan program',
      'Siapkan dokumen akademik (Rapor/Transkrip & Ijazah)',
      'Tulis draf Motivation Letter / Personal Essay',
      'Hubungi guru/dosen untuk Surat Rekomendasi',
      'Cek tenggat waktu & submit berkas pendaftaran',
    ],
  ),
  competitions(
    label: 'Competitions',
    gnewsQuery: '"student competition" OR "academic competition" OR olympiad',
    defaultRoadmap: [
      'Unduh dan pelajari guidebook perlombaan',
      'Tentukan anggota tim atau daftar kategori individu',
      'Susun kerangka ide, proposal, atau prototipe karya',
      'Lakukan review & latihan presentasi',
      'Kumpulkan karya sebelum batas waktu submisi',
    ],
  ),
  studentExchange(
    label: 'Student Exchange',
    gnewsQuery: '"student exchange" OR "summer school"',
    defaultRoadmap: [
      'Periksa masa berlaku paspor & dokumen identitas',
      'Siapkan sertifikat kemampuan bahasa Inggris',
      'Tulis esai kontribusi & tujuan pertukaran pelajar',
      'Riset biaya hidup, akomodasi, atau skema pendanaan',
      'Lengkapi formulir aplikasi & persiapan wawancara',
    ],
  ),
  universityAdmission(
    label: 'University Admission',
    gnewsQuery: '"university admission" OR "university application"',
    defaultRoadmap: [
      'Riset kurikulum jurusan dan persyaratan kampus tujuan',
      'Tentukan jalur pendaftaran yang paling sesuai',
      'Kumpulkan dokumen nilai rapor, portofolio, atau sertifikat',
      'Buat jadwal belajar untuk tes seleksi masuk',
      'Finalisasi pendaftaran & pantau jadwal pengumuman',
    ],
  ),
  testPreparation(
    label: 'Language & Test Prep',
    gnewsQuery: 'IELTS OR TOEFL OR SAT OR EJU',
    defaultRoadmap: [
      'Kerjakan simulasi/diagnostic test untuk ukur skor awal',
      'Tentukan target skor minimal sesuai tujuan studi',
      'Buat jadwal latihan rutin per bagian (Reading/Listening/dll)',
      'Evaluasi hasil latihan mingguan & perbaiki kelemahan',
      'Daftar jadwal tes resmi di pusat ujian terdekat',
    ],
  ),
  learningPrograms(
    label: 'Learning Programs',
    gnewsQuery: '"coding bootcamp" OR "education program"',
    defaultRoadmap: [
      'Pelajari silabus materi dan jadwal pelaksanaan program',
      'Siapkan perangkat dan instalasi tools yang dibutuhkan',
      'Selesaikan tugas seleksi atau pre-work (jika ada)',
      'Ikuti sesi pembelajaran & catat poin penting',
      'Bangun proyek akhir sebagai bukti portofolio',
    ],
  );

  const NewsCategory({
    required this.label,
    required this.gnewsQuery,
    required this.defaultRoadmap,
  });

  /// Label yang ditampilkan di UI.
  final String label;

  /// Keyword yang dikirim ke parameter `q` GNews API.
  final String gnewsQuery;

  /// Template langkah awal untuk fitur Rencanaku.
  final List<String> defaultRoadmap;

  /// Nilai identifier kategori.
  String get apiValue => name;
}
