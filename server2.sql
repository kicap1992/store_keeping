-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 30, 2022 at 09:48 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 7.4.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `penjualan_ilham_online`
--

-- --------------------------------------------------------

--
-- Table structure for table `tb_barang`
--

CREATE TABLE `tb_barang` (
  `no_barang` int(4) NOT NULL,
  `kode_barang` varchar(6) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `harga_jual` varchar(10) NOT NULL,
  `jumlah` int(4) NOT NULL,
  `foto` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_barang`
--

INSERT INTO `tb_barang` (`no_barang`, `kode_barang`, `nama`, `harga_jual`, `jumlah`, `foto`) VALUES
(1, '123asd', 'asda', '123,123', 1497, 'brothers.jpg'),
(2, '435sdf', 'asdasd', '345,345', 3453, '79f509f5451cf0e66e0fa92bcf45a79ee95793b4_hq.jpg'),
(3, '456dfg', 'sdfgsdf', '345,546', 4570, '6564e6d48892e6ba325bda1ec27189c9b4b3b473_hq.jpg'),
(4, '454sfd', 'dsfsdf', '546,546', 456, 'Vorpal Sword.jpg'),
(5, 'sdfds3', '23423asdasd', '234,234', 2357, '11073968_844405842264361_5190470711960847490_n.jpg'),
(6, 'dfgh42', 'dfgfdg', '342,342', 234, '1-brjYnVlXwM3j_SWXImT0Rg.png'),
(7, 'dfg345', 'sdfsdf', '345,345', 4353, 'pemotong padi 1.jpg'),
(8, 'sdf234', '234sdfsdf', '234,234', 2342, '11073968_844405842264361_5190470711960847490_n.jpg'),
(9, 'fh4534', '34534', '345,345', 3453, '11073968_844405842264361_5190470711960847490_n.jpg'),
(10, 'fgds23', 'ef3234', '242,342', 2342, '11073968_844405842264361_5190470711960847490_n.jpg'),
(11, 'sd2342', 'sdfsdf', '234,234', 2342, 'asdasd.jpg'),
(12, '134ash', 'asdasd', '345,453', 3427, '27661905_1607403089353960_2137003018_n.jpg'),
(13, 'fgh654', '546', '456,456', 4564, '11073968_844405842264361_5190470711960847490_n.jpg'),
(14, 'asd565', 'fdsfsdf', '345,234', 2318, '11073968_844405842264361_5190470711960847490_n.jpg'),
(15, 'hf3454', '324234', '234,234', 2343, '79f509f5451cf0e66e0fa92bcf45a79ee95793b4_hq.jpg'),
(16, 'gfh456', 'dfgdfg', '50,000', 218, 'wp1987433-gin-ichimaru-wallpapers.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `tb_login`
--

CREATE TABLE `tb_login` (
  `no_login` int(2) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(150) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `level` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_login`
--

INSERT INTO `tb_login` (`no_login`, `username`, `password`, `nama`, `level`) VALUES
(2, 'admin', 'e739279cb28cdafd7373618313803524', 'Admin', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tb_log_history`
--

CREATE TABLE `tb_log_history` (
  `no_log` int(6) NOT NULL,
  `no_barang` int(4) DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `ket` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`ket`)),
  `waktu` datetime NOT NULL,
  `dibaca` varchar(10) NOT NULL DEFAULT 'Belum'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb_log_history`
--

INSERT INTO `tb_log_history` (`no_log`, `no_barang`, `status`, `ket`, `waktu`, `dibaca`) VALUES
(1, 1, 'Penambahan Produk Baru', '{\"kode_barang\":\"123asd\",\"nama\":\"asdasdsadas1123\",\"harga_jual\":\"123,123\",\"jumlah\":\"1231\",\"pembelian_stok\":\"12,312,312\",\"bertanggungjawab\":\"1\"}', '2022-01-15 19:38:17', 'Sudah'),
(2, 2, 'Penambahan Produk Baru', '{\"kode_barang\":\"435sdf\",\"nama\":\"asdasd\",\"harga_jual\":\"345,345\",\"jumlah\":\"3453\",\"pembelian_stok\":\"34,534,534\",\"bertanggungjawab\":\"1\"}', '2022-01-15 19:39:26', 'Sudah'),
(3, 3, 'Penambahan Produk Baru', '{\"kode_barang\":\"456dfg\",\"nama\":\"sdfgsdf\",\"harga_jual\":\"345,546\",\"jumlah\":\"4565\",\"pembelian_stok\":\"3,453,422\",\"bertanggungjawab\":\"1\"}', '2022-01-15 19:39:42', 'Sudah'),
(4, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"123,123\",\"total_stok\":\"1232\",\"jumlah_stok_sebelumnya\":\"1231\",\"bertanggungjawab\":\"1\"}', '2022-01-15 22:26:47', 'Sudah'),
(5, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"2\",\"harga_pembelian_stok\":\"12,313\",\"total_stok\":\"1234\",\"jumlah_stok_sebelumnya\":\"1232\"}', '2022-01-15 22:27:27', 'Sudah'),
(6, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"4\",\"harga_pembelian_stok\":\"123,123\",\"total_stok\":\"1238\",\"jumlah_stok_sebelumnya\":\"1234\"}', '2022-01-15 22:29:55', 'Sudah'),
(7, 4, 'Penambahan Produk Baru', '{\"kode_barang\":\"454sfd\",\"nama\":\"dsfsdf\",\"harga_jual\":\"546,546\",\"jumlah\":\"456\",\"pembelian_stok\":\"45,654,645\",\"bertanggungjawab\":\"1\"}', '2022-01-15 22:38:28', 'Sudah'),
(8, 3, 'Penambahan Stok', '{\"penambahan_stok\":\"3\",\"harga_pembelian_stok\":\"213,123\",\"total_stok\":\"4568\",\"jumlah_stok_sebelumnya\":\"4565\",\"bertanggungjawab\":\"1\"}', '2022-01-15 22:39:49', 'Sudah'),
(9, 3, 'Penambahan Stok', '{\"penambahan_stok\":\"4\",\"harga_pembelian_stok\":\"1,231,231\",\"total_stok\":\"4572\",\"jumlah_stok_sebelumnya\":\"4568\",\"bertanggungjawab\":\"1\"}', '2022-01-15 22:40:32', 'Sudah'),
(10, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"2\",\"harga_pembelian_stok\":\"1,231,232\",\"total_stok\":\"1240\",\"jumlah_stok_sebelumnya\":\"1238\",\"bertanggungjawab\":\"1\"}', '2022-01-15 22:55:28', 'Sudah'),
(11, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas1123\",\"nama_baru\":\"asdasdsadas11231\",\"harga_lama\":\"123,123\",\"harga_baru\":\"1,231,231\",\"foto_lama\":\"1111..jpg\",\"foto_baru\":\"asdasd.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-16 00:42:35', 'Sudah'),
(12, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas11231\",\"nama_baru\":\"asdasdsadas1123\",\"harga_lama\":\"1,231,231\",\"harga_baru\":\"123,123\",\"foto_lama\":\"asdasd.jpg\",\"foto_baru\":\"kembar.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-16 00:44:14', 'Sudah'),
(13, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas1123\",\"nama_baru\":\"asdasdsadas11231\",\"harga_lama\":\"123,123\",\"harga_baru\":\"1,231,231\",\"foto_lama\":\"kembar.jpg\",\"foto_baru\":\"keluargaku.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-16 00:44:34', 'Sudah'),
(14, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas11231\",\"nama_baru\":\"asdasdsadas11231\",\"harga_lama\":\"1,231,231\",\"harga_baru\":\"1,231,231\",\"foto_lama\":\"keluargaku.jpg\",\"foto_baru\":\"kembar.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-16 01:34:58', 'Sudah'),
(15, 5, 'Penambahan Produk Baru', '{\"kode_barang\":\"sdfds3\",\"nama\":\"23423asdasd\",\"harga_jual\":\"234,234\",\"jumlah\":\"2234\",\"pembelian_stok\":\"234,234,234\",\"bertanggungjawab\":\"1\"}', '2022-01-18 16:30:55', 'Sudah'),
(16, 6, 'Penambahan Produk Baru', '{\"kode_barang\":\"dfgh42\",\"nama\":\"dfgfdg\",\"harga_jual\":\"342,342\",\"jumlah\":\"234\",\"pembelian_stok\":\"2,342,342\",\"bertanggungjawab\":\"1\"}', '2022-01-18 16:35:17', 'Sudah'),
(17, 7, 'Penambahan Produk Baru', '{\"kode_barang\":\"dfg345\",\"nama\":\"sdfsdf\",\"harga_jual\":\"345,345\",\"jumlah\":\"4353\",\"pembelian_stok\":\"34,534,534\",\"bertanggungjawab\":\"1\"}', '2022-01-18 16:57:22', 'Sudah'),
(18, 8, 'Penambahan Produk Baru', '{\"kode_barang\":\"sdf234\",\"nama\":\"234sdfsdf\",\"harga_jual\":\"234,234\",\"jumlah\":\"2342\",\"pembelian_stok\":\"2,423,423\",\"bertanggungjawab\":\"1\"}', '2022-01-18 16:58:21', 'Sudah'),
(19, 9, 'Penambahan Produk Baru', '{\"kode_barang\":\"fh4534\",\"nama\":\"34534\",\"harga_jual\":\"345,345\",\"jumlah\":\"3453\",\"pembelian_stok\":\"345,345\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:04:04', 'Sudah'),
(20, 10, 'Penambahan Produk Baru', '{\"kode_barang\":\"fgds23\",\"nama\":\"ef3234\",\"harga_jual\":\"242,342\",\"jumlah\":\"2342\",\"pembelian_stok\":\"23,423,423\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:08:55', 'Sudah'),
(21, 11, 'Penambahan Produk Baru', '{\"kode_barang\":\"sd2342\",\"nama\":\"sdfsdf\",\"harga_jual\":\"234,234\",\"jumlah\":\"2342\",\"pembelian_stok\":\"234,234,234\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:09:56', 'Sudah'),
(22, 12, 'Penambahan Produk Baru', '{\"kode_barang\":\"134ash\",\"nama\":\"asdasd\",\"harga_jual\":\"345,453\",\"jumlah\":\"3453\",\"pembelian_stok\":\"34,534,534\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:20:46', 'Sudah'),
(23, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"123\",\"harga_pembelian_stok\":\"12,312,312\",\"total_stok\":\"1363\",\"jumlah_stok_sebelumnya\":\"1240\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:31:23', 'Sudah'),
(24, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"12\",\"harga_pembelian_stok\":\"123,123\",\"total_stok\":\"1375\",\"jumlah_stok_sebelumnya\":\"1363\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:33:13', 'Sudah'),
(25, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"12\",\"harga_pembelian_stok\":\"123,123\",\"total_stok\":\"1375\",\"jumlah_stok_sebelumnya\":\"1363\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:33:58', 'Sudah'),
(26, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"12,313\",\"total_stok\":\"1376\",\"jumlah_stok_sebelumnya\":\"1375\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:34:47', 'Sudah'),
(27, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"12,313\",\"total_stok\":\"1376\",\"jumlah_stok_sebelumnya\":\"1375\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:35:48', 'Sudah'),
(28, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"12,313\",\"total_stok\":\"1376\",\"jumlah_stok_sebelumnya\":\"1375\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:36:45', 'Sudah'),
(29, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"123\",\"harga_pembelian_stok\":\"1\",\"total_stok\":\"1499\",\"jumlah_stok_sebelumnya\":\"1376\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:37:42', 'Sudah'),
(30, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"123\",\"harga_pembelian_stok\":\"12,312\",\"total_stok\":\"1499\",\"jumlah_stok_sebelumnya\":\"1376\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:39:02', 'Sudah'),
(31, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"123\",\"harga_pembelian_stok\":\"12,312\",\"total_stok\":\"1499\",\"jumlah_stok_sebelumnya\":\"1376\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:39:25', 'Sudah'),
(32, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"123\",\"harga_pembelian_stok\":\"12,312\",\"total_stok\":\"1499\",\"jumlah_stok_sebelumnya\":\"1376\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:39:36', 'Sudah'),
(33, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"123\",\"harga_pembelian_stok\":\"12,312\",\"total_stok\":\"1499\",\"jumlah_stok_sebelumnya\":\"1376\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:39:51', 'Sudah'),
(34, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"123\",\"harga_pembelian_stok\":\"12,312\",\"total_stok\":\"1499\",\"jumlah_stok_sebelumnya\":\"1376\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:40:51', 'Sudah'),
(35, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"123\",\"harga_pembelian_stok\":\"12,312\",\"total_stok\":\"1499\",\"jumlah_stok_sebelumnya\":\"1376\",\"bertanggungjawab\":\"1\"}', '2021-12-18 23:24:04', 'Sudah'),
(36, 13, 'Penambahan Produk Baru', '{\"kode_barang\":\"fgh654\",\"nama\":\"546\",\"harga_jual\":\"456,456\",\"jumlah\":\"4564\",\"pembelian_stok\":\"456,456\",\"bertanggungjawab\":\"1\"}', '2021-12-18 17:43:49', 'Sudah'),
(37, 14, 'Penambahan Produk Baru', '{\"kode_barang\":\"asd565\",\"nama\":\"fdsfsdf\",\"harga_jual\":\"345,234\",\"jumlah\":\"2342\",\"pembelian_stok\":\"23,423,423\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:46:31', 'Sudah'),
(38, 15, 'Penambahan Produk Baru', '{\"kode_barang\":\"hf3454\",\"nama\":\"324234\",\"harga_jual\":\"234,234\",\"jumlah\":\"2342\",\"pembelian_stok\":\"234,234\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:54:55', 'Sudah'),
(39, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"21\",\"harga_pembelian_stok\":\"123,123\",\"total_stok\":\"1520\",\"jumlah_stok_sebelumnya\":\"1499\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:55:39', 'Sudah'),
(40, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"123,123\",\"total_stok\":\"1521\",\"jumlah_stok_sebelumnya\":\"1520\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:58:12', 'Sudah'),
(41, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"123,123\",\"total_stok\":\"1521\",\"jumlah_stok_sebelumnya\":\"1520\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:58:46', 'Sudah'),
(42, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"123,123\",\"total_stok\":\"1522\",\"jumlah_stok_sebelumnya\":\"1521\",\"bertanggungjawab\":\"1\"}', '2022-01-18 17:59:19', 'Sudah'),
(43, 5, 'Penambahan Stok', '{\"penambahan_stok\":\"123\",\"harga_pembelian_stok\":\"1\",\"total_stok\":\"2357\",\"jumlah_stok_sebelumnya\":\"2234\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:00:05', 'Sudah'),
(44, 15, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"123\",\"total_stok\":\"2343\",\"jumlah_stok_sebelumnya\":\"2342\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:00:56', 'Sudah'),
(45, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"123\",\"total_stok\":\"1523\",\"jumlah_stok_sebelumnya\":\"1522\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:30:19', 'Sudah'),
(46, 1, 'Penambahan Stok', '{\"penambahan_stok\":\"1\",\"harga_pembelian_stok\":\"123\",\"total_stok\":\"1523\",\"jumlah_stok_sebelumnya\":\"1522\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:30:43', 'Sudah'),
(47, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas11231\",\"nama_baru\":\"asdasdsadas11231\",\"harga_lama\":\"1,231,231\",\"harga_baru\":\"1,231,231\",\"foto_lama\":\"kembar.jpg\",\"foto_baru\":\"1-brjYnVlXwM3j_SWXImT0Rg.png\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:47:59', 'Sudah'),
(48, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas11231\",\"nama_baru\":\"asdasdsadas11231\",\"harga_lama\":\"1,231,231\",\"harga_baru\":\"1,231,231\",\"foto_lama\":\"1-brjYnVlXwM3j_SWXImT0Rg.png\",\"foto_baru\":\"6564e6d48892e6ba325bda1ec27189c9b4b3b473_hq.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:48:45', 'Sudah'),
(49, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas11231\",\"nama_baru\":\"asdasdsadas11231\",\"harga_lama\":\"1,231,231\",\"harga_baru\":\"1,231,231\",\"foto_lama\":\"6564e6d48892e6ba325bda1ec27189c9b4b3b473_hq.jpg\",\"foto_baru\":\"1-brjYnVlXwM3j_SWXImT0Rg.png\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:50:05', 'Sudah'),
(50, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas11231\",\"nama_baru\":\"asdasdsadas11231\",\"harga_lama\":\"1,231,231\",\"harga_baru\":\"1,231,231\",\"foto_lama\":\"1-brjYnVlXwM3j_SWXImT0Rg.png\",\"foto_baru\":\"27661905_1607403089353960_2137003018_n.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:51:17', 'Sudah'),
(51, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas11231\",\"nama_baru\":\"asdasdsadas11231\",\"harga_lama\":\"1,231,231\",\"harga_baru\":\"1,231,231\",\"foto_lama\":\"27661905_1607403089353960_2137003018_n.jpg\",\"foto_baru\":\"1-brjYnVlXwM3j_SWXImT0Rg.png\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:51:45', 'Sudah'),
(52, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas11231\",\"nama_baru\":\"asdasdsadas11231\",\"harga_lama\":\"1,231,231\",\"harga_baru\":\"1,231,231\",\"foto_lama\":\"1-brjYnVlXwM3j_SWXImT0Rg.png\",\"foto_baru\":\"79f509f5451cf0e66e0fa92bcf45a79ee95793b4_hq.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-18 18:52:21', 'Sudah'),
(70, 1, 'Penjualan Barang Spesifik', '{\"jumlah_pembelian\":\"1\",\"harga_jual\":\"1,231,231\",\"stok_sebelumnya\":\"1499\",\"stok_sekarang\":1498,\"total_harga\":1231231}', '2022-01-20 22:18:04', 'Sudah'),
(71, 12, 'Penjualan Barang Spesifik', '{\"jumlah_pembelian\":\"1\",\"harga_jual\":\"345,453\",\"stok_sebelumnya\":\"3429\",\"stok_sekarang\":3428,\"total_harga\":345453}', '2022-01-20 22:18:04', 'Sudah'),
(72, 14, 'Penjualan Barang Spesifik', '{\"jumlah_pembelian\":\"1\",\"harga_jual\":\"345,234\",\"stok_sebelumnya\":\"2319\",\"stok_sekarang\":2318,\"total_harga\":345234}', '2022-01-20 22:18:04', 'Sudah'),
(73, NULL, 'Penjualan Produk', '{\"total_belanja\":\"1,921,918\",\"pembayaran\":\"1,940,000\",\"baki\":\"18,082\",\"ket\":[{\"id\":1,\"kode_barang\":\"123asd\",\"jumlah\":\"1\",\"harga_jual\":\"1,231,231\",\"nama\":\"asdasdsadas11231\",\"total\":1231231,\"jumlah_stok_sebelumnya\":\"1499\",\"jumlah_stok_sekarang\":1498},{\"id\":12,\"kode_barang\":\"134ash\",\"jumlah\":\"1\",\"harga_jual\":\"345,453\",\"nama\":\"asdasd\",\"total\":345453,\"jumlah_stok_sebelumnya\":\"3429\",\"jumlah_stok_sekarang\":3428},{\"id\":14,\"kode_barang\":\"asd565\",\"jumlah\":\"1\",\"harga_jual\":\"345,234\",\"nama\":\"fdsfsdf\",\"total\":345234,\"jumlah_stok_sebelumnya\":\"2319\",\"jumlah_stok_sekarang\":2318}]}', '2022-01-20 22:18:04', 'Sudah'),
(74, 1, 'Penjualan Barang Spesifik', '{\"jumlah_pembelian\":\"1\",\"harga_jual\":\"1,231,231\",\"stok_sebelumnya\":\"1498\",\"stok_sekarang\":1497,\"total_harga\":1231231}', '2022-01-20 22:22:09', 'Sudah'),
(75, 12, 'Penjualan Barang Spesifik', '{\"jumlah_pembelian\":\"1\",\"harga_jual\":\"345,453\",\"stok_sebelumnya\":\"3428\",\"stok_sekarang\":3427,\"total_harga\":345453}', '2022-01-20 22:22:09', 'Sudah'),
(76, NULL, 'Penjualan Produk', '{\"total_belanja\":\"1,576,684\",\"pembayaran\":\"1,600,000\",\"baki\":\"23,316\",\"ket\":[{\"id\":1,\"kode_barang\":\"123asd\",\"jumlah\":\"1\",\"harga_jual\":\"1,231,231\",\"nama\":\"asdasdsadas11231\",\"total\":1231231,\"jumlah_stok_sebelumnya\":\"1498\",\"jumlah_stok_sekarang\":1497},{\"id\":12,\"kode_barang\":\"134ash\",\"jumlah\":\"1\",\"harga_jual\":\"345,453\",\"nama\":\"asdasd\",\"total\":345453,\"jumlah_stok_sebelumnya\":\"3428\",\"jumlah_stok_sekarang\":3427}]}', '2022-01-20 22:22:09', 'Sudah'),
(77, 1, 'Edit Detail Produk', '{\"nama_lama\":\"asdasdsadas11231\",\"nama_baru\":\"asda\",\"harga_lama\":\"1,231,231\",\"harga_baru\":\"123,123\",\"foto_lama\":\"79f509f5451cf0e66e0fa92bcf45a79ee95793b4_hq.jpg\",\"foto_baru\":\"brothers.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-20 23:59:52', 'Sudah'),
(78, 16, 'Penambahan Produk Baru', '{\"kode_barang\":\"gfh456\",\"nama\":\"dfgdfg\",\"harga_jual\":\"50,000\",\"jumlah\":\"200\",\"pembelian_stok\":\"5,000,000\",\"bertanggungjawab\":\"1\"}', '2022-01-21 04:03:41', 'Sudah'),
(79, 16, 'Penambahan Stok', '{\"penambahan_stok\":\"20\",\"harga_pembelian_stok\":\"200,000\",\"total_stok\":\"220\",\"jumlah_stok_sebelumnya\":\"200\",\"bertanggungjawab\":\"1\"}', '2022-01-21 04:04:39', 'Sudah'),
(80, 16, 'Edit Detail Produk', '{\"nama_lama\":\"dfgdfg\",\"nama_baru\":\"dfgdfg\",\"harga_lama\":\"50,000\",\"harga_baru\":\"50,000\",\"foto_lama\":\"wp1987505-gin-ichimaru-wallpapers.jpg\",\"foto_baru\":\"wp1987423-gin-ichimaru-wallpapers.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-24 04:05:21', 'Sudah'),
(81, 16, 'Edit Detail Produk', '{\"nama_lama\":\"dfgdfg\",\"nama_baru\":\"dfgdfg\",\"harga_lama\":\"50,000\",\"harga_baru\":\"50,000\",\"foto_lama\":\"wp1987423-gin-ichimaru-wallpapers.jpg\",\"foto_baru\":\"wp1987433-gin-ichimaru-wallpapers.jpg\",\"bertanggungjawab\":\"1\"}', '2022-01-24 04:08:36', 'Sudah'),
(82, 3, 'Penjualan Barang Spesifik', '{\"jumlah_pembelian\":\"2\",\"harga_jual\":\"345,546\",\"stok_sebelumnya\":\"4572\",\"stok_sekarang\":4570,\"total_harga\":691092}', '2022-01-21 06:45:41', 'Sudah'),
(83, 16, 'Penjualan Barang Spesifik', '{\"jumlah_pembelian\":\"2\",\"harga_jual\":\"50,000\",\"stok_sebelumnya\":\"220\",\"stok_sekarang\":218,\"total_harga\":100000}', '2022-01-21 04:09:37', 'Sudah'),
(84, NULL, 'Penjualan Produk', '{\"total_belanja\":\"791,092\",\"pembayaran\":\"800,000\",\"baki\":\"8,908\",\"ket\":[{\"id\":3,\"kode_barang\":\"456dfg\",\"jumlah\":\"2\",\"harga_jual\":\"345,546\",\"nama\":\"sdfgsdf\",\"total\":691092,\"jumlah_stok_sebelumnya\":\"4572\",\"jumlah_stok_sekarang\":4570},{\"id\":16,\"kode_barang\":\"gfh456\",\"jumlah\":\"2\",\"harga_jual\":\"50,000\",\"nama\":\"dfgdfg\",\"total\":100000,\"jumlah_stok_sebelumnya\":\"220\",\"jumlah_stok_sekarang\":218}]}', '2022-01-24 04:09:37', 'Sudah');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_barang`
--
ALTER TABLE `tb_barang`
  ADD PRIMARY KEY (`no_barang`),
  ADD UNIQUE KEY `kode_barang` (`kode_barang`);

--
-- Indexes for table `tb_login`
--
ALTER TABLE `tb_login`
  ADD PRIMARY KEY (`no_login`);

--
-- Indexes for table `tb_log_history`
--
ALTER TABLE `tb_log_history`
  ADD PRIMARY KEY (`no_log`),
  ADD KEY `no_barang` (`no_barang`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_barang`
--
ALTER TABLE `tb_barang`
  MODIFY `no_barang` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `tb_login`
--
ALTER TABLE `tb_login`
  MODIFY `no_login` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tb_log_history`
--
ALTER TABLE `tb_log_history`
  MODIFY `no_log` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_log_history`
--
ALTER TABLE `tb_log_history`
  ADD CONSTRAINT `tb_log_history_ibfk_1` FOREIGN KEY (`no_barang`) REFERENCES `tb_barang` (`no_barang`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
