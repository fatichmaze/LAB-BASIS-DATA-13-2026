-- NO. 5
CREATE TABLE anggota (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_anggota VARCHAR (50) NOT NULL,
    kota_domisili VARCHAR (20) NOT NULL
);

CREATE TABLE buku (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    judul_buku VARCHAR (100) NOT NULL,
    genre VARCHAR (20) NOT NULL,
    stok INT DEFAULT 0
);
SELECT * FROM buku;

CREATE TABLE peminjaman (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_anggota INT,
    CONSTRAINT fk_peminjaman_anggota
        FOREIGN KEY (id_anggota)
        REFERENCES anggota(id),
    tanggal_pinjam DATE NOT NULL,
    tanggal_kembali DATE DEFAULT NULL,
    denda INT DEFAULT 0
);
SELECT * FROM peminjaman;

-- Membuat index pada kolom genre
CREATE INDEX index_buku_genre
ON buku(genre);

-- Membuat index pada kolom kota_domisili
CREATE INDEX index_anggota_kota
ON anggota(kota_domisili);

