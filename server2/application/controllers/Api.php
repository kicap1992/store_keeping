<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, PUT');
header('Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Authorization , X-Authorization , X-Auth-Token');
header("Access-Control-Expose-Headers: Content-Length, X-JSON");
header('Access-Control-Allow-Credentials: true');
header('Content-Type: application/json');

defined('BASEPATH') or exit('No direct script access allowed');

use chriskacerguis\RestServer\RestController;

class Api extends RestController
{
  function __construct()
  {
    parent::__construct();
    $this->load->model('model');;
    // $this->db->query("SET sql_mode = '' ");
    date_default_timezone_set("Asia/Kuala_Lumpur");
  }

  public function index_get()
  {
    $this->response(['message' => 'Halo Bosku'], 200);
    // redirect(base_url());

  }

  // --------------------------------dibawah khusus untuk admin -----------------------------//

  public function coba_post()
  {
    $file = $_FILES['myfile'];
    $dir = "img/hehe/";
    if (is_dir($dir) === false) {
      mkdir($dir);
    }
    move_uploaded_file($file['tmp_name'], $dir . $file['name']);
    // $file = $this->post('Id');
    $this->response(['message' => $file], 200);
  }

  public function tambah_produk_post()
  {
    $foto = $_FILES['foto'];
    $data = json_decode($this->post('data'), true);
    unset($data['ke_db_online']);
    $history = json_decode($this->post('history'), true);
    unset($history['ke_db_online']);
    $dir = "img/" . $data['no_barang'] . "/";
    if (is_dir($dir) === false) {
      mkdir($dir);
    }
    move_uploaded_file($foto['tmp_name'], $dir . $foto['name']);
    $this->model->insert('tb_barang', $data);
    $this->model->insert('tb_log_history', $history);

    $this->response(['message' => 'tambah produk', 'data' => $history], 200);
  }

  public function tambah_stok_post()
  {
    $foto = $_FILES['foto'];
    $data = json_decode($this->post('data'), true);
    unset($data['ke_db_online']);
    $history = json_decode($this->post('history'), true);
    unset($history['ke_db_online']);
    $jumlah_stok = json_decode($history['ket'], true);
    $jumlah_stok = $jumlah_stok['total_stok'];
    $cek_data = $this->model->tampil_data_where('tb_barang', ['no_barang' => $data['no_barang']])->result();
    if (count($cek_data) > 0) {
    } else {
      $dir = "img/" . $data['no_barang'] . "/";
      if (is_dir($dir) === false) {
        mkdir($dir);
      }
      move_uploaded_file($foto['tmp_name'], $dir . $foto['name']);
      $this->model->insert('tb_barang', $data);
    }
    $this->model->insert('tb_log_history', $history);
    $this->model->update('tb_barang', array('no_barang' => $history['no_barang']), array('jumlah' => $jumlah_stok));
    $this->response(['message' => 'tambah stok'], 200);
    // $this->response(['message' => 'tambah produk', 'data' => $history], 200);
  }

  public function edit_detail_produk_post()
  {
    $foto = $_FILES['foto'];
    $data = json_decode($this->post('data'), true);
    unset($data['ke_db_online']);
    $history = json_decode($this->post('history'), true);
    unset($history['ke_db_online']);
    $cek_foto = $this->post('cek_foto');

    $cek_data = $this->model->tampil_data_where('tb_barang', ['no_barang' => $data['no_barang']])->result();
    if (count($cek_data) > 0) {
      if ($cek_foto == 'ada') {
        $dir = "img/" . $data['no_barang'] . "/";
        if (is_dir($dir) === false) {
          mkdir($dir);
        }
        //delete all file in folder
        $files = glob($dir . '*'); // get all file names
        foreach ($files as $file) { // iterate files
          if (is_file($file))
            unlink($file); // delete file
        }
        move_uploaded_file($foto['tmp_name'], $dir . $foto['name']);
        //   $this->model->insert('tb_barang', $data);
      }
    } else {
      $dir = "img/" . $data['no_barang'] . "/";
      if (is_dir($dir) === false) {
        mkdir($dir);
      }
      move_uploaded_file($foto['tmp_name'], $dir . $foto['name']);
      $this->model->insert('tb_barang', $data);
    }



    $this->model->insert('tb_log_history', $history);
    $this->model->update('tb_barang', array('no_barang' => $data['no_barang']), $data);

    $this->response(['message' => 'edit_detail'], 200);
  }

