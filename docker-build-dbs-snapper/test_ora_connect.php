<?php
$conn = oci_connect('monitoring', 'monitoring', 'server/sid');
if (!$conn) {
    print("connection error\n");
    $e = oci_error();
    trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
}else{
    print("connected\n");
}

?>
