<?php
  $file = 'people.txt';
  // Open the file to get existing content
  $current = file_get_contents($file);
  // Append a new person to the file
  $current .= "John Smith\n";
  // Write the contents back to the file
  file_put_contents($file, $current);
?>

<?php
function file_force_contents( $fullPath, $contents, $flags = 0 ){
    $parts = explode( '/', $fullPath );
    array_pop( $parts );
    $dir = implode( '/', $parts );
   
    if( !is_dir( $dir ) )
        mkdir( $dir, 0777, true );
   
    file_put_contents( $fullPath, $contents, $flags );
}

file_force_contents( ROOT.'/newpath/file.txt', 'message', LOCK_EX );
?>