  public function penjualan_post()
  {
    $data_barang = json_decode($this->post('data_barang'), true);
    $history_barang = json_decode($this->post('history_barang'), true);
    $foto = $_FILES['foto'];
    $countfoto = count($foto['name']);
    for ($i = 0; $i < $countfoto; $i++) {
      $cek_barang = $this->model->tampil_data_where('tb_barang', ['no_barang' => $data_barang[$i]['no_barang']])->result();
      unset($data_barang[$i]['ke_db_online']);
      unset($history_barang[$i]['ke_db_online']);
      if (count($cek_barang) > 0) {
      } else {

        $this->model->insert('tb_barang', $data_barang[$i]);
        $dir = "img/penjualan/" . $foto['name'][$i] . '/';
        if (is_dir($dir) === false) {
          mkdir($dir);
        }
        move_uploaded_file($foto['tmp_name'][$i], $dir . $foto['name'][$i]);
      }

      # code...
    }

    foreach ($data_barang as $key => $value) {
      // unset($value['ke_db_online']);
      $this->model->update('tb_barang', array('no_barang' => $value['no_barang']), $value);
      $this->model->insert('tb_log_history', $history_barang[$key]);
    }
    $history = json_decode($this->post('history'), true);
    unset($history['ke_db_online']);
    $this->model->insert('tb_log_history', $history);



    $this->response(['message' => $data_barang[0]], 200);
  }

  public function update_laporan_post()
  {
    $cek_data_barang = $this->post('cek_data_barang');


    if ($cek_data_barang == 'ada') {
      $data_barang = json_decode($this->post('data_barang'), true);

      $foto = $_FILES['foto'];

      foreach ($data_barang as $key => $value) {
        unset($data_barang[$key]['ke_db_online']);
        $cek_barang = $this->model->tampil_data_where('tb_barang', ['no_barang' => $value['no_barang']])->result();
        if (count($cek_barang) > 0) {
          $this->model->update('tb_barang', array('no_barang' => $value['no_barang']), $data_barang[$key]);
        } else {
          $this->model->insert('tb_barang', $data_barang[$key]);
        }
        $dir = "img/" . $value['no_barang'] . '/';
        if (is_dir($dir) === false) {
          mkdir($dir);
        }
        move_uploaded_file($foto['tmp_name'][$key], $dir . $foto['name'][$key]);
      }
    }

    $cek_data_history = $this->post('cek_data_history');
    if ($cek_data_history == 'ada') {
      $history = json_decode($this->post('history'), true);
      foreach ($history as $key => $value) {
        unset($history[$key]['ke_db_online']);
        $cek_history = $this->model->tampil_data_where('tb_log_history', ['no_log' => $value['no_log']])->result();
        if (count($cek_history) > 0) {
          $this->model->update('tb_log_history', array('no_log' => $value['no_log']), $history[$key]);
        } else {
          $this->model->insert('tb_log_history', $history[$key]);
        }
      }
    }



    $this->response(['message' => $cek_data_barang], 200);
  }

  public function login_user_get(){
    $username = $this->get('username');
    $password = md5($this->get('password'));
    
    $cek_data = $this->model->tampil_data_where('tb_login', ['username' => $username, 'password' => $password])->result();

    if (count($cek_data) > 0) {
      $this->response(['message' => 'login_berhasil','data' => $cek_data[0]], 200);
    } else {
      $this->response(['message' => 'login_gagal'], 401);
    }
    
    // $this->response(['message' => $cek_data], 200);
  }

  public function ambil_laporan_get(){
    $tanggal = $this->get('tanggal');
    $bulan = $this->get('bulan');
    $tahun = $this->get('tahun');
    $filter = $this->get('filter');
    if($tanggal != null || $tanggal != ''){
      if($filter != null || $filter != ''){
        $cek_data = $this->model->custom_query("SELECT * FROM tb_log_history where status != 'Penjualan Barang Spesifik' and DATE(waktu) = DATE('".$tanggal."') and (waktu like '%".$filter."%' or status like '%".$filter."%') order by waktu desc")->result();
      }else{
        $cek_data = $this->model->custom_query("SELECT * FROM tb_log_history where status != 'Penjualan Barang Spesifik' and DATE(waktu) = DATE('".$tanggal."') order by waktu desc")->result();
      }
      

    }else{
      if($filter != null || $filter != ''){
        $cek_data = $this->model->custom_query("SELECT * FROM tb_log_history where status != 'Penjualan Barang Spesifik' and MONTH(waktu) = $bulan and YEAR(waktu) = $tahun and (waktu like '%".$filter."%' or status like '%".$filter."%') order by waktu desc")->result();
      }else{
        $cek_data = $this->model->custom_query("SELECT * FROM tb_log_history where status != 'Penjualan Barang Spesifik' and MONTH(waktu) = $bulan and YEAR(waktu) = $tahun order by waktu desc")->result();
      }
      
    }
    
    $this->response(['status' => 'success', 'data' => $cek_data], 200);
  }

  public function ambil_laporan_detail_get(){
    $no_log = $this->get('no_log');
    $cek_data = $this->model->tampil_data_where('tb_log_history', ['no_log' => $no_log])->result();
    $this->response(['status' => 'success', 'data' => $cek_data], 200);
  }

