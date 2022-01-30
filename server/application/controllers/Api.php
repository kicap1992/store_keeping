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
  var $server_url;
  function __construct()
  {
    parent::__construct();
    $this->load->model('model');;
    // $this->db->query("SET sql_mode = '' ");
    date_default_timezone_set("Asia/Kuala_Lumpur");
    $this->server_url = 'http://localhost/ilham/server2/api/';
  }

  public function index_get()
  {
    $this->response(['message' => 'Halo Bosku'], 200);
    // redirect(base_url());

  }

  // --------------------------------dibawah khusus untuk admin -----------------------------//

  public function login_user_get()
  {
    $username = $this->get('username');
    $password = $this->get('password');

    $cek_data = $this->model->tampil_data_where('tb_login', array('username' => $username, 'password' => md5($password)))->result();

    // if count $cek_data > 0, then  response success , else response error
    if (count($cek_data) > 0) {
      $cek_user = $this->model->custom_query("SELECT * FROM tb_user a join tb_login b on a.no_user = b.no_user where a.no_user=" . $cek_data[0]->no_user)->result();
      $this->response(['status' => 'success', 'data' => $cek_user[0]], 200);
    } else {
      $this->response(['status' => 'error', 'message' => 'Username atau Password Salah'], 400);
    }

    // $this->response(['status' => true, 'message' =>$username], 200);
  }

  public function cek_user_get()
  {
    $username = $this->get('username');
    $password = $this->get('password');
    $no_user = $this->get('id');

    $cek_data = $this->model->custom_query("SELECT * FROM tb_user a join tb_login b on a.no_user = b.no_user where a.no_user=" . $no_user . " and username='" . $username . "' and password='" . $password . "'")->result();

    // if count $cek_data > 0, then  response success , else response error
    if (count($cek_data) > 0) {

      $this->response(['status' => 'success'], 200);
    } else {
      $this->response(['status' => 'error'], 400);
    }

    $this->response(['status' => true, 'message' => 'sini_dia'], 200);
  }


  public function tambah_produk_post()
  {
    $foto = $_FILES['foto'];
    $data = json_decode($this->post('data'), true);
    $data_to_db = $data;

    // remove $data['pembelian_stok']
    unset($data_to_db['pembelian_stok']);
    unset($data_to_db['bertanggungjawab']);



    $cek_data = $this->model->tampil_data_where('tb_barang', ['kode_barang' => $data_to_db['kode_barang']])->result();

    // if count $cek_data > 0, then  response success , else response error
    if (count($cek_data) > 0) {
      $this->response(['status' => 'error'], 400);
    } else {
      $this->model->insert('tb_barang', $data_to_db);
      $cek_barang = $this->model->tampil_data_where('tb_barang', $data_to_db)->result()[0];

      // $cek_id = $this->model->cek_last_ai('tb_kategori');
      $dir = "img/" . $cek_barang->no_barang . '/';
      if (is_dir($dir) === false) {
        mkdir($dir);
      }
      move_uploaded_file($foto['tmp_name'], $dir . $foto['name']);

      unset($data['foto']);

      $this->model->insert('tb_log_history', ['no_barang' => $cek_barang->no_barang, 'status' => "Penambahan Produk Baru", "waktu" => date("Y-m-d H:i:s"), "ket" => json_encode($data)]);

      $cek_history = $this->model->custom_query("SELECT * FROM tb_log_history where no_barang=" . $cek_barang->no_barang . " order by no_log desc")->result()[0];





      // $file_name_with_full_path = realpath("img/".$cek_barang->no_barang."/".$data_to_db['foto']);
      // $postimg = array('myfile' => '@' . $file_name_with_full_path);
      $data_to_server_db['foto'] = new CurlFile("img/" . $cek_barang->no_barang . "/" . $data_to_db['foto'], 'image/jpg', $data_to_db['foto']);
      $data_to_server_db['data'] = json_encode($cek_barang);
      $data_to_server_db['history'] = json_encode($cek_history);

      $headers = array("Content-Type:multipart/form-data");
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, $data_to_server_db);
      curl_setopt($ch, CURLOPT_USERPWD, "Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73");
      // curl_setopt($ch, CURLOPT_HEADER, 1);
      curl_setopt($ch, CURLOPT_URL, $this->server_url . 'tambah_produk');
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      $data = curl_exec($ch);
      $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      curl_close($ch);

      if ($httpcode == 200) {
        $stat = 'success';
        $this->model->update('tb_barang', ['no_barang' => $cek_barang->no_barang], ['ke_db_online' => 'Sudah']);
        $this->model->update('tb_log_history', ['no_log' => $cek_history->no_log], ['ke_db_online' => 'Sudah']);
      } else {
        $stat = 'error';
      }

      // sleep(5);
      $this->response(['status' => $cek_barang, 'stat' => $stat, 'data_server' => $data], 200);
      // $this->response(['status' => $this->server_url], 200);
    }

    // $this->response(['status' => true, 'message' => $cek_data], 200);
  }

  public function get_produk_get()
  {
    $no_produk = $this->get('id');
    $cek_data = $this->model->tampil_data_where('tb_barang', ['no_barang' => $no_produk])->result();

    // if count $cek_data > 0, then  response success , else response error
    if (count($cek_data) > 0) {
      $this->response(['status' => 'success', 'data' => $cek_data[0]], 200);
    } else {
      $this->response(['status' => 'error', 'message' => 'Produk tidak ditemukan'], 400);
    }
    // $this->response(['status' => $no_produk], 200);
  }

  public function tambah_stok_put()
  {
    $no_produk = $this->put('id');
    $data = $this->put('data');
    $cek_data = $this->model->tampil_data_where('tb_barang', ['no_barang' => $no_produk])->result();

    // if count $cek_data > 0, then  response success , else response error
    if (count($cek_data) > 0) {
      $this->model->update('tb_barang', ['no_barang' => $no_produk], ['jumlah' => $data['total_stok']]);
      $this->model->insert('tb_log_history', ['no_barang' => $no_produk, 'status' => "Penambahan Stok", "waktu" => date("Y-m-d H:i:s"), "ket" => json_encode($data)]);

      $cek_history = $this->model->custom_query("SELECT * FROM tb_log_history where no_barang=" . $no_produk . " order by no_log desc")->result()[0];
      $cek_barang = $this->model->tampil_data_where('tb_barang', ['no_barang' => $no_produk])->result()[0];

      $data_to_server_db['foto'] = new CurlFile("img/" . $cek_barang->no_barang . "/" . $cek_barang->foto, 'image/jpg', $cek_barang->foto);
      $data_to_server_db['data'] = json_encode($cek_barang);
      $data_to_server_db['history'] = json_encode($cek_history);

      $headers = array("Content-Type:multipart/form-data");
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, $data_to_server_db);
      curl_setopt($ch, CURLOPT_USERPWD, "Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73");
      // curl_setopt($ch, CURLOPT_HEADER, 1);
      curl_setopt($ch, CURLOPT_URL, $this->server_url . 'tambah_stok');
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      $data = curl_exec($ch);
      $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      curl_close($ch);

      if ($httpcode == 200) {
        $stat = 'success';
        $this->model->update('tb_barang', ['no_barang' => $cek_barang->no_barang], ['ke_db_online' => 'Sudah']);
        $this->model->update('tb_log_history', ['no_log' => $cek_history->no_log], ['ke_db_online' => 'Sudah']);
      } else {
        $stat = 'error';
      }

      // $this->response(['status' => 'success', 'stat' => $stat,'data' => $data], 200);
      $this->response(['status' => 'success', 'stat' => $stat, 'server' => $data], 200);
    } else {
      $this->response(['status' => 'error', 'message' => 'Produk tidak ditemukan'], 400);
    }
  }

  public function edit_detail_produk_post()
  {
    $no_produk = $this->post('id');
    $data = json_decode($this->post('data'), true);
    $cek_foto = $this->post('cek_foto');
    $foto = ($cek_foto == 'tiada') ? null : $_FILES['foto'];
    $cek_data = $this->model->tampil_data_where('tb_barang', ['no_barang' => $no_produk])->result();

    // if count $cek_data > 0, then  response success , else response error
    if (count($cek_data) > 0) {
      $this->model->update('tb_barang', ['no_barang' => $no_produk], ["nama" => $data['nama_baru'], "harga_jual" => $data['harga_baru'], "foto" => $data['foto_baru']]);
      if ($cek_foto == 'ada') {
        $dir = "img/" . $no_produk . '/';
        //delete all file in $dir 
        $files = glob($dir . '*'); // get all file names
        foreach ($files as $file) { // iterate files
          if (is_file($file))
            unlink($file); // delete file
        }

        //upload new file
        move_uploaded_file($foto['tmp_name'], $dir . $foto['name']);
      }
      $this->model->insert('tb_log_history', ['no_barang' => $no_produk, 'status' => "Edit Detail Produk", "waktu" => date("Y-m-d H:i:s"), "ket" => json_encode($data)]);
      $cek_history = $this->model->custom_query("SELECT * FROM tb_log_history where no_barang=" . $no_produk . " order by no_log desc")->result()[0];

      $data_to_server_db['foto'] = new CurlFile("img/" . $no_produk . "/" . $foto['name'], 'image/jpg', $foto['name']);
      $data_to_server_db['data'] = json_encode($cek_data[0]);
      $data_to_server_db['history'] = json_encode($cek_history);
      $data_to_server_db['cek_foto'] = $cek_foto;

      $headers = array("Content-Type:multipart/form-data");
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, $data_to_server_db);
      curl_setopt($ch, CURLOPT_USERPWD, "Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73");
      // curl_setopt($ch, CURLOPT_HEADER, 1);
      curl_setopt($ch, CURLOPT_URL, $this->server_url . 'edit_detail_produk');
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      $data = curl_exec($ch);
      $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      curl_close($ch);

      if ($httpcode == 200) {
        $stat = 'success';
        $this->model->update('tb_barang', ['no_barang' => $no_produk], ['ke_db_online' => 'Sudah']);
        $this->model->update('tb_log_history', ['no_log' => $cek_history->no_log], ['ke_db_online' => 'Sudah']);
      } else {
        $stat = 'error';
      }

      $this->response(['status' => 'success', 'stat' => $stat], 200);
    } else {
      $this->response(['status' => 'error', 'message' => 'Produk tidak ditemukan'], 400);
    }

    // $this->response(['status' => $foto], 200);
  }

  public function cari_produk_get()
  {
    $id = $this->get('id');
    $cek_data = $this->model->custom_query("SELECT * FROM tb_barang where kode_barang like '%" . $id . "%' or nama like '" . $id . "'")->result();

    // if (count($cek_data) > 0) {
    //   $this->response(['status' => 'success', 'data' => $cek_data], 200);
    // } else {
    //   $this->response(['status' => 'error', 'message' => 'Produk tidak ditemukan'], 400);
    // }

    $this->response(['status' => 'success', 'data' => $cek_data], 200);
  }

  public function penjualan_post()
  {
    $data = $this->post('data');


    $array_penjualan = json_decode($data['ket'], true);
    //loop array penjualan
    $data_to_server_db['data_barang'] = [];
    $data_to_server_db['history_barang'] = [];

    foreach ($array_penjualan as $key => $value) {

      $cek_barang = $this->model->tampil_data_where('tb_barang', ['no_barang' => $value['id']])->result()[0];
      $jumlah_stok_sebelumnya = $cek_barang->jumlah;
      $jumlah_stok_sekarang = $jumlah_stok_sebelumnya - $value['jumlah'];
      $array_penjualan[$key]['jumlah_stok_sebelumnya'] = $jumlah_stok_sebelumnya;
      $array_penjualan[$key]['jumlah_stok_sekarang'] = $jumlah_stok_sekarang;
      $this->model->update('tb_barang', ['no_barang' => $value['id']], ['jumlah' => $jumlah_stok_sekarang]);
      $array_to_db = array(
        'jumlah_pembelian' => $value['jumlah'],
        'harga_jual' => $value['harga_jual'],
        'stok_sebelumnya' => $jumlah_stok_sebelumnya,
        'stok_sekarang' => $jumlah_stok_sekarang,
        'total_harga' => $value['total'],
      );
      $this->model->insert('tb_log_history', ['no_barang' => $value['id'], 'status' => "Penjualan Barang Spesifik", "ket" => json_encode($array_to_db)]);
      $cek_history_barang['ini_' . $key] = $this->model->custom_query("SELECT * FROM tb_log_history where no_barang =" . $value['id'] . " order by no_log desc")->result()[0];
      $cek_barang = $this->model->tampil_data_where('tb_barang', ['no_barang' => $value['id']])->result()[0];
      $fotonya = new CurlFile(
        "img/" . $cek_barang->no_barang . "/" . $cek_barang->foto,
        'image/jpg',
        $cek_barang->foto
      );
      //push data to $data_to_server_db

      array_push($data_to_server_db['data_barang'], $cek_barang);
      array_push($data_to_server_db['history_barang'], $cek_history_barang['ini_' . $key]);
      // array_push($data_to_server_db['foto'], $fotonya);
      $data_to_server_db['foto[' . $key . ']'] = $fotonya;
    }
    $data['ket'] = $array_penjualan;
    unset($data['status']);

    $data = array('status' => 'Penjualan Produk', 'ket' => json_encode($data));
    // $datanya_lagi = $data;

    $this->model->insert('tb_log_history', $data);
    $cek_history = $this->model->custom_query("SELECT * FROM tb_log_history order by no_log desc")->result()[0];
    $data_to_server_db['data_barang'] = json_encode($data_to_server_db['data_barang']);
    $data_to_server_db['history_barang'] = json_encode($data_to_server_db['history_barang']);
    $data_to_server_db['history'] = json_encode($cek_history);

    // $data_to_server_db['hehe'] = 'hehe';

    $headers = array("Content-Type:multipart/form-data");
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data_to_server_db);
    curl_setopt($ch, CURLOPT_USERPWD, "Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73");
    // curl_setopt($ch, CURLOPT_HEADER, 1);
    curl_setopt($ch, CURLOPT_URL, $this->server_url . 'penjualan');
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    $data = curl_exec($ch);
    $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    if ($httpcode == 200) {
      $stat = 'success';
      foreach ($array_penjualan as $key => $value) {
        $this->model->update('tb_barang', ['no_barang' => $value['id']], ['ke_db_online' => 'Sudah']);
        $this->model->update('tb_log_history', ['no_log' => $cek_history_barang['ini_' . $key]->no_log], ['ke_db_online' => 'Sudah']);
      }
      $this->model->update('tb_log_history', ['no_log' => $cek_history->no_log], ['ke_db_online' => 'Sudah']);
    } else {
      $stat = 'error';
    }

    $this->response(['status' => 'success', 'stat' => $stat], 200);
  }

  public function laporan_get()
  {
    $bulan = $this->get('bulan');
    $tahun = $this->get('tahun');

    $cek_data = $this->model->custom_query("SELECT * FROM tb_log_history where status != 'Penjualan Barang Spesifik' and MONTH(waktu) = $bulan and YEAR(waktu) = $tahun")->result();

    foreach ($cek_data as $key => $value) {
      if ($value->status != 'Penjualan Produk') {
        $cek_produk = $this->model->tampil_data_where('tb_barang', ['no_barang' => $value->no_barang])->result()[0];
        $cek_data[$key]->foto = $cek_produk->foto;
        $cek_data[$key]->kode_barang = $cek_produk->kode_barang;
      } else {
        $cek_data[$key]->kode_barang = "-";
      }
    }


    $this->response(['status' => 'success', 'data' => $cek_data], 200);
  }


  public function laporan_detail_get()
  {
    $id = $this->get('id');
    // $tahun = $this->get('tahun');

    $cek_data = $this->model->tampil_data_where('tb_log_history', ['no_log' => $id])->result();

    if (count($cek_data) > 0) {
      $this->response(['status' => 'success', 'data' => $cek_data[0]], 200);
    } else {
      $this->response(['status' => 'error', 'data' => 'Data tidak ditemukan'], 400);
    }
  }

  public function update_laporan_post()
  {
    $cek_barang = $this->model->tampil_data_where('tb_barang', ['ke_db_online' => 'Belum'])->result();
    
    $data_to_server_db['cek_data_barang'] = 'tiada';
    $data_to_server_db['cek_data_history'] = 'tiada';

    if (count($cek_barang) > 0) {
      $data_to_server_db['cek_data_barang'] = 'ada';
      $data_to_server_db['data_barang'] = [];
      foreach ($cek_barang as $key => $value) {
        $fotonya = new CurlFile(
          "img/" . $value->no_barang . "/" . $value->foto,
          'image/jpg',
          $value->foto
        );
        $data_to_server_db['foto[' . $key . ']'] = $fotonya;
        array_push($data_to_server_db['data_barang'], $value);
      }
      $data_to_server_db['data_barang'] = json_encode($data_to_server_db['data_barang']);
    }



    
    $cek_history = $this->model->tampil_data_where('tb_log_history', ['ke_db_online' => 'Belum'])->result();
    if(count($cek_history) > 0){
      $data_to_server_db['history'] = [];
      $data_to_server_db['cek_data_history'] = 'ada';
      foreach ($cek_history as $key => $value) {
        array_push($data_to_server_db['history'], $value);
      }
      $data_to_server_db['history'] = json_encode($data_to_server_db['history']);
    }
    
    // foreach ($cek_history as $key => $value) {
    //   array_push($data_to_server_db['history'], $value);
    // }
    // $data_to_server_db['history'] = json_encode($data_to_server_db['history']);

    if($data_to_server_db['cek_data_barang'] == 'ada' || $data_to_server_db['cek_data_history'] == 'ada'){
      $headers = array("Content-Type:multipart/form-data");
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      curl_setopt($ch, CURLOPT_POST, 1);
      curl_setopt($ch, CURLOPT_POSTFIELDS, $data_to_server_db);
      curl_setopt($ch, CURLOPT_USERPWD, "Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73");
      // curl_setopt($ch, CURLOPT_HEADER, 1);
      curl_setopt($ch, CURLOPT_URL, $this->server_url . 'update_laporan');
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      $data = curl_exec($ch);
      $httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
      curl_close($ch);

      if($httpcode == 200){
        $stat = 'success';
        foreach ($cek_barang as $key => $value) {
          $this->model->update('tb_barang', ['no_barang' => $value->no_barang], ['ke_db_online' => 'Sudah']);
        }
        foreach ($cek_history as $key => $value) {
          $this->model->update('tb_log_history', ['no_log' => $value->no_log], ['ke_db_online' => 'Sudah']);
        }
      }else{
        $stat = 'error';
      }
    }else{
      $stat = 'already';
    }


    $this->response(['status' => 'success','stat' => $stat, 'data' => $data_to_server_db], 200);
    // $this->response(['status' => 'success', 'data' => $data_to_server_db], 200);
  }
}
