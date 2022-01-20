async function check_user() {
  //create let variable no_user = localStorage.getItem('no_user') , username = localStorage.getItem('username') , password = localStorage.getItem('password')
  let no_user = localStorage.getItem('no_user')
  let username = localStorage.getItem('username')
  let password = localStorage.getItem('password')
  try {
    //create fetch 
    const response = await fetch(`http://localhost/ilham/server/api/cek_user?id=${no_user}&username=${username}&password=${password}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + btoa('Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73')
      }
    });
    //if response status  = 200 then console.log("ok") else console.log("not ok")
    if (response.status === 200) {
      //create json
      const json = await response.json();
      console.log(json)
    }
    else {
      localStorage.removeItem('no_user')
      localStorage.removeItem('username')
      localStorage.removeItem('password')
      window.location.href = 'index.html'
    }
  } catch (error) {
    localStorage.removeItem('no_user')
    localStorage.removeItem('username')
    localStorage.removeItem('password')
    window.location.href = 'index.html'
  }
}

check_user()

// create function to check the file name and size
function check_file(file) {
  //create let variable file_name = file.name , file_size = file.size
  let file_name = file.name
  let file_size = file.size
  //create if file_size > 1000000 then alert("File size is too big") else if file_name.length > 50 then alert("File name is too long") else return true
  if (file_size > 1500000) {
    toastr.error("Maksimal ukuran file adalah 1.5 MB")
    //input id=foto = null
    document.getElementById('foto').value = null
    document.getElementById('foto').focus()
    return false
  }
  // else if filename != .jpg  .png  then toast("File type is not allowed")

  else if (file_name.substr(file_name.length - 4) != ".jpg" && file_name.substr(file_name.length - 4) != ".png") {
    toastr.error("File type is not allowed")
    document.getElementById('foto').value = null
    document.getElementById('foto').focus()
    return false
  }

  else {
    return true
  }
}

const elem = [document.getElementById("harga_jual"), document.getElementById("harga_pembelian_stok")];


function input_numbers_comma(elem) {
  for (let i = 0; i < elem.length; i++) {
    let elem1 = elem[i]
    if (elem1) {
      elem1.addEventListener("keydown", function (event) {
        var key = event.which;
        if ((key < 48 || key > 57) && key != 8) event.preventDefault();
      });

      elem1.addEventListener("keyup", function (event) {
        var value = this.value.replace(/,/g, "");
        this.dataset.currentValue = parseInt(value);
        var caret = value.length - 1;
        while ((caret - 3) > -1) {
          caret -= 3;
          value = value.split('');
          value.splice(caret + 1, 0, ",");
          value = value.join('');
        }
        this.value = value;
      });
    }


  }
}
input_numbers_comma(elem)



function isNumberKey(evt) {
  var charCode = (evt.which) ? evt.which : evt.keyCode
  if (charCode > 31 && (charCode < 48 || charCode > 57))
    return false;
  return true;
  // console.log(evt.key)
}

function sedang_proses() {
  $.blockUI({
    message: "Sedang Diproses",
    css: {
      border: 'none',
      padding: '15px',
      backgroundColor: '#000',
      '-webkit-border-radius': '10px',
      '-moz-border-radius': '10px',
      opacity: .5,
      color: '#fff'
    }
  });
}

// sedang_proses()

// create function remove_comma from number
function remove_comma(no) {
  //create let variable no = no.replace(/,/g, '')
  let number = no.replace(/,/g, '')
  return number
}

// create function add_comma thousand separator to number
function add_comma(no) {
  //create let variable no = no.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
  let number = no.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
  return number
}

//function nama bulan berdasarkan angka
function nama_bulan(no) {
  let bulan = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember']
  return bulan[no - 1]  //return bulan[no - 1]  
  
}