  public function ambil_produk_all_get(){
    $page = $this->get('page');
    $cekfilter = $this->get('cekfilter');
    $filter = $this->get('filter');

    $data_all = $this->model->tampil_data_keseluruhan('tb_barang')->result();

    if($page == '1'){
      $page = (int)$page - 1;
    }else{
      $page = ((int)$page - 1) * 10;

    }
    if($cekfilter == 'ada'){
      $data_all = $this->model->custom_query("SELECT * FROM `tb_barang` WHERE nama like '%$filter%' or kode_barang like '%$filter%'")->result();
      $cek_data = $this->model->custom_query("SELECT * FROM `tb_barang` WHERE nama like '%$filter%' or kode_barang like '%$filter%' LIMIT $page, 10")->result();
    }else if($cekfilter == 'tiada'){
      $cek_data = $this->model->custom_query("SELECT * FROM `tb_barang` LIMIT $page, 10")->result();
    }
    $this->response(['status' => 'success','ceil' => count($data_all), 'data' => $cek_data ], 200);
  }

  public function ambil_log_produk_detail_get(){
    $page = $this->get('page');
    $no_barang = $this->get('no_barang');
    $cekfilter = $this->get('haha');
    $filter = $this->get('filter');
    

    $data_all = $this->model->tampil_data_where('tb_log_history',['no_barang' => $no_barang])->result();

    if($page == '1'){
      $page = (int)$page - 1;
      
    }else{
      $page = ((int)$page - 1) * 10;

    }

    if($cekfilter == 'ada'){
      $data_all = $this->model->custom_query("SELECT * FROM `tb_log_history` WHERE no_barang = '$no_barang' and (waktu like '%$filter%' or status like '%$filter%')")->result();
      $cek_data = $this->model->custom_query("SELECT * FROM `tb_log_history` WHERE no_barang=$no_barang and (waktu like '%$filter%' or status like '%$filter%') order by waktu desc LIMIT $page, 10")->result();
    }else if($cekfilter == 'tiada'){
      $cek_data = $this->model->custom_query("SELECT * FROM `tb_log_history` WHERE no_barang=$no_barang order by waktu desc LIMIT $page, 10")->result();  
    }
    $this->response(['status' => 'success','page' => $page,'ceil' => count($data_all), 'data' => $cek_data , 'filter' => $filter, 'cek_filter' => $cekfilter], 200);
  }

  public function ambil_produk_detail_get(){


    $no_barang = $this->get('no_barang');
    

    $cek_data = $this->model->tampil_data_where('tb_barang',['no_barang' => $no_barang ])->result()[0];

    $this->response(['status' => 'success', 'data' => $cek_data ], 200);
  }

  public function ambil_laporan_all_get(){
    $page = $this->get('page');
    $cekfilter = $this->get('haha');
    $filter = $this->get('filter');
    

    $data_all = $this->model->custom_query("SELECT * FROM `tb_log_history` WHERE status != 'Penjualan Barang Spesifik'")->result();

    if($page == '1'){
      $page = (int)$page - 1;
      
    }else{
      $page = ((int)$page - 1) * 10;

    }

    if($cekfilter == 'ada'){
      $data_all = $this->model->custom_query("SELECT * FROM `tb_log_history` WHERE status != 'Penjualan Barang Spesifik' and (waktu like '%$filter%' or status like '%$filter%')")->result();
      $cek_data = $this->model->custom_query("SELECT * FROM `tb_log_history` WHERE status != 'Penjualan Barang Spesifik' and (waktu like '%$filter%' or status like '%$filter%') order by waktu desc LIMIT $page, 10")->result();
    }else if($cekfilter == 'tiada'){
      $cek_data = $this->model->custom_query("SELECT * FROM `tb_log_history` WHERE status != 'Penjualan Barang Spesifik' order by waktu desc LIMIT $page, 10")->result();  
    }
    $this->response(['status' => 'success','page' => $page,'ceil' => count($data_all), 'data' => $cek_data , 'filter' => $filter, 'cek_filter' => $cekfilter], 200);
  }

  public function cek_datanya_get(){
    $cek_data = $this->model->custom_query("SELECT no_log FROM tb_log_history WHERE dibaca = 'Belum' and status !='Penjualan Barang Spesifik'")->result();
    // $nilai = (count($cek_data) > 0) ? "ada datanya di server" : "tiada datanya di server";
    $this->response(['status' => 'success', 'data' => $cek_data], 200);
  }


  public function laporan_read_get(){
    $no_log = $this->get('no_log');
    $this->model->update('tb_log_history',['no_log' => $no_log],['dibaca' => 'Sudah']);
    // $nilai = (count($cek_data) > 0) ? "ada datanya di server" : "tiada datanya di server";
    $this->response(['status' => 'success', 'data' => $no_log], 200);
  }

  public function laporan_read_all_get(){
    // $no_log = $this->get('no_log');
    $this->model->custom_query("UPDATE tb_log_history SET dibaca = 'Sudah'");
    // $nilai = (count($cek_data) > 0) ? "ada datanya di server" : "tiada datanya di server";
    $this->response(['status' => 'success'], 200);
  }
}
