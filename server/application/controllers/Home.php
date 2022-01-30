<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Home extends CI_Controller {

  public function __construct()
  {
    parent::__construct();
    $this->load->model('model');
    $this->load->model('m_tabel_ss');
  }
  
  function index(){
    if ($this->input->post('proses') == "get_produk") {
      $list = $this->m_tabel_ss->get_datatables(array('kode_barang','nama','jumlah','harga_jual'),array('kode_barang','nama','jumlah','harga_jual',null),array('no' => 'desc'),"tb_barang",null,null,"*");
      $data = array();
      $no = $_POST['start'];
      foreach ($list as $field) {

        $no++;
        $row = array();
        // $row[] = $no;
        $row[] = $field->kode_barang;
        $row[] = $field->nama;
        $row[] = $field->jumlah;       
        $row[] = $field->harga_jual;       
        $row[] = '<button class="btn btn-sm round btn-outline-primary" onclick="cek_stok_produk('.$field->no_barang.')" title="Tambah Stok Produk"><span class="sr-only"></span> <i class="fa fa-edit"></i></button>&nbsp;<a class="example-image-link" href="'.base_url("img/".$field->no_barang."/".$field->foto).'" data-lightbox="example-1">
        <button class="btn btn-sm round btn-outline-success" title="Lihat Foto Produk '.$field->kode_barang.'"> <span class="sr-only"></span> <i class="fa fa-file-image-o"></i> </button> </a> <button class="btn btn-sm round btn-outline-info" onclick="cek_laporan('.$field->no_barang.')" title="Lihat Laporan Produk"> <span class="sr-only"></span>
        <i class="fa fa-list"></i> </button>&nbsp;<button class="btn btn-sm round btn-outline-primary" onclick="cek_detail_barang('.$field->no_barang.')" title="Edit Detail Barang '.$field->kode_barang.'"><span class="sr-only"></span> <i class="fa fa-pencil-square"></i></button>';
        $data[] = $row;
      }

      $output = array(
        "draw" => $_POST['draw'],
        "recordsTotal" => $this->m_tabel_ss->count_all("tb_barang",null,null,"*"),
        "recordsFiltered" => $this->m_tabel_ss->count_filtered(array('kode_barang','nama','jumlah','harga_jual'),array('kode_barang','nama','jumlah','harga_jual',null),array('no' => 'desc'),"tb_barang",null,null,"*"),
        "data" => $data,
      );
      //output dalam format JSON
      echo json_encode($output);
    }

    if ($this->input->post('proses') == "get_produk_laporan") {
      $list = $this->m_tabel_ss->get_datatables(array('no_barang','status','waktu'),array('waktu','status','ket',),array('no_log' => 'desc'),"tb_log_history",null,['no_barang' => $this->input->post('id')],"*");
      $data = array();
      $no = $_POST['start'];
      foreach ($list as $field) {
        $json = json_decode($field->ket);
        $text = null;
        if($field->status == 'Penambahan Produk Baru'){
          $text = ' Kode Barang : '.$json->kode_barang.'<br>Nama Barang : '.$json->nama.'<br>Harga Jual : Rp. '.$json->harga_jual.'<br>Jumlah : '.$json->jumlah.'<br>Pembelian Stok : Rp. '.$json->pembelian_stok;
        }else if($field->status == 'Penambahan Stok'){
          $text = 'Penambahan Stok: '.$json->penambahan_stok.'<br>Harga Pembelian Stok : Rp. '.$json->harga_pembelian_stok.'<br>Jumlah Stok Sebelumnya : '.$json->jumlah_stok_sebelumnya.'<br>Total Stok : '.$json->total_stok;#region;
        }else if($field->status == 'Edit Detail Produk'){
          $nama = ($json->nama_lama == $json->nama_baru) ? null : 'Nama : '.$json->nama_lama.' => '.$json->nama_baru;
          $harga = ($json->harga_lama == $json->harga_baru) ? null : 'Harga : Rp. '.$json->harga_lama.' => Rp. '.$json->harga_baru;
          $foto = ($json->foto_lama == $json->foto_baru) ? null : 'Foto : '.$json->foto_lama.' => '.$json->foto_baru;
          $text = $nama.(($harga != null)?'<br>':null).$harga.(($foto != null)?'<br>':null).$foto;
        }else if($field->status == 'Penjualan Barang Spesifik'){
          $text = "Jumlah Pembelian : ".$json->jumlah_pembelian."<br>Harga Jual : Rp. ".$json->harga_jual."<br>Total Penjualan : Rp. ".$json->total_harga."<br>Stok Sebelumnya : ".$json->stok_sebelumnya."<br>Stok Terbaru : ".$json->stok_sekarang;
        }


        $no++;
        $row = array();
        // $row[] = $no;
        $row[] = $field->waktu;
        $row[] = ($field->status == "Penjualan Barang Spesifik") ? "Penjualan Produk" :$field->status;
        $row[] = $text;              
        $data[] = $row;
      }
      

      $output = array(
        "draw" => $_POST['draw'],
        "recordsTotal" => $this->m_tabel_ss->count_all("tb_log_history",null,['no_barang' => $this->input->post('id')],"*"),
        "recordsFiltered" => $this->m_tabel_ss->count_filtered(array('no_barang','status','waktu'),array('waktu','status','ket',),array('no_log' => 'desc'),"tb_log_history",null,['no_barang' => $this->input->post('id')],"*"),
        "data" => $data,
      );
      //output dalam format JSON
      echo json_encode($output);
    }

    if ($this->input->post('proses') == "get_laporan") {
      $list = $this->m_tabel_ss->get_datatables(array('no_barang','status','waktu'),array('waktu','status',null,null,null,null),array('no_log' => 'desc'),"tb_log_history",null,"status !='Penjualan Barang Spesifik' ","*");
      $data = array();
      $no = $_POST['start'];
      foreach ($list as $field) {
        $json = json_decode($field->ket);
        $text = null;
        $stok_sebelumnya = "-";
        $stok_terbaru = "-";
        $kode_barang = '-';
        if($field->status == 'Penambahan Produk Baru'){
          $text = ' Kode Barang : '.$json->kode_barang.'<br>Nama Barang : '.$json->nama.'<br>Harga Jual : Rp. '.$json->harga_jual.'<br>Jumlah : '.$json->jumlah.'<br>Pembelian Stok : Rp. '.$json->pembelian_stok;
          $stok_sebelumnya = '-';
          $stok_terbaru = $json->jumlah;
        }else if($field->status == 'Penambahan Stok'){
          $text = 'Penambahan Stok: '.$json->penambahan_stok.'<br>Harga Pembelian Stok : Rp. '.$json->harga_pembelian_stok.'<br>Jumlah Stok Sebelumnya : '.$json->jumlah_stok_sebelumnya.'<br>Total Stok : '.$json->total_stok;
          $stok_sebelumnya = $json->jumlah_stok_sebelumnya;
          $stok_terbaru = $json->total_stok;
        }else if($field->status == 'Edit Detail Produk'){
          $nama = ($json->nama_lama == $json->nama_baru) ? null : 'Nama : '.$json->nama_lama.' => '.$json->nama_baru;
          $harga = ($json->harga_lama == $json->harga_baru) ? null : 'Harga : Rp. '.$json->harga_lama.' => Rp. '.$json->harga_baru;
          $foto = ($json->foto_lama == $json->foto_baru) ? null : 'Foto : '.$json->foto_lama.' => '.$json->foto_baru;
          $text = $nama.(($harga != null)?'<br>':null).$harga.(($foto != null)?'<br>':null).$foto;
        }else if($field->status == 'Penjualan Produk'){
          $text = '<button class="btn btn-primary btn-sm text-center"
          onclick="info_penjualan('.$field->no_log.')">Info Penjualan</button>';
        }

        if($field->status != 'Penjualan Produk'){
          $cek_data = $this->model->tampil_data_where('tb_barang',array('no_barang' => $field->no_barang))->result()[0];
          $kode_barang = $cek_data->kode_barang;
        }

        $no++;
        $row = array();
        // $row[] = $no;
        $row[] = $field->waktu;
        $row[] = $field->status;
        $row[] = $kode_barang;
        $row[] = $stok_sebelumnya;
        $row[] = $stok_terbaru;
        $row[] = $text;              
        $data[] = $row;
      }
      

      $output = array(
        "draw" => $_POST['draw'],
        "recordsTotal" => $this->m_tabel_ss->count_all("tb_log_history",null,"status !='Penjualan Barang Spesifik' ","*"),
        "recordsFiltered" => $this->m_tabel_ss->count_filtered(array('no_barang','status','waktu'),array('waktu','status',null,null,null,null),array('no_log' => 'desc'),"tb_log_history",null,"status !='Penjualan Barang Spesifik' ","*"),
        "data" => $data,
      );
      //output dalam format JSON
      echo json_encode($output);
    }

    
    ////// dibawah simpan untuk referensi ////
    if ($this->input->post('proses') == "table_list_guru_simpanan_wajib") {
      $list = $this->m_tabel_ss->get_datatables(array('nik_user','nama'),array(null, 'nik_user','nama',null,null,null),array('tanggaL_daftar' => 'desc'),"tb_user",null,['status' => 'aktif'],"*");
      $data = array();
      $no = $_POST['start'];
      function date_simpanan_wajib($a,$b)
      {
        return strcmp($a['tanggal_simpanan'],$b['tanggal_simpanan']);
      }
      foreach ($list as $field) {
        

        $simpanan_wajib = json_decode($field->simpanan_wajib,true) ?? null;
        if($simpanan_wajib != null){

          
          /// atur kembali array berdasarkan tanggal
          usort($simpanan_wajib , 'date_simpanan_wajib');
          end($simpanan_wajib); 
          $key = key($simpanan_wajib);
          $simpanan_wajib = $simpanan_wajib[$key];
          ////pilih array yg terakhir dari key
          
        }

        $no++;
        $row = array();
        $row[] = $no;
        $row[] = $field->nik_user;
        $row[] = $field->nama;
        $row[] = $simpanan_wajib['tanggal_simpanan'] ?? 'Belum Pernah Melakukan Simpanan Wajib ';
        $row[] = ($simpanan_wajib) ? 'Rp. '.number_format( $simpanan_wajib['simpanan']) : '-';
        $row[] = '<center><button type="button" onclick="detail_user('.$field->nik_user.')" class="btn btn-primary btn-circle btn-sm waves-effect waves-light"><i class="ico fa fa-edit"></i></button></center>';
        $data[] = $row;
      }

      $output = array(
        "draw" => $_POST['draw'],
        "recordsTotal" => $this->m_tabel_ss->count_all("tb_user",null,['status' => 'aktif'],"*"),
        "recordsFiltered" => $this->m_tabel_ss->count_filtered(array('nik_user','nama'),array(null, 'nik_user','nama',null,null,null),array('tanggaL_daftar' => 'desc'),"tb_user",null,['status' => 'aktif'],"*"),
        "data" => $data,
      );
      //output dalam format JSON
      echo json_encode($output);
    }
    //// diatas simpan untuk referensi ////
    
    

   

   

  }

  function coba(){
    print_r('coba');
  }

  // function coba2(){
  //   $i = 1;
  //   $bulan = '02';
  //   $tahun = '2021';
  //   $cek_data = $this->model->tampil_data_keseluruhan('tb_user')->result();

  //   // $array_simpnanan_wajib_detail =[];
  //   $data=null;
  //   foreach ($cek_data as $key => $value) {
  //     $ket_simpanan_wajib = json_decode($value->simpanan_wajib,true) ?? null;
      
      
  //     if ($ket_simpanan_wajib !=null) {
  //       foreach ($ket_simpanan_wajib as $key1 => $value1) {
  //         $datetime = new DateTime($value1['tanggal_simpanan']);
  //         $bulannya = $datetime->format('m');
  //         $tahunnya = $datetime->format('Y');
          
  //         if($bulannya == $bulan and $tahunnya == $tahun){
  //           $data[$i]['nik_user'] = $value->nik_user;
  //           $data[$i]['nama'] = $value->nama;
  //           $data[$i]['tanggal_simpanan'] = $value1['tanggal_simpanan'];
  //           $data[$i]['simpanan'] = $value1['simpanan'];
  //           $i ++;
  //         }  
          
          
  //       }
  //     }

  //   }

  //   // print_r($data);



  //     function date_simpanan($a,$b)
  //     {
  //       return strcmp($a['tanggal_simpanan'],$b['tanggal_simpanan']);
  //     }
      
  //     if($data != null){
  //       // $ket = json_decode($cek_data[0]->simpanan_wajib,true);
        
  //       $ii = 1;
  //       /// atur kembali array berdasarkan tanggal
  //       usort($data , 'date_simpanan');
  //       foreach ($data as $key => $value) {
  //         $data1[$ii]['no'] = $ii;
  //         $data1[$ii]['nik'] = $value['nik_user'];
  //         $data1[$ii]['nama'] = $value['nama'];
  //         $data1[$ii]['tanggal_simpanan'] = $value['tanggal_simpanan'];
  //         $data1[$ii]['simpanan'] = 'Rp. '. number_format($value['simpanan']);
  //         // $data[$ii]['foto'] = $value['foto'];

  //         $ii++;
          
  //       }
  //       // print_r($data1);
  //       $out = array_values($data1);
  //       echo json_encode($out);
  //     }
  //     else
  //     {
  //       echo json_encode(array());
  //     }
  // }


  

   
}
