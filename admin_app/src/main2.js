async function cek_connection()  {
  var cek = false;
  //create try catch
  $.blockUI({
    message: "Cek Koneksi...",
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
  try{
    //create fetch
    const response = await fetch(`http://localhost/ilham/server/api/`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + btoa('Kicap_karan:bb10c6d9f01ec0cb16726b59e36c2f73')
      }
    });

    if(response.status === 200) {
      cek = true;
    }

    
  }catch(e){
    // return false;
    cek = false;
  }

  if (cek == false) {
    window.location.replace("customurl://");    
  }
  $.unblockUI();
}

cek_connection();